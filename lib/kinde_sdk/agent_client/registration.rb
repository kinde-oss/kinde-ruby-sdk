# frozen_string_literal: true

require "json"

module KindeSdk
  class AgentClient
    # Decides which client identity the agent uses at an authorization server
    # and, when needed, registers one (RFC 7591).
    #
    # An identity is a Hash with +client_id+, +client_secret+ (or nil),
    # +token_endpoint_auth_method+ and +source+ ("cimd", "configured" or
    # "registration").
    #
    # @api private
    class Registration
      include KindeSdk::Logging

      NAMESPACE = "registrations"
      # A stored registration this close to its expiry is replaced (see {.renewal_due?}).
      RENEW_SECONDS = 86_400
      STORED_FIELDS = %w[client_id client_secret token_endpoint_auth_method client_secret_expires_at].freeze
      # Member of a stored registration: when it was made, in seconds since the epoch.
      REGISTERED_AT = "registered_at"

      # Whether a stored registration should be replaced at the next sign-in:
      # a day before it expires. One that was issued for less than two days
      # is replaced in the second half of its life instead, so that a server
      # which issues registrations for a few hours is not asked for a new
      # one at every sign-in. One that has expired is always due. A
      # registration that does not expire is never due.
      #
      # @api private
      # @param record [Hash] a stored registration
      # @return [Boolean]
      def self.renewal_due?(record)
        expires_at = record["client_secret_expires_at"]
        return false unless expires_at.is_a?(Numeric) && !expires_at.zero?
        # Whatever the window: one issued with no lifetime has a window of none.
        return true if expires_at <= Clock.now

        registered_at = record[REGISTERED_AT]
        window = RENEW_SECONDS
        window = [window, (expires_at - registered_at) / 2].min if registered_at.is_a?(Numeric)
        expires_at - Clock.now < window
      end
      # Member of a stored registration that holds the one it replaced before
      # that one expired, so tokens issued to it can still be refreshed and revoked.
      PREVIOUS = "previous"
      # The methods that send +client_secret+; each needs one.
      SECRET_METHODS = %w[client_secret_basic client_secret_post].freeze

      # @param config [Config]
      def initialize(config)
        @config = config
      end

      # The identity to use, in this order: client ID metadata document,
      # configured client ID, stored or new registration. The configured
      # client is skipped at any issuer other than the configured one.
      #
      # @param metadata [Hash] validated authorization server metadata
      # @return [Hash] the identity
      # @raise [DiscoveryError] when the server supports none of the three
      # @raise [RegistrationError, UnavailableError] when registering fails
      def client_identity(metadata)
        if @config.client_metadata_url && metadata["client_id_metadata_document_supported"] == true
          return identity(@config.client_metadata_url, nil, "none", "cimd")
        end
        return configured_identity(metadata) if configured_at?(metadata["issuer"])

        if @config.client_id
          log_warning(
            "The resource names authorization server #{Url.display(metadata['issuer'])}, not the configured issuer; " \
            "the configured client_id is not used there"
          )
        end
        registered_identity(metadata)
      end

      # The identity a +client_id+ recorded earlier belongs to, without registering.
      #
      # @param client_id [String]
      # @param issuer [String]
      # @yieldreturn [Hash] the authorization server metadata, asked for only when needed
      # @return [Hash, nil] nil when this client no longer has that identity,
      #   or has it at another issuer than +issuer+.
      #   A registration that was replaced before it expired still counts
      #   until it expires.
      def identity_for(client_id, issuer)
        return identity(client_id, nil, "none", "cimd") if client_id == @config.client_metadata_url
        return configured_identity(yield) if client_id == @config.client_id && configured_at?(issuer)

        record = @config.storage.read(NAMESPACE, key(issuer))
        return nil unless record.is_a?(Hash)
        return from_record(record) if record["client_id"] == client_id

        previous = record[PREVIOUS]
        from_record(previous) if previous.is_a?(Hash) && previous["client_id"] == client_id && !expired?(previous)
      end

      # Registers and stores the result. A registration it replaces that has
      # not expired yet is kept inside the new record (see {PREVIOUS}).
      #
      # @param metadata [Hash] validated authorization server metadata
      # @return [Hash] the new identity, already stored
      # @raise [RegistrationError, DiscoveryError, UnavailableError]
      def register(metadata)
        issuer = metadata["issuer"]
        endpoint = Discovery.endpoint(metadata, "registration_endpoint", loopback: @config.loopback_resource?)
        result = Http.request(
          :post, endpoint,
          headers: { "Content-Type" => "application/json", "Accept" => "application/json" },
          body: JSON.generate(request_body)
        )
        document = Http.parse_object(result.body) || {}
        refuse!(result.status, document, issuer) unless (200..299).cover?(result.status) && usable?(document)

        record = STORED_FIELDS.to_h { |field| [field, document[field]] }
        record["token_endpoint_auth_method"] ||= record["client_secret"] ? "client_secret_basic" : "none"
        record[REGISTERED_AT] = Clock.now
        check_authentication!(record, result.status)
        replaced = @config.storage.read(NAMESPACE, key(issuer))
        record[PREVIOUS] = replaced.slice(*STORED_FIELDS) if replaced.is_a?(Hash) && usable?(replaced) && !expired?(replaced)
        @config.storage.write(NAMESPACE, key(issuer), record)
        from_record(record)
      end

      # @param issuer [String]
      # @return [Hash, nil] the removed registration
      def forget(issuer)
        KeyedLock.synchronize(lock_key(issuer)) { @config.storage.delete(NAMESPACE, key(issuer)) }
      end

      # Drops the registration the authorization server no longer accepts.
      # When that is the replaced one (see {PREVIOUS}), only it is removed and
      # the current registration stays. When it is the current one, a replaced
      # one that has not expired takes its place, so the next {#register}
      # keeps it and tokens issued to it are still refreshed and revoked.
      #
      # Read and changed under the lock registrations take, so a sign-in
      # that registers at the same moment is not undone: what it stored is
      # read here, and kept.
      #
      # @param issuer [String]
      # @param client_id [String] the client the server refused
      # @return [Boolean] true when the current registration was dropped;
      #   false when it is still stored, so there is no need to register again
      def forget_client(issuer, client_id)
        KeyedLock.synchronize(lock_key(issuer)) do
          record = @config.storage.read(NAMESPACE, key(issuer))
          record = {} unless record.is_a?(Hash)
          previous = record[PREVIOUS]
          previous = nil unless previous.is_a?(Hash)

          if usable?(record) && record["client_id"] != client_id
            if previous && previous["client_id"] == client_id
              @config.storage.write(NAMESPACE, key(issuer), record.reject { |field, _| field == PREVIOUS })
            end
            next false
          end

          if previous && usable?(previous) && !expired?(previous) && previous["client_id"] != client_id
            @config.storage.write(NAMESPACE, key(issuer), previous.slice(*STORED_FIELDS))
          else
            @config.storage.delete(NAMESPACE, key(issuer))
          end
          true
        end
      end

      private

      def key(issuer)
        [issuer, @config.redirect_uri]
      end

      # The key of the in-process lock on a registration.
      def lock_key(issuer)
        ["registration", Storage.lock_scope(@config.storage), *key(issuer)]
      end

      # The stored registration, or a new one. A stored one is used even when
      # the server no longer has a registration endpoint (it is optional in
      # RFC 8414); the endpoint is needed only to register.
      #
      # Looked up and registered under a process-wide lock for this key and
      # the lock scope of the store: of two sign-ins that start together, the
      # second waits and finds what the first stored, so they do not register
      # twice and overwrite each other. Two processes that share a store are
      # not covered.
      def registered_identity(metadata)
        issuer = metadata["issuer"]
        KeyedLock.synchronize(lock_key(issuer)) do
          stored = stored(issuer)
          next from_record(stored) if stored
          next register(metadata) if metadata["registration_endpoint"]

          raise DiscoveryError,
                "The authorization server supports neither client ID metadata documents nor dynamic registration; " \
                "configure client_id"
        end
      end

      def identity(client_id, client_secret, method, source)
        {
          "client_id" => client_id, "client_secret" => client_secret,
          "token_endpoint_auth_method" => method, "source" => source
        }
      end

      def from_record(record)
        identity(record["client_id"], record["client_secret"], record["token_endpoint_auth_method"], "registration")
      end

      # The configured client (and its secret) belongs to one authorization
      # server: with +issuer+ configured it is used there and nowhere else.
      def configured_at?(issuer)
        !@config.client_id.nil? && (@config.issuer.nil? || @config.issuer == issuer)
      end

      # A confidential pre-registered client uses client_secret_post when the
      # server lists it, else the RFC 8414 default, client_secret_basic.
      def configured_identity(metadata)
        return identity(@config.client_id, nil, "none", "configured") if @config.client_secret.nil?

        supported = metadata["token_endpoint_auth_methods_supported"]
        method = supported.is_a?(Array) && supported.include?("client_secret_post") ? "client_secret_post" : "client_secret_basic"
        identity(@config.client_id, @config.client_secret, method, "configured")
      end

      # A stored registration that is not due for renewal.
      def stored(issuer)
        record = @config.storage.read(NAMESPACE, key(issuer))
        return nil unless record.is_a?(Hash) && usable?(record)

        self.class.renewal_due?(record) ? nil : record
      end

      def expired?(record)
        expires_at = record["client_secret_expires_at"]
        expires_at.is_a?(Numeric) && !expires_at.zero? && expires_at <= Clock.now
      end

      def usable?(document)
        document["client_id"].is_a?(String) && !document["client_id"].empty?
      end

      # The server may register the client with another authentication method
      # than the one asked for (RFC 7591). One the client cannot use is
      # refused here, before anything is stored and before the user is sent
      # to sign in: the token request would fail after the consent.
      def check_authentication!(record, status)
        method = record["token_endpoint_auth_method"]
        secret = record["client_secret"]
        return if method == "none"
        return if SECRET_METHODS.include?(method) && secret.is_a?(String) && !secret.empty?

        raise RegistrationError.new(
          "The authorization server registered the client with a token endpoint authentication method this " \
          "client cannot use (it supports none, client_secret_basic and client_secret_post)",
          status: status
        )
      end

      def request_body
        {
          "redirect_uris" => [@config.redirect_uri],
          "client_name" => @config.client_name,
          "grant_types" => ClientMetadata::GRANT_TYPES,
          "response_types" => ClientMetadata::RESPONSE_TYPES,
          "token_endpoint_auth_method" => ClientMetadata::AUTH_METHOD
        }
      end

      def refuse!(status, document, issuer)
        error = string(document["error"])
        description = string(document["error_description"])
        log_warning(
          "Client registration for redirect URI #{Url.display(@config.redirect_uri)} was refused with status #{status}" \
          "#{": #{[error, description].compact.join(' - ')}" if error || description}"
        )
        clear_issuer(issuer) if status == 404

        raise RegistrationError.new(refusal_message(status, error, description),
                                    error: error, error_description: description, status: status)
      end

      def refusal_message(status, error, description)
        return "Too many registrations; try again later" if status == 429
        return description if error == "invalid_redirect_uri" && description
        if status == 404
          return "The authorization server no longer has this application (registration answered 404); " \
                 "what was stored for it has been cleared"
        end

        ["Client registration failed with status #{status}", error, description].compact.join(": ")
      end

      # The application is gone: drop everything this client can address for the issuer.
      def clear_issuer(issuer)
        storage = @config.storage
        storage.delete(NAMESPACE, key(issuer))
        storage.delete("tokens", [issuer, @config.resource_url, @config.account])
        pointer = [@config.resource_url, @config.account]
        storage.delete("issuers", pointer) if storage.read("issuers", pointer) == issuer
        Discovery.reset_cache!(issuer)
      end

      def string(value)
        value.is_a?(String) && !value.empty? ? value : nil
      end
    end
  end
end
