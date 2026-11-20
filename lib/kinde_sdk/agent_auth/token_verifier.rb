# frozen_string_literal: true

require "jwt"

module KindeSdk
  class AgentAuth
    # The core verifier behind {KindeSdk::AgentAuth#verify_access_token}:
    # introspection (default), local JWT verification, or both.
    #
    # Not to be confused with +KindeSdk::AgentAuth::KindeTokenVerifier+, the
    # optional adapter for the +mcp+ gem, which wraps this class.
    #
    # It does not use +KindeSdk.validate_jwt_token+: that helper takes the
    # allowed algorithms from the JWKS document and checks neither +iss+ nor
    # +aud+.
    #
    # @api private
    class TokenVerifier
      include KindeSdk::Logging

      ALGORITHMS = ["RS256"].freeze
      JWKS_TTL = 3600
      JWKS_MIN_REFRESH_INTERVAL = 60

      # Fixed descriptions. They end up in +WWW-Authenticate+, so none of them
      # may ever be built from token contents.
      MALFORMED = "The access token is malformed"
      NOT_VERIFIED = "The access token could not be verified"
      INACTIVE = "The access token is not active"
      WRONG_ISSUER = "The access token was not issued by this Kinde domain"
      WRONG_AUDIENCE = "The access token was not issued for this resource"
      EXPIRED = "The access token has expired"
      NOT_YET_VALID = "The access token is not valid yet"
      UNUSABLE_JWKS = "Kinde returned an unexpected JWKS"

      # @param config [Config]
      # @param clock [#call] monotonic clock for the JWKS cache
      def initialize(config, clock: CachedDocument::MONOTONIC_CLOCK)
        @config = config
        @jwks = CachedDocument.new(
          config.jwks_url,
          ttl: JWKS_TTL,
          min_refresh_interval: JWKS_MIN_REFRESH_INTERVAL,
          clock: clock,
          prepare: method(:usable_jwks)
        )
      end

      # @param token [String] the raw access token
      # @return [AuthContext]
      # @raise [InvalidTokenError] when the token is rejected
      # @raise [UnavailableError] when Kinde gave no verdict
      def verify(token)
        raise InvalidTokenError, MALFORMED unless token.is_a?(String) && !token.empty?

        case @config.verification
        when "jwt"
          AuthContext.from_claims(token, verify_jwt(token))
        when "jwt+introspection"
          payload = verify_jwt(token)
          context = introspect(token)
          # The call to Kinde took time, and its answer need not carry exp:
          # the signed expiry is checked again before the context is handed out.
          raise InvalidTokenError, EXPIRED unless unexpired?(payload["exp"])

          context
        else
          introspect(token)
        end
      end

      private

      # RFC 7662 introspection at the scoped issuer, with the application's
      # own credentials. The shared /oauth2/introspect is never used.
      def introspect(token)
        status, body = Http.post_form(@config.introspect_url, { token: token }, @config)
        report_rejected_credentials if status == 401
        raise UnavailableError, "Kinde token introspection is unavailable" unless status == 200

        data = Http.parse_json(body)
        raise InvalidTokenError, INACTIVE unless data["active"] == true
        raise InvalidTokenError, WRONG_AUDIENCE unless audience_matches?(data["aud"])
        raise InvalidTokenError, EXPIRED unless data["exp"].nil? || unexpired?(data["exp"])

        # Kinde has just confirmed the token, so its payload can be read
        # without a signature check. permissions, roles and org_code are only there.
        AuthContext.from_claims(token, decode_payload(token).merge(data))
      end

      def report_rejected_credentials
        log_error(
          "Configuration error: Kinde rejected the application credentials at #{@config.introspect_url} " \
          "(HTTP 401). Check that client_id #{@config.client_id} and its client secret belong to the " \
          "AI agents and MCP application."
        )
      end

      def decode_payload(token)
        payload, _header = JWT.decode(token, nil, false)
        raise InvalidTokenError, MALFORMED unless payload.is_a?(Hash)

        payload
      rescue JWT::DecodeError
        raise InvalidTokenError, MALFORMED
      end

      # RS256 only: the jwt gem refuses any other +alg+ before a key is looked up.
      def verify_jwt(token)
        payload, _header = JWT.decode(
          token, nil, true,
          algorithms: ALGORITHMS,
          jwks: method(:load_jwks),
          verify_expiration: false,
          verify_not_before: false
        )
        raise InvalidTokenError, MALFORMED unless payload.is_a?(Hash)

        check_claims(payload)
        payload
      rescue JWT::DecodeError
        raise InvalidTokenError, NOT_VERIFIED
      end

      # Called by the jwt gem: once to find the key, and once more with
      # +kid_not_found+ when the key ID is unknown. The second call asks the
      # cache for a refresh, which it grants at most once a minute.
      def load_jwks(options)
        @jwks.get(force: options[:kid_not_found] == true)
      end

      # Runs on every fetched JWKS; the cache keeps what it returns, and that
      # is the document {#load_jwks} hands to the jwt gem.
      #
      # Entries of a key type the gem cannot import are left out first. jwt
      # 3.3 skips them by itself, but jwt 3.0 to 3.2 raise on the first one,
      # and one such key would then make every token fail.
      #
      # What is left must be usable, or the answer is a failed fetch (retried
      # a few seconds later), not a document to hold on to for an hour: no key
      # list, an entry of a known type that the gem cannot import (it would
      # fail for every token, as "invalid token", before the gem ever asked
      # for a refresh), or no RSA key at all.
      def usable_jwks(document)
        raise UnavailableError, UNUSABLE_JWKS unless document["keys"].is_a?(Array)

        supported = supported_key_types
        entries = document["keys"].reject { |entry| unsupported_key_type?(entry, supported) }
        usable = document.merge("keys" => entries.freeze).freeze
        keys = JWT::JWK::Set.new(usable)
        raise UnavailableError, UNUSABLE_JWKS unless keys.any? { |key| key[:kty] == "RSA" }

        usable
      rescue JWT::DecodeError, ArgumentError
        raise UnavailableError, UNUSABLE_JWKS
      end

      # An entry with no +kty+, or one that is not an object, is not
      # "unsupported": it is malformed, and stays in so that the import fails.
      def unsupported_key_type?(entry, supported)
        return false unless entry.is_a?(Hash) && entry["kty"]

        !supported.include?(entry["kty"].to_s)
      end

      # The +kty+ values the installed jwt gem can import, read from its key
      # classes (the same list it builds its own lookup from).
      def supported_key_types
        JWT::JWK.classes.flat_map do |klass|
          klass.const_defined?(:KTYS) ? Array(klass::KTYS) : []
        end.grep(String)
      end

      def check_claims(payload)
        raise InvalidTokenError, WRONG_ISSUER unless issuer_matches?(payload["iss"])
        raise InvalidTokenError, WRONG_AUDIENCE unless audience_matches?(payload["aud"])
        raise InvalidTokenError, EXPIRED unless unexpired?(payload["exp"])
        raise InvalidTokenError, NOT_YET_VALID unless payload["nbf"].nil? || started?(payload["nbf"])
      end

      # +iss+ is the Kinde domain, not the scoped issuer.
      def issuer_matches?(issuer)
        issuer.is_a?(String) && issuer.delete_suffix("/") == @config.domain
      end

      # Exact string match, no normalisation: Kinde compares the Resource URL
      # exactly as configured.
      def audience_matches?(audience)
        (audience.is_a?(Array) ? audience : [audience]).include?(@config.resource_url)
      end

      def unexpired?(expiry)
        expiry.is_a?(Numeric) && expiry > Time.now.to_i - @config.clock_tolerance_seconds
      end

      def started?(not_before)
        not_before.is_a?(Numeric) && not_before <= Time.now.to_i + @config.clock_tolerance_seconds
      end
    end
  end
end
