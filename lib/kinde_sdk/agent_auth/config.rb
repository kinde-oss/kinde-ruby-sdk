# frozen_string_literal: true

require "uri"

module KindeSdk
  class AgentAuth
    # Settings of one "AI agents and MCP" application acting as a resource
    # server, plus every value derived from them. Built by
    # {KindeSdk::AgentAuth#initialize}; frozen after construction.
    #
    # It is separate from {KindeSdk::Configuration} (the login application):
    # +client_id+ and +client_secret+ are never taken from there.
    #
    # @example
    #   kinde = KindeSdk::AgentAuth.new(
    #     domain: "https://yourbiz.kinde.com",
    #     client_id: ENV["KINDE_AGENTS_CLIENT_ID"],
    #     client_secret: ENV["KINDE_AGENTS_CLIENT_SECRET"],
    #     resource_url: "https://api.example.com/mcp"
    #   )
    #   kinde.config.issuer  # => "https://yourbiz.kinde.com/oauth2/agents/<client id>"
    #   kinde.config.prm_url # => "https://api.example.com/.well-known/oauth-protected-resource/mcp"
    class Config
      VERIFICATION_MODES = %w[introspection jwt jwt+introspection].freeze
      WELL_KNOWN_PRM_PATH = "/.well-known/oauth-protected-resource"
      REQUIRED_SCOPE = "offline"
      # RFC 3986 path segment characters, without percent-escapes.
      URL_PATH_SEGMENT = /\A[A-Za-z0-9\-._~!$&'()*+,;=:@]+\z/.freeze
      private_constant :URL_PATH_SEGMENT

      # @return [String] the Kinde domain as +https://host+ (no path, no trailing slash)
      attr_reader :domain
      # @return [String] the client ID of the AI agents and MCP application
      attr_reader :client_id
      # @return [String] the client secret of that application
      attr_reader :client_secret
      # @return [String] the Resource URL, byte for byte as given
      attr_reader :resource_url
      # @return [String] "introspection", "jwt" or "jwt+introspection"
      attr_reader :verification
      # @return [Array<String>] advertised scopes; always contains "offline"
      attr_reader :scopes_supported
      # @return [String, nil] the name advertised in the protected resource metadata
      attr_reader :resource_name
      # @return [Integer] leeway in seconds for +exp+ and +nbf+
      attr_reader :clock_tolerance_seconds
      # @return [String] the scoped issuer, +domain/oauth2/agents/client_id+
      attr_reader :issuer
      # @return [String] where Kinde serves this application's authorization server metadata
      attr_reader :as_metadata_url
      # @return [String] +domain/.well-known/jwks+
      attr_reader :jwks_url
      # @return [String] +issuer/introspect+
      attr_reader :introspect_url
      # @return [String] +issuer/revoke+
      attr_reader :revoke_url
      # @return [String] path of the protected resource metadata for this resource
      attr_reader :prm_path
      # @return [String] absolute URL of the protected resource metadata
      attr_reader :prm_url
      # @return [String] path of the Resource URL ("/" when it has none)
      attr_reader :resource_path

      # @param client_id [String] required; has no default; no whitespace and
      #   nothing else that cannot be part of a URL path
      # @param client_secret [String] required
      # @param resource_url [String] required; an absolute http(s) URL
      # @param domain [String] required; +https+ only, a missing scheme becomes
      #   +https://+, the host is lower-cased
      # @param verification [String, Symbol] one of {VERIFICATION_MODES}
      # @param scopes_supported [Array<String>] "offline" is added when missing
      # @param resource_name [String, nil]
      # @param clock_tolerance_seconds [Integer] zero or more
      # @raise [ArgumentError] for a missing or invalid value
      def initialize(client_id:, client_secret:, resource_url:, domain:,
                     verification: "introspection", scopes_supported: [REQUIRED_SCOPE],
                     resource_name: nil, clock_tolerance_seconds: 30)
        @client_id = validate_client_id(required(:client_id, client_id))
        @client_secret = required(:client_secret, client_secret)
        @resource_url = required(:resource_url, resource_url)
        @domain = normalize_domain(required(:domain, domain))
        @verification = validate_verification(verification)
        @scopes_supported = with_required_scope(scopes_supported)
        @resource_name = empty?(resource_name) ? nil : resource_name.to_s.dup.freeze
        @clock_tolerance_seconds = validate_tolerance(clock_tolerance_seconds)

        derive_kinde_urls
        derive_resource_urls
        freeze
      end

      # @return [String] a description with the client secret redacted
      def inspect
        "#<#{self.class.name} domain=#{domain.inspect} client_id=#{client_id.inspect} " \
          "client_secret=[REDACTED] resource_url=#{resource_url.inspect} verification=#{verification.inspect}>"
      end
      alias to_s inspect

      private

      def empty?(value)
        value.nil? || value.to_s.strip.empty?
      end

      def required(name, value)
        raise ArgumentError, "#{name} is required" if empty?(value)

        value.to_s.dup.freeze
      end

      # The client ID becomes one segment of every Kinde URL, unchanged.
      def validate_client_id(value)
        return value if URL_PATH_SEGMENT.match?(value)

        raise ArgumentError,
              "client_id must not contain whitespace or any other character that cannot be part of a URL path"
      end

      def normalize_domain(value)
        text = value.strip
        scheme = text[%r{\A([A-Za-z][A-Za-z0-9+.-]*)://}, 1]
        if scheme.nil?
          text = "https://#{text}"
        elsif scheme.downcase != "https"
          raise ArgumentError, "domain must use https"
        end

        uri = parse_url(:domain, text)
        # Host names are case-insensitive, and the iss of a token is compared with this value exactly.
        "https://#{uri.host.downcase}#{port_suffix(uri)}".freeze
      end

      def validate_verification(value)
        mode = value.to_s
        return mode.freeze if VERIFICATION_MODES.include?(mode)

        raise ArgumentError, "verification must be one of: #{VERIFICATION_MODES.join(', ')}"
      end

      def with_required_scope(value)
        scopes = Array(value).map(&:to_s)
        scopes << REQUIRED_SCOPE unless scopes.include?(REQUIRED_SCOPE)
        scopes.map(&:freeze).freeze
      end

      def validate_tolerance(value)
        return value if value.is_a?(Integer) && value >= 0

        raise ArgumentError, "clock_tolerance_seconds must be a non-negative Integer"
      end

      def derive_kinde_urls
        @issuer = "#{domain}/oauth2/agents/#{client_id}".freeze
        @as_metadata_url = "#{domain}/.well-known/oauth-authorization-server/oauth2/agents/#{client_id}".freeze
        @jwks_url = "#{domain}/.well-known/jwks".freeze
        @introspect_url = "#{issuer}/introspect".freeze
        @revoke_url = "#{issuer}/revoke".freeze
      end

      def derive_resource_urls
        uri = parse_url(:resource_url, resource_url)
        unless %w[http https].include?(uri.scheme.to_s.downcase)
          raise ArgumentError, "resource_url must be an absolute http(s) URL"
        end

        path = uri.path.to_s
        @resource_path = (path.empty? ? "/" : path).freeze
        @prm_path = "#{WELL_KNOWN_PRM_PATH}#{path == '/' ? '' : path}".freeze
        @prm_url = "#{uri.scheme}://#{uri.host}#{port_suffix(uri)}#{prm_path}".freeze
      end

      def parse_url(name, text)
        uri = URI.parse(text)
        raise ArgumentError, "#{name} must be an absolute URL" if uri.host.nil? || uri.host.empty?

        uri
      rescue URI::InvalidURIError
        raise ArgumentError, "#{name} must be an absolute URL"
      end

      def port_suffix(uri)
        uri.port && uri.port != uri.default_port ? ":#{uri.port}" : ""
      end
    end
  end
end
