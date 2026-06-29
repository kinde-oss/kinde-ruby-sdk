module KindeSdk
  # Normalizes token hashes so the SDK does not depend on oauth2's #to_hash key format.
  # Accepts string or symbol keys on input; internal storage uses symbol keys.
  module TokenHash
    KEYS = %i[access_token refresh_token expires_at id_token scope token_type expires_in].freeze

    module_function

    def normalize(raw)
      return {} if raw.nil?
      return {} if raw.respond_to?(:empty?) && raw.empty?

      raw.each_with_object({}) do |(key, value), memo|
        sym_key = key.to_sym
        next unless KEYS.include?(sym_key)

        memo[sym_key] = value
      end.tap do |hash|
        hash[:access_token] = hash[:access_token].to_s if hash[:access_token]
      end
    end

    def access_token(raw)
      normalize(raw)[:access_token]
    end

    def from_access_token(token)
      normalize(
        {
          access_token: token.token,
          refresh_token: token.refresh_token,
          expires_at: token.expires_at,
          id_token: token_param(token, "id_token"),
          scope: token_param(token, "scope"),
          token_type: token_param(token, "token_type"),
          expires_in: token_param(token, "expires_in")
        }.compact
      )
    end

    # String keys for session storage and documented public API responses.
    def for_session(raw)
      normalize(raw).transform_keys(&:to_s)
    end

    def token_param(token, key)
      token.params[key] || token.params[key.to_sym]
    end
  end
end
