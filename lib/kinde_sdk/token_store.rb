module KindeSdk
  class TokenStore
    # KSP session duration constants (matching other Kinde SDKs)
    TWENTY_NINE_DAYS_SECONDS = 2505600 # 29 days in seconds
    
    attr_reader :tokens, :bearer_token, :expires_at, :persistent

    def initialize(tokens = nil)
      @persistent = true # Default to persistent sessions for security
      set_tokens(tokens) if tokens
    end

    def set_tokens(tokens)
      @tokens = (tokens || {}).transform_keys(&:to_sym)
      @bearer_token = @tokens[:access_token]
      @expires_at = @tokens[:expires_at]
      
      # Extract KSP (Kinde Session Persistence) claim from access token
      if @bearer_token
        @persistent = extract_ksp_persistence(@bearer_token)
      end
      
      @tokens
    end

    def to_session
      {
        access_token: @bearer_token,
        refresh_token: @tokens[:refresh_token],
        expires_at: @expires_at,
        persistent: @persistent
      }
    end

    def self.from_session(session_data)
      return nil unless session_data
      store = new(session_data)
      # Restore persistence state if available
      if session_data.key?(:persistent) || session_data.key?('persistent')
        store.instance_variable_set(:@persistent, session_data[:persistent] || session_data['persistent'])
      end
      store
    end
    
    # Get cookie expiration based on persistence setting
    # Returns Time for persistent cookies or nil for session cookies
    # @return [Time, nil] Cookie expiration time or nil for session cookies
    def cookie_expiration
      @persistent ? (Time.now + TWENTY_NINE_DAYS_SECONDS) : nil
    end
    
    private
    
    # Extract KSP persistence claim from JWT access token
    # Implements same logic as TypeScript SDK: payload.ksp?.persistence ?? true
    # @param access_token [String] JWT access token
    # @return [Boolean] true for persistent sessions, false for session-only
    def extract_ksp_persistence(access_token)
      return true if access_token.nil? || access_token.empty?
      
      payload = JWT.decode(access_token, nil, false).first
      ksp_claim = payload['ksp']
      
      # Return true unless ksp.persistence is explicitly false
      return true unless ksp_claim.is_a?(Hash)
      ksp_claim.fetch('persistence', true) != false
    rescue JWT::DecodeError, StandardError
      # Fail safely: default to persistent sessions for security
      true
    end
  end
end 