# frozen_string_literal: true

module KindeSdk
  class AgentClient
    # Settings of one agent client. Built by {KindeSdk::AgentClient#initialize};
    # frozen after construction.
    #
    # It is separate from {KindeSdk::Configuration} (the login application) and
    # from {KindeSdk::AgentAuth} (the resource server): nothing is read from
    # either, and the scope default is +offline+, never the login scope.
    #
    # @example
    #   agent = KindeSdk::AgentClient.new(
    #     resource_url: "https://api.example.com/mcp",
    #     redirect_uri: "https://agent.example.com/oauth/callback"
    #   )
    #   agent.config.scopes # => ["offline"]
    class Config
      DEFAULT_CLIENT_NAME = "Kinde Ruby SDK agent"
      DEFAULT_SCOPES = ["offline"].freeze
      DEFAULT_ACCOUNT = "default"

      # @return [String] the MCP server or API to call
      attr_reader :resource_url
      # @return [String] the callback URL of this agent
      attr_reader :redirect_uri
      # @return [String, nil] the https URL of this agent's client ID metadata document
      attr_reader :client_metadata_url
      # @return [String, nil] a pre-registered client ID
      attr_reader :client_id
      # @return [String, nil] the secret of the pre-registered client
      attr_reader :client_secret
      # @return [String, nil] the only authorization server the pre-registered client is used at
      attr_reader :issuer
      # @return [String] the name used when the agent registers itself
      attr_reader :client_name
      # @return [Array<String>] the scopes to ask for
      attr_reader :scopes
      # @return [#read, #write, #delete] where tokens and registrations are kept
      attr_reader :storage
      # @return [String] which user's tokens this client holds
      attr_reader :account

      # @param resource_url [String] https, or http on localhost, 127.0.0.1 or
      #   [::1]; no userinfo ("user:password@")
      # @param redirect_uri [String] same rule
      # @param client_metadata_url [String, nil]
      # @param client_id [String, nil]
      # @param client_secret [String, nil] needs +client_id+ and +issuer+
      # @param issuer [String, nil] the issuer of the authorization server
      #   +client_id+ is registered at (same URL rule). It is compared with the
      #   issuer the resource names by exact String match; at any other issuer
      #   +client_id+ and +client_secret+ are not used.
      # @param client_name [String]
      # @param scopes [Array<String>, String] a list, or one space-separated String
      # @param storage [#read, #write, #delete, nil] defaults to a new {MemoryStore}
      # @param account [String]
      # @raise [ArgumentError] for a missing or invalid value
      def initialize(resource_url:, redirect_uri:, client_metadata_url: nil, client_id: nil, client_secret: nil,
                     issuer: nil, client_name: DEFAULT_CLIENT_NAME, scopes: DEFAULT_SCOPES, storage: nil,
                     account: DEFAULT_ACCOUNT)
        @resource_url = url!(:resource_url, resource_url)
        raise ArgumentError, "resource_url must not contain userinfo" if Url.parse(@resource_url).userinfo
        @loopback_resource = Url.loopback?(Url.parse(@resource_url))
        @redirect_uri = url!(:redirect_uri, redirect_uri)
        @client_metadata_url = client_metadata_url!(client_metadata_url)
        @client_id = optional_string(:client_id, client_id)
        @client_secret = optional_string(:client_secret, client_secret)
        raise ArgumentError, "client_secret needs a client_id" if @client_secret && @client_id.nil?
        @issuer = optional_string(:issuer, issuer)
        @issuer = url!(:issuer, @issuer) if @issuer
        if @client_secret && @issuer.nil?
          raise ArgumentError, "client_secret needs an issuer: the authorization server the secret may be sent to"
        end

        @client_name = optional_string(:client_name, client_name) || DEFAULT_CLIENT_NAME
        @scopes = scopes!(scopes)
        @storage = storage!(storage)
        @account = (optional_string(:account, account) || DEFAULT_ACCOUNT)
        freeze
      end

      # Whether +resource_url+ is on +localhost+, +127.0.0.1+ or +[::1]+. Only
      # then may a URL the resource or its authorization server supplies
      # (metadata URLs, the issuer, endpoints) be plain +http+ on a loopback
      # host; for a remote resource every such URL must be +https+.
      #
      # @return [Boolean]
      # @example
      #   agent.config.loopback_resource? # => false for "https://api.example.com/mcp"
      def loopback_resource?
        @loopback_resource
      end

      # @return [String] the settings without the client secret
      def inspect
        secret = client_secret ? "[FILTERED]" : "nil"
        "#<#{self.class.name} resource_url=#{resource_url.inspect} redirect_uri=#{redirect_uri.inspect} " \
          "client_metadata_url=#{client_metadata_url.inspect} client_id=#{client_id.inspect} client_secret=#{secret} " \
          "issuer=#{issuer.inspect} " \
          "client_name=#{client_name.inspect} scopes=#{scopes.inspect} storage=#{storage.class.name} " \
          "account=#{account.inspect}>"
      end
      alias to_s inspect

      private

      def url!(name, value)
        raise ArgumentError, "#{name} is required" unless value.is_a?(String) && !value.strip.empty?
        unless Url.secure?(value)
          raise ArgumentError, "#{name} must be an https URL (http is allowed only for localhost, 127.0.0.1 and [::1])"
        end
        raise ArgumentError, "#{name} must not contain a fragment" if Url.parse(value).fragment

        value.dup.freeze
      end

      def client_metadata_url!(value)
        return nil if value.nil?

        problem = ClientMetadata.client_id_problem(value)
        raise ArgumentError, "client_metadata_url #{problem}" if problem

        value.dup.freeze
      end

      def optional_string(name, value)
        return nil if value.nil?
        raise ArgumentError, "#{name} must be a String" unless value.is_a?(String)

        value.strip.empty? ? nil : value.dup.freeze
      end

      def scopes!(value)
        list = value.is_a?(String) ? value.split : value
        unless list.is_a?(Array) && list.all? { |scope| scope.is_a?(String) && scope.match?(/\A\S+\z/) }
          raise ArgumentError, "scopes must be an Array of Strings or one space-separated String"
        end

        list.uniq.map { |scope| scope.dup.freeze }.freeze
      end

      def storage!(value)
        store = value.nil? ? MemoryStore.new : value
        missing = Storage::METHODS.reject { |method| store.respond_to?(method) }
        raise ArgumentError, "storage must respond to #{missing.join(', ')}" unless missing.empty?

        store
      end
    end
  end
end
