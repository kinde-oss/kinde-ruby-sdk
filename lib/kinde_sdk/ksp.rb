require 'openssl'
require 'base64'
require 'securerandom'
require 'json'
require 'digest'

module KindeSdk
  # Kinde Key Storage Provider (KSP)
  # 
  # Enterprise-grade encryption for sensitive token storage.
  # Provides AES-256-GCM encryption with automatic key management.
  #
  # @example Basic usage
  #   KindeSdk::KSP.enable
  #   encrypted = KindeSdk::KSP.encrypt("sensitive data")
  #   decrypted = KindeSdk::KSP.decrypt(encrypted)
  #
  # @example Production setup
  #   KindeSdk::KSP.enable(strict: true)
  #
  class KSP
    CIPHER_METHOD = 'aes-256-gcm'.freeze
    KEY_LENGTH = 32
    IV_LENGTH = 12
    
    class << self
      attr_reader :enabled, :strict, :key_id
      
      @key_id = 'default'
      
      # Enable KSP with automatic setup
      #
      # @param options [Hash] Configuration options
      # @option options [String] :key Custom encryption key (base64 encoded)
      # @option options [String] :env_var Environment variable name (default: 'KINDE_KSP_KEY')
      # @option options [Boolean] :auto_generate Auto-generate key if missing (default: true)
      # @option options [Boolean] :strict Fail closed if KSP cannot start (default: false)
      # @return [Boolean] True if KSP was successfully enabled
      #
      # @example
      #   KindeSdk::KSP.enable
      #   KindeSdk::KSP.enable(strict: true)
      #   KindeSdk::KSP.enable(key: "your_base64_encoded_key")
      #
      def enable(options = {})
        return true if @enabled
        
        env_var = options[:env_var] || 'KINDE_KSP_KEY'
        auto_generate = options.fetch(:auto_generate, true)
        @strict = options.fetch(:strict, false)
        
        # Check system requirements first
        requirements = check_requirements
        unless requirements[:all_passed]
          missing = requirements.select { |k, v| k != :all_passed && !v }.keys.join(', ')
          message = "System requirements not met: #{missing}"
          handle_error(message)
          return false
        end
        
        begin
          # Try to get key from various sources
          @key = get_encryption_key(options[:key], env_var, auto_generate)
          
          unless @key
            message = 'No encryption key available'
            handle_error(message)
            return false
          end
          
          @key_id = Digest::SHA256.digest(@key).unpack1('H*')[0, 8]
          @enabled = true
          
          return true
          
        rescue StandardError => e
          message = "KSP initialization failed: #{e.message}"
          handle_error(message, e)
          return false
        end
      end
      
      # Disable KSP
      # @return [void]
      def disable
        @enabled = false
        @strict = false
        @key = nil
        @key_id = 'default'
      end
      
      def enabled?
        @enabled && !@key.nil?
      end
      
      # Encrypt data using AES-256-GCM
      #
      # @param data [String] The data to encrypt
      # @return [String] Base64-encoded encrypted envelope
      # @raise [RuntimeError] In strict mode if encryption fails
      #
      # @example
      #   encrypted = KindeSdk::KSP.encrypt("sensitive data")
      #
      def encrypt(data)
        unless enabled?
          return handle_encryption_disabled(data, 'encrypt')
        end
        
        # Handle nil data appropriately
        if data.nil?
          if @strict
            raise ArgumentError, 'Cannot encrypt nil data in strict mode'
          else
            data = ''
          end
        end
        
        # Store original encoding for restoration
        original_encoding = data.respond_to?(:encoding) ? data.encoding : nil
        
        begin
          cipher_for_iv = OpenSSL::Cipher.new(CIPHER_METHOD)
          iv_len = cipher_for_iv.iv_len > 0 ? cipher_for_iv.iv_len : IV_LENGTH
          iv = SecureRandom.random_bytes(iv_len)
          
          cipher = OpenSSL::Cipher.new(CIPHER_METHOD)
          cipher.encrypt
          cipher.key = @key
          cipher.iv = iv
          
          encrypted_data = cipher.update(data.to_s) + cipher.final
          auth_tag = cipher.auth_tag
          
          # Create versioned payload envelope
          payload = {
            v: 1,
            k: @key_id,
            iv: Base64.strict_encode64(iv),
            tag: Base64.strict_encode64(auth_tag),
            data: Base64.strict_encode64(encrypted_data),
            enc: original_encoding&.name
          }
          
          Base64.strict_encode64(payload.to_json)
          
        rescue StandardError => e
          message = "KSP encryption failed: #{e.message}"
          if @strict || enabled?
            raise RuntimeError, message
          else
            log_error(message)
            return data
          end
        end
      end
      
      # Decrypt data using AES-256-GCM
      #
      # @param encrypted_data [String] The base64-encoded encrypted envelope
      # @return [String] The decrypted data
      # @raise [RuntimeError] In strict mode if decryption fails
      #
      # @example
      #   decrypted = KindeSdk::KSP.decrypt(encrypted_data)
      #
      def decrypt(encrypted_data)
        unless enabled?
          return handle_encryption_disabled(encrypted_data, 'decrypt')
        end
        
        # Check if data appears encrypted
        unless looks_encrypted?(encrypted_data)
          if @strict
            raise RuntimeError, 'Data does not appear encrypted in strict mode'
          else
            return encrypted_data
          end
        end
        
        begin
          # Decode the envelope
          envelope = Base64.strict_decode64(encrypted_data)
          payload = JSON.parse(envelope, symbolize_names: true)
          
          # Validate payload structure
          unless payload.key?(:iv) && payload.key?(:tag) && payload.key?(:data)
            raise RuntimeError, 'Invalid encrypted data format'
          end
          
          # Decode components
          iv = Base64.strict_decode64(payload[:iv]) rescue false
          auth_tag = Base64.strict_decode64(payload[:tag]) rescue false  
          ciphertext = Base64.strict_decode64(payload[:data]) rescue false
          
          # Validate component lengths for security
          validate_component_lengths(iv, auth_tag, ciphertext)
          
          decipher = OpenSSL::Cipher.new(CIPHER_METHOD)
          decipher.decrypt
          decipher.key = @key
          decipher.iv = iv
          decipher.auth_tag = auth_tag
          
          result = if ciphertext.empty?
            decipher.final
          else
            decipher.update(ciphertext) + decipher.final
          end
          
          # Restore original encoding if available
          if payload[:enc]
            begin
              if payload[:enc] == 'ASCII-8BIT' || payload[:enc] == 'BINARY'
                result.force_encoding('ASCII-8BIT')
              elsif defined?(Encoding.const_get(payload[:enc]))
                restored = result.force_encoding(payload[:enc])
                result = restored.valid_encoding? ? restored : result.force_encoding('ASCII-8BIT')
              else
                result.force_encoding('ASCII-8BIT')
              end
            rescue StandardError
              result.force_encoding('ASCII-8BIT')
            end
          else
            result.force_encoding(result.ascii_only? ? 'UTF-8' : 'ASCII-8BIT')
          end
          
        rescue StandardError => e
          message = "KSP decryption failed: #{e.message}"
          if @strict
            raise RuntimeError, message
          else
            log_error(message)
            return encrypted_data
          end
        end
      end
      
      # Generate a new base64-encoded encryption key
      # @return [String] Base64-encoded encryption key
      def generate_key
        Base64.strict_encode64(SecureRandom.random_bytes(KEY_LENGTH))
      end
      
      def status
        {
          enabled: @enabled,
          key_available: !@key.nil?,
          key_id: @key_id,
          cipher_method: CIPHER_METHOD,
          strict_mode: @strict,
          requirements_met: check_requirements[:all_passed]
        }
      end
      
      def quick_setup
        requirements = check_requirements
        result = {
          requirements: requirements,
          key_generated: false,
          key_existed: false,
          enabled: false,
          status: {}
        }
        
        unless requirements[:all_passed]
          result[:error] = 'System requirements not met'
          return result
        end
        
        key_exists = ENV['KINDE_KSP_KEY'] && !ENV['KINDE_KSP_KEY'].empty?
        result[:key_existed] = key_exists
        
        enabled = enable
        result[:enabled] = enabled
        result[:status] = status
        
        if enabled && @key_id
          result[:key_fingerprint] = @key_id
          result[:key_generated] = !key_exists if enabled
        end
        
        result
      end
      
      # Integration hook for storage operations
      def storage_hook(operation, data)
        case operation.to_s
        when 'store'
          encrypt(data)
        when 'retrieve'
          decrypt(data)
        else
          data
        end
      end
      
      def wrap_storage(storage)
        StorageWrapper.new(storage)
      end
      
      private
      
      def check_requirements
        requirements = {
          openssl: !!defined?(OpenSSL),
          json: !!defined?(JSON),
          securerandom: !!defined?(SecureRandom),
          base64: !!defined?(Base64),
          digest: !!defined?(Digest)
        }
        
        begin
          cipher = OpenSSL::Cipher.new(CIPHER_METHOD)
          requirements[:aes_256_gcm] = true
        rescue StandardError
          requirements[:aes_256_gcm] = false
        end
        
        requirements[:all_passed] = requirements.values.all?
        requirements
      end
      
      # Get encryption key from various sources
      # @param custom_key [String, nil] Custom key provided directly
      # @param env_var [String] Environment variable name
      # @param auto_generate [Boolean] Whether to auto-generate if missing
      # @return [String, nil] The raw encryption key bytes
      def get_encryption_key(custom_key, env_var, auto_generate)
        # Try custom key first
        if custom_key
          return validate_and_prepare_key(custom_key)
        end
        
        # Try environment variable
        env_key = ENV[env_var]
        if env_key && !env_key.empty?
          return validate_and_prepare_key(env_key)
        end
        
        # Auto-generate if allowed
        if auto_generate
          new_key = generate_key
          begin
            ENV[env_var] = new_key
          rescue StandardError
            # Ignore ENV assignment errors
          end
          return validate_and_prepare_key(new_key)
        end
        
        # No key available and auto-generation disabled
        if @strict
          raise RuntimeError, "No #{env_var} provided in strict mode"
        end
        
        nil
      end
      
      # Validate and prepare encryption key
      # @param key [String] Base64-encoded key
      # @return [String] Raw key bytes
      # @raise [ArgumentError] If key is invalid
      def validate_and_prepare_key(key)
        return nil if key.nil? || key.empty?
        
        begin
          decoded = Base64.strict_decode64(key.to_s)
        rescue ArgumentError
          raise ArgumentError, 'Invalid key format or length'
        end
        
        unless decoded.bytesize == KEY_LENGTH
          raise ArgumentError, 'Invalid key format or length'
        end
        
        decoded
      end
      
      # Check if data looks encrypted
      # @param data [String] The data to check
      # @return [Boolean] True if data appears to be KSP-encrypted
      def looks_encrypted?(data)
        return false unless data.is_a?(String)
        return false if data.empty?
        
        decoded = Base64.strict_decode64(data)
        parsed = JSON.parse(decoded, symbolize_names: true)
        parsed.is_a?(Hash) && parsed.key?(:v) && parsed.key?(:iv) && parsed.key?(:tag) && parsed.key?(:data)
      rescue StandardError
        false
      end
      
      def validate_component_lengths(iv, auth_tag, ciphertext)
        cipher_for_iv = OpenSSL::Cipher.new(CIPHER_METHOD)
        expected_iv_len = cipher_for_iv.iv_len > 0 ? cipher_for_iv.iv_len : IV_LENGTH
        unless iv.bytesize == expected_iv_len
          raise RuntimeError, 'Invalid IV length'
        end
        
        tag_len = auth_tag.is_a?(String) ? auth_tag.bytesize : 0
        if auth_tag == false || tag_len < 12 || tag_len > 16
          raise RuntimeError, 'Invalid tag length'
        end
        
        if ciphertext == false
          raise RuntimeError, 'Invalid ciphertext'
        end
      end
      
      def handle_encryption_disabled(data, operation)
        if @strict
          raise RuntimeError, "KSP is disabled - cannot #{operation} in strict mode"
        else
          return data
        end
      end
      
      def handle_error(message, exception = nil)
        if @strict
          raise RuntimeError, message
        else
          log_error(message)
        end
      end
      
      def log_error(message)
        if defined?(Rails) && Rails.logger
          Rails.logger.error(message)
        else
          $stderr.puts message
        end
      end
    end
    
    class StorageWrapper
      def initialize(storage)
        @storage = storage
      end
      
      def set_item(key, value)
        if value.is_a?(String)
          begin
            value = KindeSdk::KSP.encrypt(value)
          rescue StandardError
            # Graceful fallback - store original value
          end
        end
        @storage.set_item(key, value)
      end
      
      def get_item(key, default = nil)
        value = @storage.get_item(key, default)
        if value.is_a?(String) && value != default
          begin
            value = KindeSdk::KSP.decrypt(value)
          rescue StandardError
            # Graceful fallback - return original value
          end
        end
        value
      end
      
      def remove_item(key)
        @storage.remove_item(key)
      end
      
      def clear
        @storage.clear if @storage.respond_to?(:clear)
      end
      
      def method_missing(method, *args, &block)
        if @storage.respond_to?(method)
          @storage.send(method, *args, &block)
        else
          super
        end
      end
      
      def respond_to_missing?(method, include_private = false)
        @storage.respond_to?(method, include_private) || super
      end
    end
  end
end
