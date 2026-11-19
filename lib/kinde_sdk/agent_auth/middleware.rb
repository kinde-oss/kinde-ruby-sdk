# frozen_string_literal: true

module KindeSdk
  class AgentAuth
    # Rack middleware that puts a {KindeSdk::AgentAuth} in front of an app:
    # it serves the metadata routes, requires a valid Kinde access token on the
    # path of the Resource URL (and below it), and turns the AgentAuth errors
    # into their 401, 403 and 503 responses. Every other path passes through.
    #
    # It protects by path, and the app's router may send more paths to a
    # handler than the resource path itself. So the match is wide on purpose,
    # see {KindeSdk::AgentAuth#protects?}: with the resource path +/mcp+ a
    # token is required whenever +/mcp+ is followed by the end of the path or
    # by anything other than a letter, a digit or an underscore (+/mcp/...+,
    # +/mcp.json+, +//mcp+, and also a sibling such as +/mcp-docs+); only
    # +/mcpx+, +/mcp_x+ or +/mcp1+ style paths pass through. That covers what
    # a framework's route or mount at the resource path matches. A handler
    # must still treat a nil +env["kinde_sdk.agent_auth"]+ as an
    # unauthenticated request and never as "already checked":
    # {KindeSdk::AgentAuth.has_permission?} is false for nil, and
    # {KindeSdk::AgentAuth#require_permission} and
    # {KindeSdk::AgentAuth#require_scope} raise the error that becomes a 401.
    #
    # Browser-based clients on another origin need CORS. With +cors: true+ the
    # middleware answers the CORS preflight on the protected paths itself (an
    # +OPTIONS+ request with an +Origin+ and an +Access-Control-Request-Method+
    # header, which a browser sends without the token): 204 from
    # {KindeSdk::AgentAuth#preflight_response}, with no token, without calling
    # the app and without asking Kinde. Every other request, any other
    # +OPTIONS+ included, still needs a token. It also adds
    # +Access-Control-Allow-Origin: *+ and
    # +Access-Control-Expose-Headers: WWW-Authenticate+ to the 401, 403 and 503
    # responses it writes. It adds nothing to the app's own responses: the app
    # sets the CORS headers on those. With +cors: false+ (the default) a
    # preflight is a request without a token and gets the 401, so a CORS
    # middleware must run before this one for browser clients to get through.
    #
    # It is thin wiring: all protocol logic lives in {KindeSdk::AgentAuth}. It
    # depends on no web framework and does not need the +rack+ gem, and it is
    # unrelated to +KindeSdk::Middleware+ (the session middleware of the login flow).
    #
    # For a server built on the +mcp+ gem use
    # +KindeSdk::AgentAuth::KindeTokenVerifier+ instead, and do not mount this
    # middleware on the same path.
    #
    # @example config.ru
    #   kinde = KindeSdk::AgentAuth.new(client_id: id, client_secret: secret, resource_url: url)
    #   use KindeSdk::AgentAuth::Middleware, kinde
    #   run ->(env) {
    #     auth = env[KindeSdk::AgentAuth::Middleware::ENV_KEY]
    #     [200, { "content-type" => "text/plain" }, ["Hello #{auth.user_id}"]]
    #   }
    #
    # @example In a framework's middleware stack
    #   config.middleware.use KindeSdk::AgentAuth::Middleware, kinde
    class Middleware
      # Rack env key that holds the {KindeSdk::AgentAuth::AuthContext} of an
      # authenticated request.
      ENV_KEY = "kinde_sdk.agent_auth"

      HANDLED_ERRORS = [
        MissingTokenError, InvalidTokenError, InsufficientScopeError, PermissionDeniedError, UnavailableError
      ].freeze
      private_constant :HANDLED_ERRORS

      # @param app [#call] the next Rack app
      # @param agent_auth [KindeSdk::AgentAuth]
      # @param authorization_server_metadata [Symbol, nil] :proxy or :static to
      #   also serve +/.well-known/oauth-authorization-server+; nil (default) leaves that route to the app
      # @param cors [Boolean] for browser-based MCP clients: answer the CORS
      #   preflight on the protected paths (204, no token needed, the app is
      #   not called), and add +Access-Control-Allow-Origin: *+ and
      #   +Access-Control-Expose-Headers: WWW-Authenticate+ to the 401, 403 and
      #   503 responses. The app's own responses are not changed. When false
      #   (default), a preflight gets the 401 like any request without a
      #   token: put a CORS middleware before this one instead.
      # @raise [ArgumentError] when +agent_auth+ is not a {KindeSdk::AgentAuth}
      #   or the mirror mode is unknown
      def initialize(app, agent_auth, authorization_server_metadata: nil, cors: false)
        raise ArgumentError, "agent_auth must be a KindeSdk::AgentAuth" unless agent_auth.is_a?(KindeSdk::AgentAuth)

        @app = app
        @agent_auth = agent_auth
        @authorization_server_metadata = Metadata.mirror_mode(authorization_server_metadata)
        @cors = cors
      end

      # @param env [Hash] the Rack env. Only +HTTP_AUTHORIZATION+ is read for
      #   the token; a query string or cookie is never used. A preflight
      #   answered here (+cors: true+) sets no +env["kinde_sdk.agent_auth"]+.
      # @return [Array(Integer, Hash, #each)] a Rack response
      def call(env)
        path = "#{env['SCRIPT_NAME']}#{env['PATH_INFO']}"
        metadata = @agent_auth.metadata_response(
          env["REQUEST_METHOD"], path, authorization_server_metadata: @authorization_server_metadata
        )
        return rack_response(metadata) if metadata

        preflight = @cors && @agent_auth.preflight_response(
          env["REQUEST_METHOD"], path,
          origin: env["HTTP_ORIGIN"], access_control_request_method: env["HTTP_ACCESS_CONTROL_REQUEST_METHOD"]
        )
        return rack_response(preflight) if preflight

        if @agent_auth.protects?(path)
          env[ENV_KEY] = @agent_auth.authenticate(env["HTTP_AUTHORIZATION"])
        end
        @app.call(env)
      rescue *HANDLED_ERRORS => e
        rack_response(@agent_auth.error_response(e, cors: @cors))
      end

      private

      def rack_response(response)
        status, headers, body = response
        [status, headers, body.empty? ? [] : [body]]
      end
    end
  end
end
