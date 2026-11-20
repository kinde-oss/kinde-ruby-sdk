# frozen_string_literal: true

module KindeSdk
  class AgentClient
    # Finds and checks the two metadata documents: the protected resource
    # metadata of the resource (RFC 9728) and the metadata of its authorization
    # server (RFC 8414). Every endpoint the client calls is read from the
    # second one; no endpoint path is built by hand.
    #
    # @api private
    class Discovery
      CACHE_SECONDS = 300
      RESOURCE_WELL_KNOWN = "/.well-known/oauth-protected-resource"
      SERVER_WELL_KNOWN = "/.well-known/oauth-authorization-server"
      OPENID_WELL_KNOWN = "/.well-known/openid-configuration"

      @cache = {}
      @mutex = Mutex.new

      class << self
        # Forgets cached authorization server metadata.
        #
        # @api private
        # @param issuer [String, nil] one issuer, or nil for all
        # @return [void]
        def reset_cache!(issuer = nil)
          @mutex.synchronize { issuer.nil? ? @cache.clear : @cache.delete(issuer) }
          nil
        end

        # @api private
        def cached(issuer)
          @mutex.synchronize do
            document, stored_at = @cache[issuer]
            document if document && Clock.now - stored_at < CACHE_SECONDS
          end
        end

        # @api private
        def cache(issuer, document)
          @mutex.synchronize { @cache[issuer] = [document, Clock.now] }
          document
        end

        # An endpoint of a validated metadata document.
        #
        # @param metadata [Hash]
        # @param name [String] for example "token_endpoint"
        # @param loopback [Boolean] whether http on a loopback host is
        #   accepted: pass {Config#loopback_resource?}
        # @param required [Boolean]
        # @return [String, nil] nil only when it is absent and not required
        # @raise [DiscoveryError] when it is missing but required, or not a URL the client may call
        def endpoint(metadata, name, loopback:, required: true)
          url = metadata[name]
          if url.nil?
            raise DiscoveryError, "The authorization server metadata has no #{name}" if required

            return nil
          end
          secure!(url, name, loopback: loopback)
        end

        # Checks a URL that a server supplied (in a challenge or a metadata
        # document) before the client calls it. Plain http is accepted only
        # on a loopback host, and only when the resource itself is on one:
        # a remote resource must not be able to make the client call a
        # service on the client's own machine.
        #
        # @param url [Object]
        # @param label [String] what the URL is, for the message
        # @param loopback [Boolean] whether http on a loopback host is
        #   accepted: pass {Config#loopback_resource?}
        # @return [String] the URL
        # @raise [DiscoveryError] when it is refused
        def secure!(url, label, loopback:)
          return url if Url.secure?(url, loopback: loopback)

          raise DiscoveryError,
                "The #{label} #{Url.display(url)} is refused: it must be https (http is allowed only for " \
                "localhost, 127.0.0.1 and [::1], and only when resource_url is on one of them)"
        end
      end

      # @param config [Config]
      def initialize(config)
        @config = config
        @resource = Url.parse(config.resource_url)
        @loopback = config.loopback_resource?
      end

      # Protected resource metadata and authorization server metadata in one step.
      #
      # @param resource_metadata_url [String, nil] the URL from a challenge, when there was one
      # @return [Hash] the validated authorization server metadata
      # @raise [DiscoveryError, UnavailableError]
      def discover(resource_metadata_url = nil)
        authorization_server_metadata(issuer_of(protected_resource_metadata(resource_metadata_url)))
      end

      # @param resource_metadata_url [String, nil] the URL from a challenge; without
      #   one the two well-known URLs are tried
      # @return [Hash] the validated document
      # @raise [DiscoveryError] when no usable document is found or it is for another resource
      # @raise [UnavailableError] on a network failure
      def protected_resource_metadata(resource_metadata_url = nil)
        document =
          if resource_metadata_url
            Http.get_json(self.class.secure!(resource_metadata_url, "resource_metadata URL", loopback: @loopback))
          else
            first_document(resource_metadata_candidates)
          end
        if document.nil?
          raise DiscoveryError, "No protected resource metadata was found for #{Url.display(@config.resource_url)}"
        end

        validate_resource!(document)
        document
      end

      # @param document [Hash] validated protected resource metadata
      # @return [String] the issuer: the first authorization server
      # @raise [DiscoveryError]
      def issuer_of(document)
        servers = document["authorization_servers"]
        unless servers.is_a?(Array) && !servers.empty? && servers.all? { |server| server.is_a?(String) && !server.empty? }
          raise DiscoveryError,
                "The protected resource metadata for #{Url.display(@config.resource_url)} names no authorization server"
        end

        self.class.secure!(servers.first, "authorization server", loopback: @loopback)
      end

      # @param issuer [String]
      # @return [Hash] the validated document, cached for {CACHE_SECONDS}
      # @raise [DiscoveryError] when no document is found or it fails validation
      # @raise [UnavailableError] on a network failure
      def authorization_server_metadata(issuer)
        # Before the cache: it is shared by every client in the process, and
        # one for a loopback resource may have stored a loopback issuer.
        self.class.secure!(issuer, "authorization server", loopback: @loopback)
        cached = self.class.cached(issuer)
        return cached if cached

        document = first_document(server_metadata_candidates(issuer))
        raise DiscoveryError, "No authorization server metadata was found for #{Url.display(issuer)}" if document.nil?

        validate_server!(document, issuer)
        self.class.cache(issuer, document)
      end

      private

      def first_document(urls)
        urls.each do |url|
          document = Http.get_json(self.class.secure!(url, "metadata URL", loopback: @loopback))
          return document if document
        end
        nil
      end

      def resource_metadata_candidates
        origin = Url.origin(@resource)
        path = @resource.path
        root = "#{origin}#{RESOURCE_WELL_KNOWN}"
        path.empty? || path == "/" ? [root] : ["#{root}#{path}", root]
      end

      # RFC 8414 path insertion first; "<issuer>/.well-known/..." only last.
      def server_metadata_candidates(issuer)
        uri = Url.parse(issuer)
        origin = Url.origin(uri)
        path = uri.path.delete_suffix("/")
        return ["#{origin}#{SERVER_WELL_KNOWN}", "#{origin}#{OPENID_WELL_KNOWN}"] if path.empty?

        ["#{origin}#{SERVER_WELL_KNOWN}#{path}", "#{origin}#{OPENID_WELL_KNOWN}#{path}", "#{origin}#{path}#{OPENID_WELL_KNOWN}"]
      end

      def validate_resource!(document)
        advertised = Url.parse(document["resource"])
        return if advertised && Url.same_origin?(advertised, @resource) && Url.path_covers?(advertised.path, @resource.path)

        raise DiscoveryError,
              "The protected resource metadata is for #{Url.display(document['resource'])}, which does not cover " \
              "#{Url.display(@config.resource_url)}"
      end

      def validate_server!(document, issuer)
        unless document["issuer"] == issuer
          raise DiscoveryError,
                "The authorization server metadata names issuer #{Url.display(document['issuer'])}, expected #{Url.display(issuer)}"
        end

        methods = document["code_challenge_methods_supported"]
        unless methods.is_a?(Array) && methods.include?("S256")
          raise DiscoveryError, "The authorization server #{Url.display(issuer)} does not advertise PKCE with S256"
        end

        self.class.endpoint(document, "authorization_endpoint", loopback: @loopback)
        self.class.endpoint(document, "token_endpoint", loopback: @loopback)
      end
    end
  end
end
