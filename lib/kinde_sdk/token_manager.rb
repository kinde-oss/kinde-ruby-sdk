module KindeSdk
  class TokenManager
    include Logging

    attr_reader :tokens, :bearer_token, :expires_at

    def initialize(tokens = nil)
      set_tokens(tokens) if tokens
    end

    def set_tokens(tokens)
      @tokens = tokens.transform_keys(&:to_sym).freeze
      @bearer_token = @tokens[:access_token]
      @expires_at = @tokens[:expires_at]
      @tokens
    end

    def token_expired?
      return true if @tokens.nil? || @tokens.empty?
      begin
        KindeSdk.validate_jwt_token(@tokens)
        @expires_at.to_i > 0 && (@expires_at <= Time.now.to_i)
      rescue StandardError => e
        log_error("Error checking token expiration: #{e.message}")
        true
      end
    end

    def clear_tokens
      @tokens = nil
      @bearer_token = nil
      @expires_at = nil
    end

    class << self
      extend KindeSdk::Logging

      def create_store(tokens = nil)
        TokenStore.new(tokens)
      end

      def refresh_tokens(store, session = nil)
        return nil unless store&.tokens
        new_tokens = safe_refresh(store.tokens)
        return nil unless new_tokens
        store.set_tokens(new_tokens)
        sync_session(store, session)
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
        return true unless validate_tokens(store)
        store.expires_at.to_i > 0 && (store.expires_at <= Time.now.to_i)
      end

      def clear_tokens(store, session = nil)
        store.set_tokens(nil)
        target_session = session || Current.session
        target_session&.delete(:kinde_token_store)
      end

      private

      def safe_refresh(tokens)
        KindeSdk.refresh_token(tokens)
      rescue StandardError => e
        log_error("Token refresh failed: #{e.message}")
        nil
      end

      def sync_session(store, session)
        return unless (session || Current.session) && store.tokens
        target_session = session || Current.session
        target_session[:kinde_token_store] = store.to_session
      end
    end
  end
end
