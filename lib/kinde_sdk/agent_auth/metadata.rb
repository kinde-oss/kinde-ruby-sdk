# frozen_string_literal: true

require "json"

module KindeSdk
  class AgentAuth
    # The discovery documents a resource server publishes: the protected
    # resource metadata (RFC 9728) and, on request, a mirror of Kinde's
    # authorization server metadata. Use the methods of the same names on
    # {KindeSdk::AgentAuth} instead of calling this directly.
    #
    # @api private
    class Metadata
      ROOT_PRM_PATH = Config::WELL_KNOWN_PRM_PATH
      AS_MIRROR_PATH = "/.well-known/oauth-authorization-server"
      AS_MIRROR_MODES = %i[proxy static].freeze
      PRM_MAX_AGE = 3600
      AS_MIRROR_MAX_AGE = 300

      # @param config [Config]
      # @param clock [#call] monotonic clock for the proxy cache
      def initialize(config, clock: CachedDocument::MONOTONIC_CLOCK)
        @config = config
        @proxied = CachedDocument.new(config.as_metadata_url, ttl: AS_MIRROR_MAX_AGE, clock: clock)
      end

      # @return [Hash{String=>Object}] the RFC 9728 document
      def protected_resource_metadata
        document = {
          "resource" => @config.resource_url,
          "authorization_servers" => [@config.issuer],
          "bearer_methods_supported" => ["header"],
          "scopes_supported" => @config.scopes_supported
        }
        document["resource_name"] = @config.resource_name if @config.resource_name
        document
      end

      # @param mode [Symbol, String] :proxy (Kinde's own document, cached for
      #   five minutes, returned unchanged) or :static (built from the derived URLs)
      # @return [Hash{String=>Object}]
      # @raise [ArgumentError] for another mode
      # @raise [UnavailableError] when the proxy fetch fails
      def authorization_server_metadata(mode = :proxy)
        case self.class.mirror_mode(mode)
        when :proxy then @proxied.get
        when :static then static_authorization_server_metadata
        else raise ArgumentError, "authorization_server_metadata mode is required"
        end
      end

      # The answer for a metadata route, or nil when the request is for
      # something else.
      #
      # @param request_method [String] "GET" or "OPTIONS"
      # @param path [String] the full request path
      # @param authorization_server_metadata [Symbol, nil] nil leaves the mirror route unserved
      # @return [Array(Integer, Hash{String=>String}, String), nil]
      # @raise [UnavailableError] when the proxy fetch fails
      def response(request_method, path, authorization_server_metadata: nil)
        mode = self.class.mirror_mode(authorization_server_metadata)
        if path == @config.prm_path || path == ROOT_PRM_PATH
          respond(request_method, PRM_MAX_AGE) { protected_resource_metadata }
        elsif mode && path == AS_MIRROR_PATH
          respond(request_method, AS_MIRROR_MAX_AGE) { authorization_server_metadata(mode) }
        end
      end

      # @param mode [Symbol, String, nil]
      # @return [Symbol, nil]
      # @raise [ArgumentError] for a value other than nil, :proxy or :static
      def self.mirror_mode(mode)
        return nil if mode.nil?

        normalized = mode.to_s.to_sym
        return normalized if AS_MIRROR_MODES.include?(normalized)

        raise ArgumentError, "authorization_server_metadata must be :proxy, :static or nil"
      end

      private

      # The document from Kinde's server contract, built from the derived URLs.
      def static_authorization_server_metadata
        issuer = @config.issuer
        {
          "issuer" => issuer,
          "authorization_endpoint" => "#{issuer}/authorize",
          "token_endpoint" => "#{issuer}/token",
          "registration_endpoint" => "#{issuer}/register",
          "introspection_endpoint" => @config.introspect_url,
          "revocation_endpoint" => @config.revoke_url,
          "jwks_uri" => @config.jwks_url,
          "response_types_supported" => ["code"],
          "grant_types_supported" => %w[authorization_code refresh_token],
          "token_endpoint_auth_methods_supported" => %w[client_secret_post none],
          "code_challenge_methods_supported" => ["S256"],
          "scopes_supported" => %w[offline profile email],
          "subject_types_supported" => ["public"],
          "resource_indicators_supported" => true,
          "client_id_metadata_document_supported" => true
        }
      end

      def respond(request_method, max_age)
        case request_method.to_s.upcase
        when "GET"
          headers = {
            "content-type" => "application/json",
            "cache-control" => "max-age=#{max_age}",
            "access-control-allow-origin" => "*"
          }
          [200, headers, JSON.generate(yield)]
        when "OPTIONS"
          headers = {
            "access-control-allow-origin" => "*",
            "access-control-allow-methods" => "GET, OPTIONS",
            "access-control-allow-headers" => "*",
            "access-control-expose-headers" => "WWW-Authenticate"
          }
          [204, headers, ""]
        end
      end
    end
  end
end
