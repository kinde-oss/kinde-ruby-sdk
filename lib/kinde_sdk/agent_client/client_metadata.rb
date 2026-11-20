# frozen_string_literal: true

require "json"

module KindeSdk
  class AgentClient
    # Builds and checks a client ID metadata document.
    #
    # @api private
    module ClientMetadata
      GRANT_TYPES = %w[authorization_code refresh_token].freeze
      RESPONSE_TYPES = ["code"].freeze
      AUTH_METHOD = "none"

      class << self
        # @param url [Object] a candidate +client_id+ / +client_metadata_url+
        # @return [String, nil] what is wrong with it, or nil when it is usable
        def client_id_problem(url)
          uri = Url.parse(url)
          return "must be an https URL" unless uri && uri.scheme.downcase == "https"
          return "must have a path other than /" if uri.path.empty? || uri.path == "/"
          return "must not contain userinfo" if uri.userinfo
          return "must not contain a query" if uri.query
          return "must not contain a fragment" if uri.fragment

          nil
        end

        # @return [Hash{String=>Object}] the document
        # @raise [ArgumentError] naming the offending value
        def build(client_id:, client_name:, redirect_uris:, client_uri: nil, logo_uri: nil)
          problem = client_id_problem(client_id)
          raise ArgumentError, "client_id #{client_id.inspect} #{problem}" if problem
          raise ArgumentError, "client_name must not be empty" unless client_name.is_a?(String) && !client_name.strip.empty?
          raise ArgumentError, "redirect_uris must not be empty" unless redirect_uris.is_a?(Array) && !redirect_uris.empty?

          host = Url.parse(client_id).host.downcase
          redirect_uris.each { |redirect_uri| check_redirect_uri(redirect_uri, host) }

          document = { "client_id" => client_id, "client_name" => client_name }
          document["client_uri"] = client_uri unless client_uri.nil?
          document["logo_uri"] = logo_uri unless logo_uri.nil?
          document.merge(
            "redirect_uris" => redirect_uris.dup,
            "grant_types" => GRANT_TYPES.dup,
            "response_types" => RESPONSE_TYPES.dup,
            "token_endpoint_auth_method" => AUTH_METHOD
          )
        end

        private

        def check_redirect_uri(redirect_uri, client_id_host)
          uri = Url.parse(redirect_uri)
          raise ArgumentError, "redirect URI #{redirect_uri.inspect} is not an absolute URL" if uri.nil?
          raise ArgumentError, "redirect URI #{redirect_uri.inspect} must not contain a fragment" if uri.fragment
          raise ArgumentError, "redirect URI #{redirect_uri.inspect} must not contain userinfo" if uri.userinfo

          scheme = uri.scheme.downcase
          host = uri.host.downcase
          return if scheme == "https" && host == client_id_host
          return if scheme == "http" && Url::LOOPBACK_HOSTS.include?(host)

          raise ArgumentError,
                "redirect URI #{redirect_uri.inspect} must be https on the host of client_id (#{client_id_host}) or " \
                "http on localhost, 127.0.0.1 or [::1]; Kinde drops any other redirect URI, including other hosts " \
                "and custom schemes"
        end
      end
    end

    # Rack app that serves a client ID metadata document. Build it with
    # {KindeSdk::AgentClient.client_metadata_app} and mount it at the exact
    # path of the document's +client_id+; the app does not check the request
    # URL itself.
    #
    # +GET+ and +HEAD+ answer 200 with the document; other methods answer 405.
    # It never redirects.
    #
    # @example config.ru
    #   map "/oauth/client-metadata.json" do
    #     run KindeSdk::AgentClient.client_metadata_app(
    #       client_id: "https://agent.example.com/oauth/client-metadata.json",
    #       client_name: "Example Agent",
    #       redirect_uris: ["https://agent.example.com/oauth/callback"]
    #     )
    #   end
    class ClientMetadataApp
      # Kinde reads at most 64 KiB of the document.
      MAX_BYTES = 65_536
      HEADERS = { "content-type" => "application/json", "cache-control" => "public, max-age=3600" }.freeze
      private_constant :HEADERS

      # @param document [Hash] a document from {KindeSdk::AgentClient.build_client_metadata_document}
      # @raise [ArgumentError] when the JSON document is 64 KiB or larger
      # @example
      #   KindeSdk::AgentClient::ClientMetadataApp.new(document)
      def initialize(document)
        @body = JSON.generate(document).freeze
        return if @body.bytesize < MAX_BYTES

        raise ArgumentError, "the client ID metadata document is #{@body.bytesize} bytes; it must be under #{MAX_BYTES}"
      end

      # @param env [Hash] the Rack environment
      # @return [Array(Integer, Hash{String=>String}, Array<String>)] the Rack response
      # @example
      #   status, headers, body = app.call("REQUEST_METHOD" => "GET")
      def call(env)
        case env["REQUEST_METHOD"]
        when "GET" then [200, response_headers, [@body]]
        when "HEAD" then [200, response_headers, []]
        else [405, { "allow" => "GET, HEAD", "content-type" => "text/plain" }, ["Method Not Allowed"]]
        end
      end

      private

      def response_headers
        HEADERS.merge("content-length" => @body.bytesize.to_s)
      end
    end
  end
end
