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
  end
