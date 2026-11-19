# frozen_string_literal: true

require "json"

module KindeSdk
  class AgentAuth
    # Builds the RFC 6750 / RFC 9728 +WWW-Authenticate+ challenge and the
    # response that carries it, and the answer to the CORS preflight a browser
    # sends before a request that will carry the token. Use
    # {KindeSdk::AgentAuth#challenge}, {KindeSdk::AgentAuth#error_response} and
    # {KindeSdk::AgentAuth#preflight_response} instead of calling this directly.
    #
    # @api private
    module Challenge
      CORS_HEADERS = {
        "access-control-allow-origin" => "*",
        "access-control-expose-headers" => "WWW-Authenticate"
      }.freeze

      # The whole preflight answer is fixed: nothing in it is taken from the
      # request. +Authorization+ is named because the +*+ in the list does not
      # cover it in a browser (Fetch: a "CORS non-wildcard request-header
      # name"); the other names are there for clients that do not know the
      # +*+. No +access-control-allow-credentials+: a bearer token in a header
      # is not a credential in the CORS sense, and +*+ as the origin excludes them.
      PREFLIGHT_HEADERS = {
        "access-control-allow-origin" => "*",
        "access-control-allow-methods" => "GET, HEAD, POST, PUT, PATCH, DELETE, OPTIONS",
        "access-control-allow-headers" =>
          "Authorization, Content-Type, Accept, Mcp-Session-Id, Mcp-Protocol-Version, Last-Event-ID, *",
        # An OPTIONS request without these two headers is not a preflight and gets another answer.
        "vary" => "Origin, Access-Control-Request-Method"
      }.freeze

      class << self
        # @return [Array(Integer, Hash{String=>String}, String)] 204, the
        #   lower-case CORS headers of a preflight answer, and an empty body
        def preflight_response
          [204, PREFLIGHT_HEADERS.dup, ""]
        end

        # @param prm_url [String] URL of the protected resource metadata
        # @param error [String, nil] RFC 6750 error code
        # @param description [String, nil] short text; must not contain token contents
        # @param scope [String, nil] space-separated scopes the route needs
        # @return [String] the header value; every parameter value is quoted
        def build(prm_url:, error: nil, description: nil, scope: nil)
          params = []
          params << %(error="#{quote(error)}") if error
          params << %(error_description="#{quote(description)}") if description
          params << %(scope="#{quote(scope)}") if scope
          params << %(resource_metadata="#{quote(prm_url)}")
          "Bearer #{params.join(', ')}"
        end

        # @param error [StandardError, nil] nil stands for "no token presented"
        # @param config [Config]
        # @return [String, nil] the header value, or nil when the error carries
        #   no challenge (missing permission, Kinde unavailable)
        def header_for(error, config)
          case error
          when nil, MissingTokenError
            build(prm_url: config.prm_url)
          when InvalidTokenError
            build(prm_url: config.prm_url, error: "invalid_token", description: error.message)
          when InsufficientScopeError
            build(prm_url: config.prm_url, error: "insufficient_scope", scope: Array(error.scopes).join(" "))
          end
        end

        # @param error [StandardError] one of the five AgentAuth error classes
        # @param config [Config]
        # @param cors [Boolean] add the CORS headers a browser client needs to read the challenge
        # @return [Array(Integer, Hash{String=>String}, String)] status, lower-case headers, JSON body
        # @raise [ArgumentError] for any other error class
        def response_for(error, config, cors: false)
          status, code = status_and_code(error)
          headers = { "content-type" => "application/json" }
          challenge = header_for(error, config)
          headers["www-authenticate"] = challenge if challenge
          headers.merge!(CORS_HEADERS) if cors

          [status, headers, JSON.generate("error" => code, "error_description" => error.message)]
        end

        private

        def status_and_code(error)
          case error
          when MissingTokenError then [401, "unauthorized"]
          when InvalidTokenError then [401, "invalid_token"]
          when InsufficientScopeError then [403, "insufficient_scope"]
          when PermissionDeniedError then [403, "forbidden"]
          when UnavailableError then [503, "temporarily_unavailable"]
          else raise ArgumentError, "unexpected error class: #{error.class}"
          end
        end

        def quote(value)
          value.to_s.gsub(/[\\"]/) { |character| "\\#{character}" }
        end
      end
    end
  end
end
