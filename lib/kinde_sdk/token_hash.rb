module KindeSdk
  # Normalizes token hash key types for oauth2 round-trips and SDK consumers.
  # Accepts string or symbol keys on input; internal storage uses symbol keys.
  module TokenHash
    PUBLIC_KEYS = %i[
      access_token refresh_token expires_at id_token scope token_type expires_in
    ].freeze

    module_function

    # Symbolize keys while preserving the full oauth2 hash contract.
    def normalize(raw)
      return {} if raw.nil?
      return {} if raw.respond_to?(:empty?) && raw.empty?

      raw.each_with_object({}) do |(key, value), memo|
        memo[key.to_sym] = value
      end.tap do |hash|
        hash[:access_token] = hash[:access_token].to_s if hash[:access_token]
      end
    end

    def access_token(raw)
      normalize(raw)[:access_token]
    end

    # Reduced shape for documented public SDK responses (e.g. fetch_tokens).
    def public_tokens(raw)
      normalize(raw).slice(*PUBLIC_KEYS).compact
    end

    def from_access_token(token)
      public_tokens(
        access_token: token.token,
        refresh_token: token.refresh_token,
        expires_at: token.expires_at,
        id_token: token_param(token, "id_token"),
        scope: token_param(token, "scope"),
        token_type: token_param(token, "token_type"),
        expires_in: token_param(token, "expires_in")
      )
    end

    # String keys for session storage and documented public API responses.
    def for_session(raw)
      public_tokens(raw).transform_keys(&:to_s)
    end

    # Full oauth2 hash with string keys for refresh_token responses.
    def for_refresh_response(raw)
      normalize(raw).transform_keys(&:to_s)
    end

    def token_param(token, key)
      token.params[key] || token.params[key.to_sym]
    end
  end
end
