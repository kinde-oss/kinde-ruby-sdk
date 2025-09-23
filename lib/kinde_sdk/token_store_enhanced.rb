module KindeSdk
  # Enhanced TokenStore with KSP integration
  class TokenStoreEnhanced
    attr_reader :tokens, :bearer_token, :expires_at

    def initialize(tokens = nil)
      set_tokens(tokens) if tokens
    end

    def set_tokens(tokens)
      @tokens = (tokens || {}).transform_keys(&:to_sym)
      @bearer_token = @tokens[:access_token]
      @expires_at = @tokens[:expires_at]
      @tokens
    end

    def to_session
      return {} unless @tokens
      
      session_data = {
        access_token: @bearer_token,
        refresh_token: @tokens[:refresh_token],
        expires_at: @expires_at
      }
      
      # Include all other tokens beyond the basic ones
      @tokens.each do |key, value|
        unless [:access_token, :refresh_token, :expires_at].include?(key)
          session_data[key] = value
        end
      end
      
      if defined?(KindeSdk::KSP) && KindeSdk::KSP.enabled?
        encrypted_data = {}
        session_data.each do |key, value|
          next unless value
          encrypted_data[key] = KindeSdk::KSP.encrypt(value.to_s)
        end
        return encrypted_data
      end
      
      session_data
    end

    def self.from_session(session_data)
      return nil unless session_data
      
      if defined?(KindeSdk::KSP) && KindeSdk::KSP.enabled?
        decrypted_data = {}
        session_data.each do |key, value|
          next unless value
          decrypted = KindeSdk::KSP.decrypt(value.to_s)
          
          # Convert back to appropriate data type
          case key
          when :expires_at, 'expires_at'
            if decrypted.is_a?(String) && decrypted =~ /^\d+$/
              decrypted_data[key] = decrypted.to_i
            else
              decrypted_data[key] = decrypted
            end
          else
            decrypted_data[key] = decrypted
          end
        end
        return new(decrypted_data)
      end
      
      new(session_data)
    end

    def inspect
      "#<#{self.class.name}:0x#{object_id.to_s(16)} tokens=[FILTERED] bearer_token=[FILTERED] expires_at=#{@expires_at}>"
    end
  end
end
