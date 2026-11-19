module KindeSdk
    class Error < StandardError; end
    class APIError < Error; end
    class AuthenticationError < APIError; end
    class AuthorizationError < APIError; end
    class RateLimitError < APIError; end

    # Errors raised by the resource-server helpers for "AI agents and MCP"
    # applications (see lib/kinde_sdk/agent_auth.rb). Messages are fixed strings
    # chosen by the SDK: they never contain a token or the client secret.

    class AgentAuth
        # The request carried no bearer token. Answered with 401 and a challenge
        # that has no +error+ parameter.
        class MissingTokenError < AuthenticationError
            def initialize(message = "Authentication is required")
                super
            end
        end

        # A token was presented and rejected: malformed header, bad signature,
        # wrong issuer or audience, expired or inactive. Answered with 401
        # +invalid_token+.
        class InvalidTokenError < AuthenticationError
            def initialize(message = "The access token is invalid")
                super
            end
        end

        # A valid token lacks a required OAuth scope. Answered with 403
        # +insufficient_scope+. Never used for a missing Kinde permission.
        class InsufficientScopeError < AuthorizationError
            # @return [Array<String>] the scopes the route requires
            attr_reader :scopes

            def initialize(message = "The access token is missing a required scope", scopes: [])
                super(message)
                @scopes = scopes
            end
        end

        # A valid token lacks a required Kinde permission. Answered with a plain
        # 403 and no challenge.
        class PermissionDeniedError < AuthorizationError
            # @return [Array<String>] the permission keys the route requires
            attr_reader :permissions

            def initialize(message = "You do not have permission to do this", permissions: [])
                super(message)
                @permissions = permissions
            end
        end

        # Kinde could not be reached or did not give a usable answer, so no
        # verdict on the token exists. Answered with 503, never with 401.
        class UnavailableError < APIError
            def initialize(message = "The authorization server is unavailable")
                super
            end
        end
    end

    # Errors raised by the agent-client helpers (see lib/kinde_sdk/agent_client.rb).
    # Messages are fixed text plus what the server said (+error+,
    # +error_description+) and URLs without their query: they never contain a
    # token, an authorization code, a PKCE verifier or a client secret.

    class AgentClient
        # Base class of every error the agent client raises itself.
        class Error < KindeSdk::Error; end

        # A metadata document was not found or was refused, a URL is not https,
        # or the authorization server offers no usable client identity.
        class DiscoveryError < Error; end

        # A server could not be reached: network failure or timeout.
        class UnavailableError < Error
            def initialize(message = "The server could not be reached")
                super
            end
        end

        # The user has to sign in. Not a failure: redirect the user's browser
        # to +authorization_url+ and call +handle_callback+ in the callback route.
        class AuthorizationRequiredError < Error
            # @return [String] where to send the user's browser
            attr_reader :authorization_url
            # @return [String] the +state+ of the sign-in attempt that was stored
            attr_reader :state

            def initialize(message = "The user has to sign in", authorization_url: nil, state: nil)
                super(message)
                @authorization_url = authorization_url
                @state = state
            end
        end

        # The callback cannot be accepted: +state+ is missing, unknown, already
        # used or expired, +iss+ names another server, or there is no +code+.
        class CallbackError < Error; end

        # The authorization server answered with an OAuth error, at the
        # callback, the token endpoint or the registration endpoint.
        class OAuthError < Error
            # @return [String, nil] the OAuth +error+ code, for example "invalid_grant"
            attr_reader :error
            # @return [String, nil] the server's +error_description+
            attr_reader :error_description
            # @return [Integer, nil] the HTTP status, when the error came from an HTTP answer
            attr_reader :status

            def initialize(message = "The authorization server returned an error", error: nil, error_description: nil, status: nil)
                super(message)
                @error = error
                @error_description = error_description
                @status = status
            end
        end

        # The registration endpoint refused to register this agent.
        class RegistrationError < OAuthError; end
    end
  end
