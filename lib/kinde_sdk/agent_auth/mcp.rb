# frozen_string_literal: true

# MCP adapter for KindeSdk::AgentAuth. Nothing in kinde_sdk loads this file;
# ask for it with:
#
#   require "kinde_sdk/agent_auth/mcp"
#
# It needs the official "mcp" gem (>= 1.10.0), which kinde_sdk does not install.

require "kinde_sdk"

module KindeSdk
  class AgentAuth
    # The lowest version of the +mcp+ gem the adapter supports.
    MCP_MINIMUM_VERSION = "1.10.0"
  end
end

begin
  require "mcp"
rescue LoadError => e
  raise unless e.path == "mcp"

  raise LoadError,
        'kinde_sdk/agent_auth/mcp needs the "mcp" gem, which kinde_sdk does not install. ' \
        "Add `gem \"mcp\", \">= #{KindeSdk::AgentAuth::MCP_MINIMUM_VERSION}\"` to your Gemfile."
end

if Gem::Version.new(::MCP::VERSION) < Gem::Version.new(KindeSdk::AgentAuth::MCP_MINIMUM_VERSION)
  raise LoadError,
        "kinde_sdk/agent_auth/mcp needs the \"mcp\" gem >= #{KindeSdk::AgentAuth::MCP_MINIMUM_VERSION} " \
        "(found #{::MCP::VERSION}). Update it in your Gemfile."
end

module KindeSdk
  class AgentAuth
    # Token verifier for MCP servers built on the official +mcp+ gem: it plugs
    # a {KindeSdk::AgentAuth} into the gem's own bearer enforcement.
    #
    # Optional. It is loaded only by <tt>require "kinde_sdk/agent_auth/mcp"</tt>
    # and needs the +mcp+ gem, version {MCP_MINIMUM_VERSION} or later, in your
    # Gemfile; +kinde_sdk+ does not depend on it.
    #
    # This is the MCP adapter. The class that does the verifying is the SDK's
    # own +KindeSdk::AgentAuth::TokenVerifier+, reached through
    # {KindeSdk::AgentAuth#verify_access_token}.
    #
    # With this adapter the HTTP layer is the gem's: it reads the +Bearer+
    # header, serves the metadata document and writes the 401. Do not also
    # mount {KindeSdk::AgentAuth::Middleware} on the same path.
    #
    # @example config.ru
    #   require "kinde_sdk"
    #   require "kinde_sdk/agent_auth/mcp"
    #
    #   kinde = KindeSdk::AgentAuth.new(client_id: id, client_secret: secret, resource_url: url)
    #   verifier = KindeSdk::AgentAuth::KindeTokenVerifier.new(kinde)
    #   transport = MCP::Server::Transports::StreamableHTTPTransport.new(
    #     server, token_verifier: verifier, resource_metadata: verifier.resource_metadata
    #   )
    #   use MCP::Server::OAuth::ProtectedResourceMetadataMiddleware, verifier.resource_metadata
    #   map("/mcp") { run transport }
    class KindeTokenVerifier < ::MCP::Server::OAuth::TokenVerifier
      # @return [KindeSdk::AgentAuth] the resource-server helper this verifier wraps
      attr_reader :agent_auth

      # @param agent_auth [KindeSdk::AgentAuth]
      # @raise [ArgumentError] when it is anything else
      def initialize(agent_auth)
        super()
        raise ArgumentError, "agent_auth must be a KindeSdk::AgentAuth" unless agent_auth.is_a?(::KindeSdk::AgentAuth)

        @agent_auth = agent_auth
      end

      # Verifies a bearer token for the +mcp+ gem.
      #
      # @param token [String] the raw bearer token
      # @return [MCP::Server::OAuth::AccessToken] with +expires_at+ (Integer),
      #   +resource+ (the Resource URL), +subject+, +client_id+, +scopes+,
      #   +issuer+, +audience+ and +claims+ (the Kinde claims) set
      # @raise [MCP::Server::OAuth::InvalidTokenError] when the token is
      #   rejected or has no expiry; the gem answers 401 +invalid_token+
      # @raise [KindeSdk::AgentAuth::UnavailableError] when Kinde could not be
      #   asked; the gem answers 500 +server_error+, never 401
      # @example
      #   access_token = verifier.verify(token)
      #   access_token.claims["permissions"] # => ["read:docs"]
      def verify(token)
        context = agent_auth.verify_access_token(token)
        expires_at = integer_expiry(context.expires_at)
        raise ::MCP::Server::OAuth::InvalidTokenError, "Token has no expiry" if expires_at.nil?

        ::MCP::Server::OAuth::AccessToken.new(
          token: context.token,
          client_id: context.client_id,
          scopes: context.scopes,
          expires_at: expires_at,
          subject: context.user_id,
          issuer: context.claims["iss"],
          audience: context.claims["aud"],
          resource: agent_auth.config.resource_url,
          claims: context.claims
        )
      rescue ::KindeSdk::AgentAuth::MissingTokenError, ::KindeSdk::AgentAuth::InvalidTokenError => e
        raise ::MCP::Server::OAuth::InvalidTokenError, e.message
      end

      # The protected resource metadata in the +mcp+ gem's own type, built from
      # the Kinde settings (scoped issuer, +offline+ in +scopes_supported+).
      # Pass the same object to the gem's metadata middleware and to its
      # transport.
      #
      # @return [MCP::Server::OAuth::ProtectedResourceMetadata] memoised
      # @raise [ArgumentError] from the +mcp+ gem, for a Resource URL it
      #   refuses: one with a fragment, or +http+ on a host that is not loopback
      # @example
      #   use MCP::Server::OAuth::ProtectedResourceMetadataMiddleware, verifier.resource_metadata
      def resource_metadata
        @resource_metadata ||= ::MCP::Server::OAuth::ProtectedResourceMetadata.new(
          resource: agent_auth.config.resource_url,
          authorization_servers: [agent_auth.config.issuer],
          scopes_supported: agent_auth.config.scopes_supported,
          resource_name: agent_auth.config.resource_name
        )
      end

      # The Kinde auth context of the current MCP request, for permission
      # checks inside a tool.
      #
      # @param source [MCP::ServerContext, MCP::Server::OAuth::AccessToken, nil]
      #   the tool's +server_context+, or its +auth_info+
      # @return [KindeSdk::AgentAuth::AuthContext, nil] nil when the request
      #   was not authenticated. Never raises.
      # @example Inside an MCP::Tool
      #   def self.call(server_context:)
      #     auth = KindeSdk::AgentAuth::KindeTokenVerifier.auth_context(server_context)
      #     unless KindeSdk::AgentAuth.has_permission?(auth, "read:docs")
      #       return MCP::Tool::Response.new([{ type: "text", text: "No access to docs." }], error: true)
      #     end
      #     # ...
      #   end
      def self.auth_context(source)
        access_token = source.is_a?(::MCP::Server::OAuth::AccessToken) ? source : source&.auth_info
        return nil unless access_token.is_a?(::MCP::Server::OAuth::AccessToken)

        ::KindeSdk::AgentAuth::AuthContext.from_claims(access_token.token, access_token.claims)
      rescue StandardError
        nil
      end

      private

      def integer_expiry(value)
        value.to_i if value.is_a?(Numeric) && value.finite?
      end
    end
  end
end
