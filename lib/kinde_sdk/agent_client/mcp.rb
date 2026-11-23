# frozen_string_literal: true

# MCP client adapter for KindeSdk::AgentClient. Nothing in kinde_sdk loads this
# file; ask for it with:
#
#   require "kinde_sdk/agent_client/mcp"
#
# It needs the official "mcp" gem (>= 1.10.0), which kinde_sdk does not install.

require "kinde_sdk"

module KindeSdk
  class AgentClient
    # The lowest version of the +mcp+ gem the adapter supports.
    MCP_MINIMUM_VERSION = "1.10.0"
  end
end

begin
  require "mcp"
rescue LoadError => e
  raise unless e.path == "mcp"

  raise LoadError,
        'kinde_sdk/agent_client/mcp needs the "mcp" gem, which kinde_sdk does not install. ' \
        "Add `gem \"mcp\", \">= #{KindeSdk::AgentClient::MCP_MINIMUM_VERSION}\"` to your Gemfile."
end

if Gem::Version.new(::MCP::VERSION) < Gem::Version.new(KindeSdk::AgentClient::MCP_MINIMUM_VERSION)
  raise LoadError,
        "kinde_sdk/agent_client/mcp needs the \"mcp\" gem >= #{KindeSdk::AgentClient::MCP_MINIMUM_VERSION} " \
        "(found #{::MCP::VERSION}). Update it in your Gemfile."
end

module KindeSdk
  class AgentClient
    # The storage contract of the +mcp+ gem's OAuth client, kept in the store
    # of a {KindeSdk::AgentClient}: tokens under +mcp_tokens+
    # +[issuer, resource_url, account]+, the dynamic registration under
    # +mcp_registrations+ +[issuer, redirect_uri]+, sign-in attempts under
    # +mcp_pending+ +[resource_url, account, redirect_uri, state]+, and the
    # issuer last used under +mcp_issuers+ +[resource_url, account]+. The
    # hashes are the gem's own and are stored as they are; a registration
    # also gets +registered_at+, the time it was first stored.
    #
    # A sign-in attempt is kept under the account, resource and redirect URI
    # it was started for, so a provider for another account that shares the
    # store cannot finish it: the gem itself does not check whose it is.
    #
    # A configured +client_id+ / +client_secret+ is never stored. With
    # +issuer+ configured it is handed to the gem stamped with that issuer, so
    # the gem uses it at that authorization server only; at any other one the
    # gem registers a client of its own, which is stored as usual.
    #
    # @example
    #   storage = KindeSdk::AgentClient::McpStorage.new(agent.config)
    #   storage.tokens # => { "access_token" => "...", "issuer" => "https://..." } or nil
    class McpStorage
      # @param config [KindeSdk::AgentClient::Config]
      # @raise [ArgumentError] when +issuer+ is configured and +client_id+ is
      #   an https URL with a path: the gem takes such a client ID for a
      #   client ID metadata document and uses it at every authorization server
      # @example
      #   KindeSdk::AgentClient::McpStorage.new(agent.config)
      def initialize(config)
        if config.issuer && ::MCP::Client::OAuth::Discovery.client_id_metadata_document_url?(config.client_id)
          raise ArgumentError,
                "client_id must not be an https URL with a path when issuer is set: the mcp gem would use it, " \
                "with its secret, at any authorization server"
        end

        @config = config
        @store = config.storage
      end

      # @return [Hash, nil] the token response the gem saved, or nil
      # @example
      #   storage.tokens&.fetch("access_token")
      def tokens
        issuer = pointer
        issuer && @store.read("mcp_tokens", token_key(issuer))
      end

      # @param tokens [Hash, nil] the token response, stamped with +issuer+ by the gem; nil deletes
      # @return [Hash, nil] what was given
      # @example
      #   storage.save_tokens(nil) # forget the tokens
      def save_tokens(tokens)
        if tokens.nil?
          issuer = pointer
          @store.delete("mcp_tokens", token_key(issuer)) if issuer
          return nil
        end

        issuer = issuer_in(tokens) || pointer || ""
        remember(issuer)
        @store.write("mcp_tokens", token_key(issuer), tokens)
        tokens
      end

      # The client the gem should use: the stored dynamic registration, or the
      # configured +client_id+ / +client_secret+. A registration is returned
      # until it expires, so a callback and a refresh still find the one they
      # were started with; {#renew_registration} replaces it earlier, when a
      # new sign-in starts.
      #
      # With +issuer+ configured, the configured client always carries
      # <tt>"issuer"</tt>, which makes the gem refuse it at any other
      # authorization server; once the gem works with another one, its
      # registration there is returned instead.
      #
      # @return [Hash, nil]
      # @example
      #   storage.client_information&.fetch("client_id")
      def client_information
        issuer = pointer
        return configured(@config.issuer || issuer) if configured_at?(issuer)

        record = issuer && @store.read("mcp_registrations", [issuer, @config.redirect_uri])
        record.is_a?(Hash) && !expired?(record) ? record : nil
      end

      # Called when a new sign-in starts, before the gem reads the client,
      # with the authorization server the gem is about to use.
      #
      # The registration is kept per redirect URI and shared by the accounts
      # of a store, but {#client_information} finds it through the issuer
      # stored for the account, and an account that never signed in has
      # none. The gem would then register again and overwrite the
      # registration: the sign-in another account has under way would be
      # refused at its callback, and its tokens could no longer be refreshed.
      # So an account without an issuer is pointed at this authorization
      # server when a registration is stored for it, and the gem reuses it.
      #
      # Two limits remain, both for sign-in attempts under way (ten minutes):
      # first sign-ins of two accounts that start at the same moment still
      # register twice, and so does a sign-in that replaces a registration
      # about to expire (see {#renew_registration}).
      #
      # @api private
      # @param authorization_server [String] the issuer
      # @return [nil]
      # @example
      #   storage.adopt_registration("https://yourbiz.kinde.com/oauth2/agents/app_id")
      def adopt_registration(authorization_server)
        return nil unless pointer.nil? && authorization_server.is_a?(String) && !authorization_server.empty?
        return nil if configured_at?(authorization_server)

        record = @store.read("mcp_registrations", [authorization_server, @config.redirect_uri])
        remember(authorization_server) if record.is_a?(Hash)
        nil
      end

      # Called when a new sign-in starts, before the gem reads the client:
      # deletes a stored registration that is due for renewal (a day before
      # it expires; see {Registration.renewal_due?}), so the gem
      # registers again and the new sign-in does not get a client that is
      # about to stop working.
      #
      # @api private
      # @return [nil]
      # @example
      #   storage.renew_registration
      def renew_registration
        issuer = pointer
        return nil if issuer.nil? || configured_at?(issuer)

        key = [issuer, @config.redirect_uri]
        record = @store.read("mcp_registrations", key)
        @store.delete("mcp_registrations", key) if record.is_a?(Hash) && Registration.renewal_due?(record)
        nil
      end

      # @param info [Hash, nil] the registration, stamped with +issuer+ by the gem; nil deletes
      # @return [Hash, nil] what was given
      # @example
      #   storage.save_client_information(nil) # forget the registration
      def save_client_information(info)
        return forget_client if info.nil?

        issuer = issuer_in(info) || pointer || ""
        remember(issuer)
        # The configured client is read from the settings each time; its secret is not copied into the store.
        @store.write("mcp_registrations", [issuer, @config.redirect_uri], registered(info)) unless configured_at?(issuer)
        info
      end

      # @param state [String]
      # @param pending [Hash] the attempt, with the PKCE verifier
      # @return [Hash] what was given
      # @example
      #   storage.save_pending_authorization(state, pending)
      def save_pending_authorization(state, pending)
        @store.write("mcp_pending", pending_key(state), pending)
        pending
      end

      # @param state [String]
      # @return [Hash, nil] nil also for an attempt of another account,
      #   resource or redirect URI
      # @example
      #   storage.pending_authorization(params["state"])
      def pending_authorization(state)
        @store.read("mcp_pending", pending_key(state))
      end

      # Removes the attempt and returns it in one step, so one callback only can use it.
      #
      # @param state [String]
      # @return [Hash, nil]
      # @example
      #   storage.delete_pending_authorization(params["state"])
      def delete_pending_authorization(state)
        @store.delete("mcp_pending", pending_key(state))
      end

      # @return [String] where things are kept; never a token, verifier or secret
      def inspect
        "#<#{self.class.name} resource_url=#{@config.resource_url.inspect} account=#{@config.account.inspect} " \
          "tokens=#{tokens.nil? ? 'nil' : '[present]'}>"
      end

      private

      def pointer_key
        [@config.resource_url, @config.account]
      end

      def token_key(issuer)
        [issuer, @config.resource_url, @config.account]
      end

      def pending_key(state)
        [@config.resource_url, @config.account, @config.redirect_uri, state]
      end

      def pointer
        issuer = @store.read("mcp_issuers", pointer_key)
        issuer.is_a?(String) ? issuer : nil
      end

      def remember(issuer)
        @store.write("mcp_issuers", pointer_key, issuer) unless pointer == issuer
      end

      # The registration with the time it was first stored, which decides
      # when it is due for renewal (see {Registration.renewal_due?}). The gem
      # hands a registration it read back unchanged, so the time stays.
      def registered(info)
        info.key?(Registration::REGISTERED_AT) ? info : info.merge(Registration::REGISTERED_AT => Clock.now)
      end

      def issuer_in(hash)
        issuer = hash["issuer"] || hash[:issuer]
        issuer.is_a?(String) && !issuer.empty? ? issuer : nil
      end

      # Whether the configured client is the one to use while the gem works
      # with +issuer+ (nil: no authorization server yet).
      def configured_at?(issuer)
        !@config.client_id.nil? && (@config.issuer.nil? || issuer.nil? || issuer == @config.issuer)
      end

      def configured(issuer)
        info = { "client_id" => @config.client_id }
        info["client_secret"] = @config.client_secret if @config.client_secret
        info["issuer"] = issuer if issuer
        info
      end

      def expired?(record)
        expires_at = record["client_secret_expires_at"]
        expires_at.is_a?(Numeric) && !expires_at.zero? && expires_at <= Clock.now
      end

      # The gem found the stored client bound to another authorization server.
      def forget_client
        issuer = pointer
        return nil if issuer.nil?

        @store.delete("mcp_registrations", [issuer, @config.redirect_uri])
        if @config.client_id
          @store.delete("mcp_tokens", token_key(issuer))
          @store.delete("mcp_issuers", pointer_key)
        end
        nil
      end
    end

    # OAuth provider for MCP clients built on the official +mcp+ gem: it hands
    # the settings and the store of a {KindeSdk::AgentClient} to the gem's own
    # OAuth flow. Discovery, PKCE, +state+, the token exchange and refresh stay
    # the gem's; this class only supplies values, and keeps +openid+ out of
    # every authorization request.
    #
    # Optional. It is loaded only by <tt>require "kinde_sdk/agent_client/mcp"</tt>
    # and needs the +mcp+ gem, version {MCP_MINIMUM_VERSION} or later, in your
    # Gemfile; +kinde_sdk+ does not depend on it.
    #
    # Sign-in is server-hosted: the gem raises
    # +MCP::Client::OAuth::Flow::AuthorizationPendingError+ with the
    # +authorization_url+, and your callback route calls {#finish!}.
    #
    # @example
    #   require "kinde_sdk/agent_client/mcp"
    #
    #   agent = KindeSdk::AgentClient.new(resource_url: url, redirect_uri: callback_url,
    #                                     storage: KindeSdk::AgentClient::SessionStore.new(session))
    #   provider = KindeSdk::AgentClient::KindeOAuthProvider.new(agent)
    #   transport = MCP::Client::HTTP.new(url: agent.config.resource_url, oauth: provider)
    class KindeOAuthProvider < ::MCP::Client::OAuth::Provider
      # @return [KindeSdk::AgentClient] the agent client this provider wraps
      attr_reader :agent_client

      # @param agent_client [KindeSdk::AgentClient]
      # @param redirect_handler [#call, nil] called with the authorization URL
      #   before the gem raises; the default does nothing
      # @param http_client_customizer [#call, nil] passed to the gem: called
      #   with the Faraday connection of its OAuth requests
      # @param pending_authorization_max_age [Integer] seconds a sign-in
      #   attempt stays usable: 600 at most, because {MemoryStore} and
      #   {SessionStore} drop attempts older than that
      # @raise [ArgumentError] when +agent_client+ is anything else, when both
      #   +client_metadata_url+ and +client_id+ are configured (the gem cannot
      #   try one and then the other), when +issuer+ is configured and
      #   +client_id+ is an https URL with a path (see {McpStorage#initialize}),
      #   when +pending_authorization_max_age+ is above 600, or from the gem
      #   for a value it refuses
      # @example
      #   KindeSdk::AgentClient::KindeOAuthProvider.new(agent)
      def initialize(agent_client, redirect_handler: nil, http_client_customizer: nil, pending_authorization_max_age: 600)
        raise ArgumentError, "agent_client must be a KindeSdk::AgentClient" unless agent_client.is_a?(::KindeSdk::AgentClient)

        config = agent_client.config
        if config.client_metadata_url && config.client_id
          raise ArgumentError,
                "configure either client_metadata_url or client_id for the MCP adapter, not both: " \
                "the mcp gem uses a stored client before a client ID metadata document"
        end

        if pending_authorization_max_age.is_a?(Integer) && pending_authorization_max_age > Storage::PENDING_MAX_AGE
          raise ArgumentError,
                "pending_authorization_max_age must be #{Storage::PENDING_MAX_AGE} seconds or less: " \
                "the stores drop sign-in attempts older than that"
        end

        @agent_client = agent_client
        scopes = config.scopes - ["openid"]
        storage = McpStorage.new(config)
        super(
          client_metadata: {
            "redirect_uris" => [config.redirect_uri],
            "client_name" => config.client_name,
            "grant_types" => ClientMetadata::GRANT_TYPES.dup,
            "response_types" => ClientMetadata::RESPONSE_TYPES.dup,
            "token_endpoint_auth_method" => ClientMetadata::AUTH_METHOD
          },
          redirect_uri: config.redirect_uri,
          redirect_handler: redirect_handler || ->(_authorization_url) {},
          callback_handler: nil,
          scope: scopes.empty? ? nil : scopes.join(" "),
          scope_selector: ->(supported) { supported - ["openid"] },
          storage: storage,
          client_id_metadata_document_url: config.client_metadata_url,
          authorization_request_validator: lambda do |request|
            next false if request.scopes.include?("openid")

            # The gem asks this when a sign-in starts, before it reads the client, and it is the only place it
            # names the authorization server it is about to use.
            storage.adopt_registration(request.authorization_server)
            storage.renew_registration
            # The store may still point at another authorization server; what is kept for that one is dropped
            # here, as the gem would drop it, so that the gem is handed the configured client and does not
            # register a client of its own: at the configured issuer, or, without one, at whichever server
            # the resource names now.
            if config.client_id && (config.issuer.nil? || request.authorization_server == config.issuer)
              bound = storage.client_information&.fetch("issuer", nil)
              stale = config.issuer ? bound != config.issuer : bound && bound != request.authorization_server
              storage.save_client_information(nil) if stale
            end
            true
          end,
          http_client_customizer: http_client_customizer,
          pending_authorization_max_age: pending_authorization_max_age
        )
      end

      # Finishes a sign-in in your callback route: the gem checks +state+
      # (single use) and +iss+, exchanges the code and stores the tokens.
      #
      # @param callback_params [Hash] the query parameters of the redirect, String or Symbol keys
      # @return [Symbol] +:authorized+
      # @raise [MCP::Client::OAuth::Flow::AuthorizationError] when the callback or the code is refused
      # @example In a Rails controller
      #   provider.finish!(request.query_parameters)
      def finish!(callback_params)
        ::MCP::Client::OAuth::Flow.new(provider: self)
                                  .finish!(server_url: agent_client.config.resource_url, callback_params: callback_params)
      end
    end
  end
end
