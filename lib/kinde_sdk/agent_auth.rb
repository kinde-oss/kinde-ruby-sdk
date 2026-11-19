# frozen_string_literal: true

require "kinde_sdk/errors"
require "kinde_sdk/logging"
require "kinde_sdk/agent_auth/config"
require "kinde_sdk/agent_auth/auth_context"
require "kinde_sdk/agent_auth/challenge"
require "kinde_sdk/agent_auth/http"
require "kinde_sdk/agent_auth/cached_document"
require "kinde_sdk/agent_auth/metadata"
require "kinde_sdk/agent_auth/token_verifier"
require "kinde_sdk/agent_auth/middleware"

module KindeSdk
  # Resource-server helpers for a Kinde "AI agents and MCP" application: lets
  # your MCP server (or any HTTP API) accept the access tokens Kinde issues to
  # AI agents through that application.
  #
  # One instance holds the settings of one application and everything derived
  # from them (scoped issuer, endpoints, metadata URLs). It is separate from
  # the login application configured with {KindeSdk.configure}: only +domain+
  # may default from there, and the login application's client ID is never used.
  #
  # The SDK reads no environment variable itself; pass the values in.
  #
  # @example
  #   kinde = KindeSdk::AgentAuth.new(
  #     domain: "https://yourbiz.kinde.com",
  #     client_id: ENV.fetch("KINDE_AGENTS_CLIENT_ID"),
  #     client_secret: ENV.fetch("KINDE_AGENTS_CLIENT_SECRET"),
  #     resource_url: ENV.fetch("KINDE_AGENTS_RESOURCE_URL")
  #   )
  #   auth = kinde.authenticate(request.get_header("HTTP_AUTHORIZATION"))
  #   auth.user_id # => "kp_123"
  class AgentAuth
    BEARER_PATTERN = /\ABearer (\S+)\z/i.freeze
    PERCENT_ESCAPE = /%[0-9A-Fa-f]{2}/.freeze
    TWO_WORD_BYTES = /\A[A-Za-z0-9_]{2}\z/.freeze
    private_constant :BEARER_PATTERN, :PERCENT_ESCAPE, :TWO_WORD_BYTES

    # @return [KindeSdk::AgentAuth::Config] the settings and the derived values
    attr_reader :config

    # @param client_id [String] the AI agents and MCP application's client ID. No default.
    # @param client_secret [String] that application's client secret
    # @param resource_url [String] the application's Resource URL, byte for byte as set in Kinde
    # @param domain [String] the Kinde domain; defaults to the SDK's configured domain
    # @param verification [String, Symbol] "introspection" (default), "jwt" or "jwt+introspection"
    # @param scopes_supported [Array<String>] scopes advertised to agents; "offline" is always added
    # @param resource_name [String, nil] name advertised in the protected resource metadata
    # @param clock_tolerance_seconds [Integer] leeway for +exp+ and +nbf+
    # @raise [ArgumentError] for a missing or invalid value
    # @example Local JWT verification
    #   KindeSdk::AgentAuth.new(client_id: id, client_secret: secret,
    #                           resource_url: "https://api.example.com/mcp", verification: "jwt")
    def initialize(client_id:, client_secret:, resource_url:,
                   domain: KindeSdk.config&.domain,
                   verification: "introspection",
                   scopes_supported: ["offline"],
                   resource_name: nil,
                   clock_tolerance_seconds: 30)
      @config = Config.new(
        client_id: client_id,
        client_secret: client_secret,
        resource_url: resource_url,
        domain: domain,
        verification: verification,
        scopes_supported: scopes_supported,
        resource_name: resource_name,
        clock_tolerance_seconds: clock_tolerance_seconds
      )
      @metadata = Metadata.new(@config)
      @verifier = TokenVerifier.new(@config)
    end

    # The protected resource metadata document (RFC 9728) for this resource.
    #
    # @return [Hash{String=>Object}] +resource+, +authorization_servers+ (the
    #   scoped issuer), +bearer_methods_supported+, +scopes_supported+ and,
    #   when configured, +resource_name+
    # @example
    #   kinde.protected_resource_metadata["authorization_servers"]
    #   # => ["https://yourbiz.kinde.com/oauth2/agents/<client id>"]
    def protected_resource_metadata
      @metadata.protected_resource_metadata
    end

    # A mirror of Kinde's authorization server metadata, for MCP clients that
    # look for it on the resource server's own origin.
    #
    # @param mode [Symbol] :proxy fetches Kinde's document (cached for five
    #   minutes) and returns it unchanged; :static builds it from the derived URLs
    # @return [Hash{String=>Object}] includes +client_id_metadata_document_supported: true+
    # @raise [ArgumentError] for another mode
    # @raise [KindeSdk::AgentAuth::UnavailableError] when the proxy fetch fails
    # @example
    #   kinde.authorization_server_metadata(:static)["token_endpoint"]
    def authorization_server_metadata(mode = :proxy)
      @metadata.authorization_server_metadata(mode)
    end

    # The response for a metadata route, for frameworks without Rack
    # middleware. Serves +GET+ and +OPTIONS+ on {Config#prm_path}, on
    # +/.well-known/oauth-protected-resource+ and, when a mirror mode is given,
    # on +/.well-known/oauth-authorization-server+.
    #
    # @param request_method [String] the HTTP method
    # @param path [String] the full request path
    # @param authorization_server_metadata [Symbol, nil] :proxy, :static, or nil to leave the mirror unserved
    # @return [Array(Integer, Hash{String=>String}, String), nil] status, lower-case
    #   headers and body; nil when the request is not for a metadata route
    # @raise [ArgumentError] for an unknown mirror mode
    # @raise [KindeSdk::AgentAuth::UnavailableError] when the proxy fetch fails
    # @example
    #   status, headers, body = kinde.metadata_response("GET", "/.well-known/oauth-protected-resource/mcp")
    def metadata_response(request_method, path, authorization_server_metadata: nil)
      @metadata.response(request_method, path, authorization_server_metadata: authorization_server_metadata)
    end

    # Whether a request path needs a token: the path of the Resource URL,
    # everything below it, and every other path a router could send to the
    # same handler.
    #
    # The check fails closed. A path is protected when it starts with the
    # path of the Resource URL and what follows is the end of the path or any
    # character other than an ASCII letter, a digit or an underscore. For
    # +/mcp+ that is +/mcp/...+, +/mcp.json+ (routers match an optional format
    # suffix) and +/mcp-docs+, +/mcp;x+ or +/mcp%20+ (routers match a mounted
    # app up to a word boundary). So a sibling path such as +/mcp-docs+ needs
    # a token too. Only a path that continues with a letter, a digit or an
    # underscore (+/mcpx+, +/mcp_x+, +/mcp1+) is a different path and passes
    # through.
    #
    # Repeated slashes are ignored, and the path is checked both as sent and
    # with its percent-escapes decoded (+/%6Dcp+), because routers match one
    # form or the other.
    #
    # @param path [String] the full request path
    # @return [Boolean]
    # @example
    #   kinde.protects?("/mcp/messages") # => true (Resource URL https://api.example.com/mcp)
    #   kinde.protects?("/mcp.json")     # => true
    #   kinde.protects?("/mcp-docs")     # => true
    #   kinde.protects?("/mcpx")         # => false
    def protects?(path)
      resource = path_spellings(config.resource_path)
      requested = path_spellings("/#{path}")
      resource.zip(requested).any? { |base, candidate| at_or_below?(base.chomp("/"), candidate) }
    end

    # Verifies an access token with the configured strategy.
    #
    # @param token [String] the raw access token
    # @return [KindeSdk::AgentAuth::AuthContext]
    # @raise [KindeSdk::AgentAuth::InvalidTokenError] when the token is rejected
    # @raise [KindeSdk::AgentAuth::UnavailableError] when Kinde could not be asked
    # @example
    #   auth = kinde.verify_access_token(token)
    #   auth.permissions # => ["read:docs"]
    def verify_access_token(token)
      @verifier.verify(token)
    end

    # Reads the bearer token from an +Authorization+ header value and verifies it.
    #
    # @param authorization_header [String, nil] the header value
    # @return [KindeSdk::AgentAuth::AuthContext]
    # @raise [KindeSdk::AgentAuth::MissingTokenError] when there is no header
    # @raise [KindeSdk::AgentAuth::InvalidTokenError] when the header or token is rejected
    # @raise [KindeSdk::AgentAuth::UnavailableError] when Kinde could not be asked
    # @example
    #   auth = kinde.authenticate(env["HTTP_AUTHORIZATION"])
    def authenticate(authorization_header)
      verify_access_token(self.class.extract_bearer_token(authorization_header))
    end

    # Requires OAuth scopes (+offline+, +profile+, +email+). Not for Kinde
    # permissions: use {#require_permission} or {.has_permission?} for those.
    #
    # @param auth [KindeSdk::AgentAuth::AuthContext, nil]
    # @param scopes [Array<String>] every one must be granted
    # @return [KindeSdk::AgentAuth::AuthContext] +auth+
    # @raise [KindeSdk::AgentAuth::InsufficientScopeError] when a scope is missing (403 +insufficient_scope+)
    # @raise [KindeSdk::AgentAuth::MissingTokenError] when +auth+ is nil
    # @example
    #   kinde.require_scope(auth, "profile")
    def require_scope(auth, *scopes)
      context = require_context(auth)
      required = scopes.flatten.map(&:to_s)
      return context if (required - context.scopes).empty?

      raise InsufficientScopeError.new(scopes: required)
    end

    # Requires Kinde permissions on a plain REST route. A missing permission is
    # a plain 403, never +insufficient_scope+: signing in again cannot grant a
    # permission. Inside an MCP tool use {.has_permission?} and return a tool error.
    #
    # @param auth [KindeSdk::AgentAuth::AuthContext, nil]
    # @param keys [Array<String>] every one must be held
    # @return [KindeSdk::AgentAuth::AuthContext] +auth+
    # @raise [KindeSdk::AgentAuth::PermissionDeniedError] when a permission is missing
    # @raise [KindeSdk::AgentAuth::MissingTokenError] when +auth+ is nil
    # @example
    #   kinde.require_permission(env["kinde_sdk.agent_auth"], "write:docs")
    def require_permission(auth, *keys)
      context = require_context(auth)
      required = keys.flatten.map(&:to_s)
      return context if (required - context.permissions).empty?

      raise PermissionDeniedError.new(permissions: required)
    end

    # Revokes a token issued for this application's Resource URL, with the
    # application's credentials. Revoking either token of a pair revokes both.
    #
    # @param token [String] an access token or a refresh token
    # @param hint [String, nil] "access_token" or "refresh_token"
    # @return [true]
    # @raise [ArgumentError] when the token is blank
    # @raise [KindeSdk::APIError] when Kinde answers anything other than 200
    # @raise [KindeSdk::AgentAuth::UnavailableError] on a timeout or network error
    # @example
    #   kinde.revoke_token(refresh_token, "refresh_token")
    def revoke_token(token, hint = nil)
      raise ArgumentError, "token is required" if token.nil? || token.to_s.strip.empty?

      params = { token: token.to_s }
      params[:token_type_hint] = hint.to_s unless hint.nil? || hint.to_s.empty?
      status, _body = Http.post_form(config.revoke_url, params, config)
      return true if status == 200

      raise KindeSdk::APIError, "Unable to revoke token: Kinde answered HTTP #{status}"
    end

    # The +WWW-Authenticate+ value for an error.
    #
    # @param error [StandardError, nil] nil (or a
    #   {KindeSdk::AgentAuth::MissingTokenError}) gives the challenge for a
    #   request with no token
    # @return [String, nil] nil for an error that carries no challenge
    #   (missing permission, Kinde unavailable)
    # @example
    #   kinde.challenge
    #   # => 'Bearer resource_metadata="https://api.example.com/.well-known/oauth-protected-resource/mcp"'
    def challenge(error = nil)
      Challenge.header_for(error, config)
    end

    # The HTTP response for one of the five AgentAuth errors: 401 with a
    # challenge, 403 +insufficient_scope+, plain 403, or 503.
    #
    # @param error [StandardError] a {KindeSdk::AgentAuth::MissingTokenError},
    #   {KindeSdk::AgentAuth::InvalidTokenError}, {KindeSdk::AgentAuth::InsufficientScopeError},
    #   {KindeSdk::AgentAuth::PermissionDeniedError} or {KindeSdk::AgentAuth::UnavailableError}
    # @param cors [Boolean] add +Access-Control-Allow-Origin: *+ and
    #   +Access-Control-Expose-Headers: WWW-Authenticate+ so browser clients
    #   can read the status and the challenge
    # @return [Array(Integer, Hash{String=>String}, String)] status, lower-case headers, JSON body
    # @raise [ArgumentError] for any other error
    # @example
    #   begin
    #     auth = kinde.authenticate(header)
    #   rescue KindeSdk::AgentAuth::MissingTokenError, KindeSdk::AgentAuth::InvalidTokenError => e
    #     status, headers, body = kinde.error_response(e)
    #   end
    def error_response(error, cors: false)
      Challenge.response_for(error, config, cors: cors)
    end

    # The answer to a CORS preflight on a protected path, for a server that
    # lets browser-based clients in (the middleware's +cors: true+).
    #
    # A preflight is an +OPTIONS+ request with an +Origin+ and an
    # +Access-Control-Request-Method+ header. A browser sends it before the
    # real request and without the token, so it is answered without one: 204,
    # any origin, the usual methods, and the +Authorization+ request header
    # allowed by name. Nothing is authenticated, no request is made to Kinde,
    # and nothing from the request is put into the answer. The request that
    # follows still needs its token; answer its errors with
    # +error_response(error, cors: true)+ so the browser can read them.
    #
    # Ask {#metadata_response} first: with a Resource URL path of +/+ the
    # metadata routes are protected paths too.
    #
    # @param request_method [String] the HTTP method
    # @param path [String] the full request path
    # @param origin [String, nil] the +Origin+ header
    # @param access_control_request_method [String, nil] the +Access-Control-Request-Method+ header
    # @return [Array(Integer, Hash{String=>String}, String), nil] status,
    #   lower-case headers and an empty body; nil when the request is not a
    #   preflight (another method, or one of the two headers missing or empty)
    #   or the path is not one {#protects?} covers
    # @example
    #   status, headers, body = kinde.preflight_response(
    #     "OPTIONS", "/mcp", origin: "https://app.example.com", access_control_request_method: "POST"
    #   )
    #   status                                   # => 204
    #   headers["access-control-allow-headers"]  # => "Authorization, Content-Type, ..."
    def preflight_response(request_method, path, origin:, access_control_request_method:)
      return nil unless request_method.to_s.upcase == "OPTIONS"
      return nil if origin.to_s.empty? || access_control_request_method.to_s.empty?
      return nil unless protects?(path)

      Challenge.preflight_response
    end

    # @return [String] a description with the client secret redacted
    def inspect
      "#<#{self.class.name} config=#{config.inspect}>"
    end
    alias to_s inspect

    class << self
      # Reads the token from an +Authorization+ header value. Only
      # +Bearer <token>+ is accepted: the scheme in any case, exactly one space.
      #
      # @param authorization_header [String, nil]
      # @return [String] the token
      # @raise [KindeSdk::AgentAuth::MissingTokenError] when the header is nil or empty
      # @raise [KindeSdk::AgentAuth::InvalidTokenError] for any other shape, such as +Basic ...+
      # @example
      #   KindeSdk::AgentAuth.extract_bearer_token("Bearer abc") # => "abc"
      def extract_bearer_token(authorization_header)
        raise MissingTokenError if authorization_header.nil? || authorization_header.to_s.empty?

        header = authorization_header.to_s
        match = header.valid_encoding? ? BEARER_PATTERN.match(header) : nil
        raise InvalidTokenError, "The Authorization header must be: Bearer <token>" unless match

        match[1]
      end

      # Whether a verified token carries a Kinde permission. This is the check
      # to make inside each MCP tool; on false, return a tool error
      # (+isError: true+) instead of an HTTP 403.
      #
      # @param auth [KindeSdk::AgentAuth::AuthContext, nil]
      # @param key [String] the permission key, for example "read:docs"
      # @return [Boolean] false for a nil context; never raises
      # @example
      #   unless KindeSdk::AgentAuth.has_permission?(auth, "read:docs")
      #     return MCP::Tool::Response.new([{ type: "text", text: "No access to docs." }], error: true)
      #   end
      def has_permission?(auth, key)
        auth.is_a?(AuthContext) && auth.has_permission?(key)
      end

      # camelCase twin of {.has_permission?}, for parity with the other Kinde SDKs.
      alias_method :hasPermission, :has_permission?
    end

    private

    def require_context(auth)
      raise MissingTokenError unless auth.is_a?(AuthContext)

      auth
    end

    # The two forms a router matches a path in: as sent, and with its
    # percent-escapes decoded. Both are bytes (a request path is not always
    # valid UTF-8), with repeated slashes squeezed and the hex digits of an
    # escape in upper case, which is how routers normalise a path before
    # they match it.
    def path_spellings(path)
      sent = path.b.squeeze("/").gsub(PERCENT_ESCAPE, &:upcase)
      [sent, sent.gsub(PERCENT_ESCAPE) { |escape| escape[1, 2].hex.chr }.squeeze("/")]
    end

    # A router's word-boundary test: +candidate+ is another path only when the
    # resource path ends, and the rest starts, with a letter, digit or underscore.
    def at_or_below?(base, candidate)
      return true if base.empty?
      return false unless candidate.start_with?(base)

      !"#{base[-1]}#{candidate.byteslice(base.bytesize, 1)}".match?(TWO_WORD_BYTES)
    end
  end
end
