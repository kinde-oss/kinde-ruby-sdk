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
      session_data = {
        access_token: @bearer_token,
        refresh_token: @tokens[:refresh_token],
        expires_at: @expires_at
      }
      
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
          decrypted_data[key] = KindeSdk::KSP.decrypt(value.to_s)
        end
        return new(decrypted_data)
      end
      
      new(session_data)
    end
  end
end
