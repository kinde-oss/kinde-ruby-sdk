# frozen_string_literal: true

require "kinde_sdk/errors"
require "kinde_sdk/logging"
require "kinde_sdk/agent_client/url"
require "kinde_sdk/agent_client/http"
require "kinde_sdk/agent_client/storage"
require "kinde_sdk/agent_client/client_metadata"
require "kinde_sdk/agent_client/config"
require "kinde_sdk/agent_client/www_authenticate"
require "kinde_sdk/agent_client/discovery"
require "kinde_sdk/agent_client/registration"
require "kinde_sdk/agent_client/authorization"
require "kinde_sdk/agent_client/token_endpoint"

module KindeSdk
  # Agent-client helpers: lets software you build act as an AI agent that
  # signs a user in to an MCP server (or any OAuth-protected API) and calls it
  # with a bearer token. It discovers the authorization server from the
  # resource, identifies itself (client ID metadata document, a configured
  # client ID, or dynamic registration), runs the authorization code flow with
  # PKCE, refreshes and revokes.
  #
  # One instance serves one resource and one user (+account+). It is opt-in
  # and separate from the login flow ({KindeSdk.configure}) and from the
  # resource-server helpers ({KindeSdk::AgentAuth}).
  #
  # Sign-in is server-hosted: the client never opens a browser and never
  # waits. When the user has to sign in, {#fetch} and {#connect} raise
  # {AuthorizationRequiredError} with the URL to redirect to, and your
  # callback route finishes with {#handle_callback}.
  #
  # @example In a Rails controller
  #   agent = KindeSdk::AgentClient.new(
  #     resource_url: "https://api.example.com/mcp",
  #     redirect_uri: "https://agent.example.com/oauth/callback",
  #     storage: KindeSdk::AgentClient::SessionStore.new(session)
  #   )
  #   begin
  #     response = agent.fetch("/documents")
  #   rescue KindeSdk::AgentClient::AuthorizationRequiredError => e
  #     redirect_to e.authorization_url, allow_other_host: true
  #   end
  class AgentClient
    include KindeSdk::Logging

    # What {#token_info} returns. It never holds a token.
    #
    # @!attribute scopes
    #   @return [Array<String>] the granted scopes
    # @!attribute expires_at
    #   @return [Integer, nil] when the access token expires, in seconds since the epoch
    # @!attribute client_id
    #   @return [String] the client ID the tokens were issued to
    TokenInfo = Struct.new(:scopes, :expires_at, :client_id, keyword_init: true)

    # What {#fetch} returns.
    #
    # @!attribute status
    #   @return [Integer]
    # @!attribute headers
    #   @return [Hash{String=>String}] lower-case names; repeated headers joined with ", "
    # @!attribute body
    #   @return [String]
    Response = Struct.new(:status, :headers, :body, keyword_init: true)

    # A token this close to its expiry is refreshed before it is sent.
    REFRESH_WINDOW_SECONDS = 60
    ABSOLUTE_URL = %r{\A[A-Za-z][A-Za-z0-9+.\-]*://}.freeze
    # A "." or ".." path segment, also when the dots or the separators around
    # it are percent-encoded ("%2e%2e%2fadmin"): a server or proxy that decodes
    # them would leave the resource. An encoded slash elsewhere ("a%2Fb") is fine.
    DOT_SEGMENT = %r{(?:\A|/|%2f|%5c)(?:\.|%2e){1,2}(?:/|%2f|%5c|\z)}i.freeze
    # Thrown inside the token lock when the user has to sign in; the sign-in
    # is started, and the +on_auth_required+ block called, after the lock is
    # released.
    SIGN_IN = :kinde_agent_client_sign_in
    private_constant :ABSOLUTE_URL, :DOT_SEGMENT, :SIGN_IN

    # One lock per key, for every client in this process. It serialises
    # refreshes, sign-outs and token writes per token record, and
    # registrations per registration key. Every key starts with the lock
    # scope of the store (see {Storage.lock_scope}), so users whose stores
    # hold unrelated data do not wait for each other. The locks are not
    # reentrant: no block of the application is called while one is held.
    #
    # @api private
    module KeyedLock
      @table = {}
      @guard = Mutex.new

      # @param key [Array]
      # @yield with the lock for +key+ held
      def self.synchronize(key)
        entry = @guard.synchronize do
          found = (@table[key] ||= [Mutex.new, 0])
          found[1] += 1
          found
        end
        entry[0].synchronize { yield }
      ensure
        if entry
          @guard.synchronize do
            entry[1] -= 1
            @table.delete(key) if entry[1].zero?
          end
        end
      end
    end

    class << self
      # Builds the client ID metadata document of an agent: the JSON an
      # authorization server fetches from the agent's +client_id+ URL.
      #
      # @param client_id [String] the https URL the document is served at; it
      #   needs a path and no userinfo, query or fragment
      # @param client_name [String]
      # @param redirect_uris [Array<String>] each one https on the host of
      #   +client_id+, or http on localhost, 127.0.0.1 or [::1] (any port)
      # @param client_uri [String, nil]
      # @param logo_uri [String, nil]
      # @return [Hash{String=>Object}] +client_id+, +client_name+, +client_uri+
      #   and +logo_uri+ when given, +redirect_uris+, +grant_types+,
      #   +response_types+ and +token_endpoint_auth_method+ ("none")
      # @raise [ArgumentError] naming the value that is refused. Kinde drops
      #   redirect URIs on other hosts and custom schemes, so they are errors here.
      # @example
      #   KindeSdk::AgentClient.build_client_metadata_document(
      #     client_id: "https://agent.example.com/oauth/client-metadata.json",
      #     client_name: "Example Agent",
      #     redirect_uris: ["https://agent.example.com/oauth/callback"]
      #   )
      def build_client_metadata_document(client_id:, client_name:, redirect_uris:, client_uri: nil, logo_uri: nil)
        ClientMetadata.build(client_id: client_id, client_name: client_name, redirect_uris: redirect_uris,
                             client_uri: client_uri, logo_uri: logo_uri)
      end
      alias_method :buildClientMetadataDocument, :build_client_metadata_document

      # A Rack app that serves the client ID metadata document. Mount it at
      # the exact path of +client_id+, on a public https host.
      #
      # @param client_id [String]
      # @param client_name [String]
      # @param redirect_uris [Array<String>]
      # @param client_uri [String, nil]
      # @param logo_uri [String, nil]
      # @return [KindeSdk::AgentClient::ClientMetadataApp]
      # @raise [ArgumentError] as {build_client_metadata_document}, or when the
      #   document is 64 KiB or larger
      # @example config.ru
      #   map "/oauth/client-metadata.json" do
      #     run KindeSdk::AgentClient.client_metadata_app(
      #       client_id: "https://agent.example.com/oauth/client-metadata.json",
      #       client_name: "Example Agent",
      #       redirect_uris: ["https://agent.example.com/oauth/callback"]
      #     )
      #   end
      def client_metadata_app(client_id:, client_name:, redirect_uris:, client_uri: nil, logo_uri: nil)
        ClientMetadataApp.new(
          build_client_metadata_document(client_id: client_id, client_name: client_name, redirect_uris: redirect_uris,
                                         client_uri: client_uri, logo_uri: logo_uri)
        )
      end
    end

    # @return [KindeSdk::AgentClient::Config] the settings (frozen)
    attr_reader :config

    # @param resource_url [String] the MCP server or API to call: https, or
    #   http on localhost, 127.0.0.1 or [::1]; no userinfo ("user:password@").
    #   The URLs the resource and its authorization server supply may be
    #   http on a loopback host only when this one is.
    # @param redirect_uri [String] the callback URL of your app, same rule
    # @param client_metadata_url [String, nil] the https URL of this agent's
    #   client ID metadata document; preferred when the server supports it
    # @param client_id [String, nil] a pre-registered client ID
    # @param client_secret [String, nil] its secret, for a confidential client; it needs +issuer+
    # @param issuer [String, nil] the issuer of the authorization server
    #   +client_id+ is registered at, exactly as the resource's metadata
    #   names it (same URL rule as +resource_url+). When the resource names
    #   any other authorization server, +client_id+ and +client_secret+ are
    #   not used there: the agent goes on with +client_metadata_url+ or
    #   dynamic registration, and the secret is never sent. Required with
    #   +client_secret+.
    # @param client_name [String] the name shown to users when the agent registers itself
    # @param scopes [Array<String>, String] the scopes to ask for. The default
    #   is +offline+; it is never taken from {KindeSdk.configure}.
    # @param storage [#read, #write, #delete, nil] where tokens and
    #   registrations are kept; defaults to a new {MemoryStore}
    # @param account [String] which user the tokens belong to, when one store
    #   holds several users
    # @raise [ArgumentError] for a missing or invalid value, or a
    #   +client_secret+ without +issuer+
    # @example
    #   KindeSdk::AgentClient.new(
    #     resource_url: "https://api.example.com/mcp",
    #     redirect_uri: "https://agent.example.com/oauth/callback",
    #     client_metadata_url: "https://agent.example.com/oauth/client-metadata.json"
    #   )
    # @example A pre-registered confidential client
    #   KindeSdk::AgentClient.new(
    #     resource_url: "https://api.example.com/mcp",
    #     redirect_uri: "https://agent.example.com/oauth/callback",
    #     client_id: ENV.fetch("AGENT_CLIENT_ID"),
    #     client_secret: ENV.fetch("AGENT_CLIENT_SECRET"),
    #     issuer: "https://yourbiz.kinde.com/oauth2/agents/app_id"
    #   )
    def initialize(resource_url:, redirect_uri:, client_metadata_url: nil, client_id: nil,
                   client_secret: nil, issuer: nil, client_name: Config::DEFAULT_CLIENT_NAME, scopes: Config::DEFAULT_SCOPES,
                   storage: nil, account: Config::DEFAULT_ACCOUNT)
      @config = Config.new(
        resource_url: resource_url, redirect_uri: redirect_uri, client_metadata_url: client_metadata_url,
        client_id: client_id, client_secret: client_secret, issuer: issuer, client_name: client_name, scopes: scopes,
        storage: storage, account: account
      )
      @discovery = Discovery.new(@config)
      @registration = Registration.new(@config)
      @authorization = Authorization.new(@config)
      @token_endpoint = TokenEndpoint.new(@config)
      @resource = Url.parse(@config.resource_url)
      @auth_required = nil
    end

    # Makes sure a usable token is stored, without calling the resource. A
    # token close to its expiry is refreshed; one that has expired and cannot
    # be refreshed is deleted and a sign-in attempt is started. With nothing
    # stored, the authorization server is discovered from the resource's
    # well-known URLs and a sign-in attempt is started. Never waits for a
    # browser.
    #
    # @return [TokenInfo] when a token is stored
    # @raise [AuthorizationRequiredError] when the user has to sign in; it
    #   carries the +authorization_url+
    # @raise [DiscoveryError, RegistrationError, OAuthError, UnavailableError]
    # @example
    #   begin
    #     agent.connect
    #   rescue KindeSdk::AgentClient::AuthorizationRequiredError => e
    #     redirect_to e.authorization_url, allow_other_host: true
    #   end
    def connect
      issuer = stored_issuer
      record = issuer && read_tokens(issuer)
      metadata = nil
      if record.nil?
        metadata = @discovery.discover
        issuer = metadata["issuer"]
        record = read_tokens(issuer)
        require_authorization!(metadata) if record.nil?
        remember_issuer(issuer)
      end
      token_info_of(usable_tokens(issuer, record, metadata))
    end

    # Calls the resource with the stored access token. The token is refreshed
    # first when it is about to expire; on a +401+ it is refreshed once and
    # the request is sent once more. The whole response is read into memory.
    #
    # The +Authorization+ header goes to the resource and nowhere else, and
    # redirects are not followed.
    #
    # @param path [String, nil] a path or query to add to +resource_url+
    #   ("/documents", "tools:list", "?page=2"), or an absolute URL
    #   ("https://...") at or under +resource_url+. When +resource_url+ has a
    #   query, the path goes before it and a query in +path+ is added after it.
    # @param method [Symbol, String] :get, :post, :put, :patch, :delete, :head or :options
    # @param headers [Hash{String=>String}] request headers; an +Authorization+ header is replaced
    # @param body [String, nil] the request body
    # @param timeout [Numeric] seconds
    # @return [Response] whatever the resource answered, including a +403+ or a redirect
    # @raise [ArgumentError] for a URL outside the resource, an unknown method
    #   or a body that is not a String; nothing is sent
    # @raise [AuthorizationRequiredError] when the user has to sign in (again),
    #   or the resource asks for more scope
    # @raise [DiscoveryError, RegistrationError, OAuthError, UnavailableError]
    # @example
    #   response = agent.fetch("/documents", method: :post, headers: { "Content-Type" => "application/json" },
    #                                        body: JSON.generate(title: "Notes"))
    #   response.status # => 200
    def fetch(path = nil, method: :get, headers: {}, body: nil, timeout: 30)
      request = { verb: verb!(method), url: target_url(path), headers: clean_headers(headers), body: body!(body), timeout: timeout }
      issuer = stored_issuer
      record = issuer && read_tokens(issuer)
      refreshed = false
      if record && refresh_due?(record)
        record = refresh!(issuer, @discovery.authorization_server_metadata(issuer), record, proactive: true)
        refreshed = true
      end

      result = perform(request, record)
      if result.status == 401
        result, issuer, record = recover(request, result, issuer, record, refreshed)
      end
      step_up!(result, issuer, record)
      Response.new(status: result.status, headers: result.headers.transform_values { |values| values.join(", ") }, body: result.body)
    end

    # Starts a sign-in attempt and returns where to send the user, without
    # raising. Use it for a "Connect" button.
    #
    # @param scopes [Array<String>, String, nil] scopes for this attempt; nil for the configured ones
    # @return [String] the authorization URL
    # @raise [DiscoveryError, RegistrationError, UnavailableError]
    # @example
    #   redirect_to agent.authorization_url, allow_other_host: true
    def authorization_url(scopes: nil)
      scopes = scopes.is_a?(String) ? scopes.split : scopes
      start_authorization(@discovery.discover, scopes: scopes || @config.scopes).first
    end

    # Finishes a sign-in in your callback route: checks +state+ (single use)
    # and +iss+, exchanges the code and stores the tokens.
    #
    # @param params [Hash] the query parameters of the redirect (+code+,
    #   +state+, and +iss+, +error+, +error_description+ when present), with
    #   String or Symbol keys
    # @return [TokenInfo]
    # @raise [CallbackError] for a missing, unknown, reused or expired
    #   +state+, another +iss+, an +iss+ that is empty or repeated, a missing
    #   +iss+ when the authorization server's metadata says it sends one, or
    #   a missing +code+. Nothing is retried.
    # @raise [OAuthError] when the authorization server reported an error or
    #   refused the code
    # @raise [AuthorizationRequiredError] when the authorization server no
    #   longer accepts the registration the sign-in was started with
    #   (+invalid_client+): the user has to be sent to the new
    #   +authorization_url+. The agent registered again for it, unless the
    #   refused registration had already been replaced by a newer one; then
    #   the newer one is used and nothing is registered.
    # @raise [DiscoveryError, RegistrationError, UnavailableError]
    # @example In a Rails controller
    #   def callback
    #     agent.handle_callback(request.query_parameters)
    #     redirect_to root_path
    #   end
    def handle_callback(params)
      attempt, code = @authorization.consume(params)
      issuer = attempt["issuer"]
      identity = @registration.identity_for(attempt["client_id"], issuer) { @discovery.authorization_server_metadata(issuer) }
      raise OAuthError, "The client registration changed after the sign-in started; start again" if identity.nil?

      begin
        tokens = @token_endpoint.exchange(attempt["token_endpoint"], identity, code: code,
                                          code_verifier: attempt["code_verifier"], redirect_uri: attempt["redirect_uri"])
      rescue OAuthError => e
        raise unless reregister?(e, identity) && !attempt["reregistered"]

        register_again!(issuer, identity, scopes: attempt["scopes"])
      end

      record = token_record(tokens, issuer, identity["client_id"], attempt["scopes"])
      # Under the token lock, so a request that is just giving up on the old
      # tokens (see #discard_tokens) cannot delete these.
      KeyedLock.synchronize(token_lock(issuer)) { write_tokens(issuer, record) }
      remember_issuer(issuer)
      token_info_of(record)
    end

    # Signs the user out of the resource: revokes the refresh token (or the
    # access token) when the authorization server has a revocation endpoint,
    # then deletes the stored tokens. A failed revocation is logged and
    # ignored; the tokens are deleted in every case.
    #
    # @param forget [Boolean] also delete the dynamic registration stored for
    #   this +redirect_uri+, whether or not the user is signed in. When no
    #   tokens are stored, the authorization server is looked up from the
    #   resource first (at most two requests); if that fails, a warning is
    #   logged and nothing is raised.
    # @return [true]
    # @example
    #   agent.disconnect
    #   agent.disconnect(forget: true)
    def disconnect(forget: false)
      issuer = stored_issuer
      if issuer
        # Under the lock refreshes take: a refresh that is under way finishes
        # first, so the tokens it stores are the ones revoked and deleted here,
        # and it cannot put tokens back after the sign-out.
        KeyedLock.synchronize(token_lock(issuer)) do
          record = read_tokens(issuer)
          revoke(issuer, record) if record
          delete_tokens(issuer)
          @config.storage.delete("issuers", pointer_key)
        end
      end
      forget_registration(issuer) if forget
      true
    end

    # Registers a block that is called with the authorization URL each time
    # {#fetch} or {#connect} finds that the user has to sign in, just before
    # {AuthorizationRequiredError} is raised.
    #
    # @yieldparam authorization_url [String]
    # @return [self]
    # @example
    #   agent.on_auth_required { |url| Rails.logger.info("Agent sign-in needed") }
    def on_auth_required(&block)
      @auth_required = block
      self
    end

    # What is known about the stored token, without any network call.
    #
    # @return [TokenInfo, nil] +scopes+, +expires_at+ and +client_id+; never a
    #   token. nil when nothing is stored.
    # @example
    #   agent.token_info&.scopes # => ["offline"]
    def token_info
      issuer = stored_issuer
      record = issuer && read_tokens(issuer)
      record && token_info_of(record)
    end

    # @return [String] the resource, the account and whether a token is stored; no secret
    def inspect
      "#<#{self.class.name} resource_url=#{@config.resource_url.inspect} account=#{@config.account.inspect} " \
        "signed_in=#{!token_info.nil?}>"
    end

    private

    # --- storage ---------------------------------------------------------

    def pointer_key
      [@config.resource_url, @config.account]
    end

    def token_key(issuer)
      [issuer, @config.resource_url, @config.account]
    end

    # The key of the in-process lock on a token record.
    def token_lock(issuer)
      ["tokens", Storage.lock_scope(@config.storage), *token_key(issuer)]
    end

    def stored_issuer
      issuer = @config.storage.read("issuers", pointer_key)
      issuer.is_a?(String) && !issuer.empty? ? issuer : nil
    end

    def remember_issuer(issuer)
      @config.storage.write("issuers", pointer_key, issuer) unless stored_issuer == issuer
    end

    def read_tokens(issuer)
      record = @config.storage.read("tokens", token_key(issuer))
      record.is_a?(Hash) && record["access_token"].is_a?(String) ? record : nil
    end

    def write_tokens(issuer, record)
      @config.storage.write("tokens", token_key(issuer), record)
    end

    def delete_tokens(issuer)
      @config.storage.delete("tokens", token_key(issuer))
    end

    # Deletes the stored tokens when they are still the ones in +sent+. When
    # other tokens were stored in the meantime (a sign-in that finished while
    # a request with the old ones was under way), they are kept.
    #
    # @return [Hash, nil] the newer record that was kept, or nil
    def discard_tokens(issuer, sent)
      KeyedLock.synchronize(token_lock(issuer)) do
        current = read_tokens(issuer)
        next current if current && current["access_token"] != sent["access_token"]

        delete_tokens(issuer)
        nil
      end
    end

    def token_record(tokens, issuer, client_id, requested_scopes)
      record = {
        "access_token" => tokens["access_token"],
        "expires_at" => expires_at(tokens),
        "scope" => tokens["scope"].is_a?(String) ? tokens["scope"] : requested_scopes.join(" "),
        "requested_scopes" => requested_scopes,
        "issuer" => issuer,
        "resource_url" => @config.resource_url,
        "client_id" => client_id
      }
      record["refresh_token"] = tokens["refresh_token"] if present?(tokens["refresh_token"])
      record
    end

    def expires_at(tokens)
      lifetime = TokenEndpoint.lifetime(tokens)
      lifetime && Clock.now + lifetime
    end

    def token_info_of(record)
      TokenInfo.new(scopes: record["scope"].to_s.split, expires_at: record["expires_at"], client_id: record["client_id"])
    end

    def present?(value)
      value.is_a?(String) && !value.empty?
    end

    # --- the request -----------------------------------------------------

    def verb!(method)
      verb = method.to_s.downcase.to_sym
      raise ArgumentError, "method must be one of #{Http::METHODS.join(', ')}" unless Http::METHODS.include?(verb)

      verb
    end

    def body!(body)
      raise ArgumentError, "body must be a String or nil" unless body.nil? || body.is_a?(String)

      body
    end

    def clean_headers(headers)
      raise ArgumentError, "headers must be a Hash" unless headers.is_a?(Hash)

      headers.reject { |name, _| name.to_s.casecmp?("authorization") }.to_h { |name, value| [name.to_s, value.to_s] }
    end

    # The URL to call: always the resource itself or something under it.
    def target_url(path)
      base = @config.resource_url
      url =
        if path.nil? || path.to_s.empty?
          base
        elsif path.to_s.match?(ABSOLUTE_URL)
          path.to_s
        else
          relative_url(base, path.to_s)
        end

      target = Url.parse(url)
      unless target && target.userinfo.nil? && Url.same_origin?(target, @resource) &&
             Url.path_covers?(@resource.path, target.path) && !target.path.match?(DOT_SEGMENT)
        raise ArgumentError, "fetch only calls #{Url.display(base)} and paths under it"
      end

      url
    end

    # +path+ under +base+; the query of +base+ stays a query, with the one of +path+ after it.
    def relative_url(base, path)
      base, base_query = base.split("?", 2)
      path, path_query = path.split("?", 2)
      url = path.to_s.empty? ? base : "#{base.delete_suffix('/')}/#{path.delete_prefix('/')}"
      query = [base_query, path_query].compact.join("&")
      base_query || path_query ? "#{url}?#{query}" : url
    end

    def perform(request, record)
      headers = request[:headers]
      headers = headers.merge("Authorization" => "Bearer #{record['access_token']}") if record
      Http.request(request[:verb], request[:url], headers: headers, body: request[:body], timeout: request[:timeout])
    end

    def challenge(result)
      WwwAuthenticate.bearer(result.headers["www-authenticate"]) || {}
    end

    # A 401: find the authorization server, send a stored token that was not
    # sent yet, refresh once, and give up with "sign in" after that.
    def recover(request, result, issuer, record, refreshed)
      metadata = @discovery.discover(challenge(result)["resource_metadata"])
      discovered = metadata["issuer"]
      if record && issuer != discovered
        # The tokens that were sent are from an authorization server the
        # resource no longer names. Newer ones are not this request's to delete.
        discard_tokens(issuer, record)
        record = nil
        # A refresh before the request was at the other authorization server.
        refreshed = false
      end

      if record.nil?
        record = read_tokens(discovered)
        require_authorization!(metadata) if record.nil?
        remember_issuer(discovered)
        result = perform(request, record)
        return [result, discovered, record] unless result.status == 401
      end

      # At most: one refresh, then tokens a sign-in stored in the meantime,
      # then their refresh when none was sent yet.
      2.times do
        if !refreshed && present?(record["refresh_token"])
          record = refresh!(discovered, metadata, record, proactive: false)
          refreshed = true
          result = perform(request, record)
          return [result, discovered, record] unless result.status == 401
        end

        # The refused tokens are deleted. Newer ones are sent once.
        record = discard_tokens(discovered, record)
        break if record.nil?

        result = perform(request, record)
        return [result, discovered, record] unless result.status == 401
      end
      discard_tokens(discovered, record) if record
      require_authorization!(metadata)
    end

    # A 403 insufficient_scope: sign in again with the wanted scopes added,
    # unless the stored token was already asked for with all of them.
    def step_up!(result, issuer, record)
      return unless result.status == 403 && issuer && record

      wanted = challenge(result)
      return unless wanted["error"] == "insufficient_scope"

      metadata = @discovery.authorization_server_metadata(issuer)
      current = record["requested_scopes"].is_a?(Array) ? record["requested_scopes"] : @config.scopes
      merged = @authorization.effective_scopes(metadata, current + wanted["scope"].to_s.split)
      return if (merged - current).empty?

      require_authorization!(metadata, scopes: merged)
    end

    # --- tokens ----------------------------------------------------------

    def refresh_due?(record)
      expiring?(record) && present?(record["refresh_token"])
    end

    def expiring?(record)
      record["expires_at"].is_a?(Numeric) && record["expires_at"] - Clock.now <= REFRESH_WINDOW_SECONDS
    end

    def expired?(record)
      record["expires_at"].is_a?(Numeric) && record["expires_at"] <= Clock.now
    end

    # The record {#connect} reports: refreshed when it is close to its
    # expiry. One that has expired and cannot be refreshed is of no use: it
    # is deleted and the user signs in. +metadata+ is nil until it is needed.
    # Never returns a record that has expired: the token endpoint refuses a
    # refreshed token that has no lifetime left.
    def usable_tokens(issuer, record, metadata)
      return record unless expiring?(record)

      refreshable = present?(record["refresh_token"])
      return record unless refreshable || expired?(record)

      metadata ||= @discovery.authorization_server_metadata(issuer)
      return refresh!(issuer, metadata, record, proactive: true) if refreshable

      # Newer tokens, stored while the metadata was fetched, get the same check.
      newer = discard_tokens(issuer, record)
      newer ? usable_tokens(issuer, newer, metadata) : require_authorization!(metadata)
    end

    # Refreshes under a process-wide lock for this token record. A caller
    # that waited for someone else's refresh gets that result and sends nothing.
    #
    # When the user has to sign in instead, that is started after the lock
    # is released: the +on_auth_required+ block may call {#disconnect}, which
    # takes the same lock.
    def refresh!(issuer, metadata, used, proactive:)
      sign_in = catch(SIGN_IN) do
        return KeyedLock.synchronize(token_lock(issuer)) do
          current = read_tokens(issuer)
          throw SIGN_IN, {} if current.nil?
          next current if proactive ? !expiring?(current) : current["access_token"] != used["access_token"]

          unless present?(current["refresh_token"])
            # Other tokens than the ones the caller saw, which cannot be
            # refreshed. Before a request they are used while they last;
            # after a 401 they are the ones that were refused.
            next current if proactive && !expired?(current)

            delete_tokens(issuer)
            throw SIGN_IN, {}
          end
          refresh_now(issuer, metadata, current)
        end
      end
      require_authorization!(metadata, **sign_in)
    end

    # Runs inside the token lock. Throws {SIGN_IN} with the options of the
    # sign-in when the user has to sign in.
    def refresh_now(issuer, metadata, current)
      identity = @registration.identity_for(current["client_id"], issuer) { metadata }
      if identity.nil?
        delete_tokens(issuer)
        throw SIGN_IN, {}
      end

      endpoint = Discovery.endpoint(metadata, "token_endpoint", loopback: @config.loopback_resource?)
      tokens = @token_endpoint.refresh(endpoint, identity, current["refresh_token"])
      record = current.merge("access_token" => tokens["access_token"], "expires_at" => expires_at(tokens))
      record["scope"] = tokens["scope"] if tokens["scope"].is_a?(String)
      record["refresh_token"] = tokens["refresh_token"] if present?(tokens["refresh_token"])
      write_tokens(issuer, record)
      # Not what the store's write returned: a store may return anything.
      record
    rescue OAuthError => e
      if refused?(e, "invalid_grant")
        delete_tokens(issuer)
        throw SIGN_IN, {}
      elsif reregister?(e, identity)
        throw SIGN_IN, drop_refused_registration(issuer, identity, scopes: current["requested_scopes"])
      end
      raise
    end

    # Whether the authorization server refused the request with +code+. The
    # code counts only in a 4xx answer: a 5xx answer says the server failed,
    # not that the grant or the client is no longer good, whatever its body.
    def refused?(error, code)
      error.error == code && (400..499).cover?(error.status)
    end

    def reregister?(error, identity)
      refused?(error, "invalid_client") && !error.is_a?(RegistrationError) && identity && identity["source"] == "registration"
    end

    # The registration is no longer accepted: drop it with the tokens issued
    # to it, register once, and send the user to sign in. When it was a
    # replaced registration, the current one is kept and nothing is registered.
    # When it was the current one, a replaced one that has not expired is kept.
    def register_again!(issuer, identity, scopes:)
      metadata = @discovery.authorization_server_metadata(issuer)
      require_authorization!(metadata, **drop_refused_registration(issuer, identity, scopes: scopes))
    end

    # @return [Hash] the options of the sign-in that has to follow
    def drop_refused_registration(issuer, identity, scopes:)
      tokens = read_tokens(issuer)
      delete_tokens(issuer) if tokens && tokens["client_id"] == identity["client_id"]
      reregistered = @registration.forget_client(issuer, identity["client_id"])
      { scopes: scopes.is_a?(Array) ? scopes : nil, reregistered: reregistered }
    end

    def revoke(issuer, record)
      metadata = @discovery.authorization_server_metadata(issuer)
      endpoint = Discovery.endpoint(metadata, "revocation_endpoint", loopback: @config.loopback_resource?, required: false)
      return if endpoint.nil?

      identity = @registration.identity_for(record["client_id"], issuer) { metadata }
      identity ||= { "client_id" => record["client_id"], "token_endpoint_auth_method" => "none" }
      status = @token_endpoint.revoke(endpoint, identity, record["refresh_token"] || record["access_token"])
      log_warning("Token revocation answered status #{status}; the stored tokens are deleted anyway") unless (200..299).cover?(status)
    rescue Error => e
      log_warning("Token revocation failed (#{e.message}); the stored tokens are deleted anyway")
    end

    # Without a stored issuer the registration key is found from the resource's metadata.
    def forget_registration(issuer)
      issuer ||= @discovery.issuer_of(@discovery.protected_resource_metadata)
      @registration.forget(issuer)
    rescue Error => e
      log_warning("The stored registration was not deleted: its authorization server could not be found (#{e.message})")
    end

    # --- sign-in ---------------------------------------------------------

    def start_authorization(metadata, scopes: nil, reregistered: false)
      identity = @registration.client_identity(metadata)
      @authorization.start(metadata, identity, scopes: scopes || @config.scopes, reregistered: reregistered)
    end

    def require_authorization!(metadata, scopes: nil, reregistered: false)
      url, state = start_authorization(metadata, scopes: scopes, reregistered: reregistered)
      @auth_required&.call(url)
      raise AuthorizationRequiredError.new(authorization_url: url, state: state)
    end
  end
end
