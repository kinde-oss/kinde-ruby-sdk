module KindeSdk
  class TokenManager
    attr_reader :tokens, :bearer_token, :expires_at

    def initialize(tokens = nil)
      set_tokens(tokens) if tokens
    end

    def set_tokens(tokens)
      @tokens = tokens.transform_keys(&:to_sym)
      @bearer_token = @tokens[:access_token]
      @expires_at = @tokens[:expires_at]
      @tokens
    end

    def token_expired?
      return true unless @tokens.present?
      begin
        KindeSdk.validate_jwt_token(@tokens)
        @expires_at.to_i > 0 && (@expires_at <= Time.now.to_i)
      rescue Exception => e
        Rails.logger.error("Error checking token expiration: #{e.message}")
        true
      end
    end

    def clear_tokens
      @tokens = nil
      @bearer_token = nil
      @expires_at = nil
    end

    class << self
      def create_store(tokens = nil)
        TokenStore.new(tokens)
      end

      def refresh_tokens(store, session = nil)
        return nil unless store&.tokens
        new_tokens = KindeSdk.refresh_token(store.tokens)
        store.set_tokens(new_tokens)
        # Update session if provided
        if (session || Current.session) && new_tokens
          target_session = session || Current.session
          target_session[:kinde_token_store] = store.to_session
        end
        new_tokens
      end

      def validate_tokens(store)
        return false unless store&.tokens
        begin
          KindeSdk.validate_jwt_token(store.tokens)
          true
        rescue JWT::DecodeError, StandardError
          false
        end
      end

      def token_expired?(store)
        return true unless store&.tokens
        begin
          validate_tokens(store)
          store.expires_at.to_i > 0 && (store.expires_at <= Time.now.to_i)
        rescue StandardError
          true
        end
      end

      def clear_tokens(store, session = nil)
        store.set_tokens(nil)
        target_session = session || Current.session
        target_session&.delete(:kinde_token_store)
      end
    end
  end
end 