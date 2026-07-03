module KindeSdk
  class TokenStore
    attr_reader :tokens, :bearer_token, :expires_at

    def initialize(tokens = nil)
      set_tokens(tokens) if tokens
    end

    def set_tokens(tokens)
      @tokens = TokenHash.normalize(tokens)
      @bearer_token = @tokens[:access_token]
      @expires_at = @tokens[:expires_at]
      @tokens
    end

    def to_session
      {
        access_token: @bearer_token,
        refresh_token: @tokens[:refresh_token],
        expires_at: @expires_at
      }
    end

    def self.from_session(session_data)
      return nil unless session_data
      new(session_data)
    end
  end
end 