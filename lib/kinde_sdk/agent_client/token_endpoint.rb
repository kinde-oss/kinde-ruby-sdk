# frozen_string_literal: true

require "base64"
require "uri"

module KindeSdk
  class AgentClient
    # The three form POSTs to the authorization server: code exchange, refresh
    # and revocation. All three authenticate the client the same way.
    #
    # @api private
    class TokenEndpoint
      # @param config [Config]
      def initialize(config)
        @config = config
      end

      # The lifetime a token response gives its access token.
      #
      # @param document [Hash] a token response
      # @return [Integer, nil] whole seconds, or nil when the response gives none
      def self.lifetime(document)
        expires_in = document["expires_in"]
        expires_in = Integer(expires_in, 10) if expires_in.is_a?(String) && expires_in.match?(/\A\d+\z/)
        expires_in.is_a?(Numeric) ? expires_in.to_i : nil
      end

      # @param url [String] the token endpoint
      # @param identity [Hash] the client identity (see {Registration})
      # @param code [String]
      # @param code_verifier [String]
      # @param redirect_uri [String] the one sent in the authorization request
      # @return [Hash] the token response
      # @raise [OAuthError, DiscoveryError, UnavailableError]
      def exchange(url, identity, code:, code_verifier:, redirect_uri:)
        token_request(url, identity,
                      "grant_type" => "authorization_code", "code" => code, "redirect_uri" => redirect_uri,
                      "code_verifier" => code_verifier, "resource" => @config.resource_url)
      end

      # @param url [String] the token endpoint
      # @param identity [Hash]
      # @param refresh_token [String]
      # @return [Hash] the token response
      # @raise [OAuthError, DiscoveryError, UnavailableError]
      def refresh(url, identity, refresh_token)
        token_request(url, identity,
                      "grant_type" => "refresh_token", "refresh_token" => refresh_token,
                      "resource" => @config.resource_url)
      end

      # @param url [String] the revocation endpoint
      # @param identity [Hash]
      # @param token [String] the refresh token, or the access token when there is none
      # @return [Integer] the status code; the caller only logs it
      # @raise [DiscoveryError, UnavailableError]
      def revoke(url, identity, token)
        post(url, identity, "token" => token, "token_type_hint" => "refresh_token").status
      end

      private

      def token_request(url, identity, form)
        result = post(url, identity, form)
        document = Http.parse_object(result.body) || {}
        token = document["access_token"]
        if result.status == 200 && token.is_a?(String) && !token.empty?
          # RFC 6749 section 7.1: a token of a type the client does not understand must not be used.
          unless bearer?(document)
            raise OAuthError.new("The authorization server issued a token of a type this client cannot use; " \
                                 "only Bearer tokens are supported", status: result.status)
          end
          # A token that has no lifetime left is not stored: it would be
          # reported as a good one, and a refresh would be sent for each call.
          if (lifetime = self.class.lifetime(document)) && !lifetime.positive?
            raise OAuthError.new("The authorization server issued an access token that has already expired " \
                                 "(expires_in is #{lifetime})", status: result.status)
          end

          return document
        end

        error = string(document["error"])
        description = string(document["error_description"])
        raise OAuthError.new(["The token request failed with status #{result.status}", error, description].compact.join(": "),
                             error: error, error_description: description, status: result.status)
      end

      def post(url, identity, form)
        Discovery.secure!(url, "authorization server endpoint", loopback: @config.loopback_resource?)
        headers = { "Content-Type" => "application/x-www-form-urlencoded", "Accept" => "application/json" }
        Http.request(:post, url, headers: headers, body: URI.encode_www_form(authenticate(identity, form, headers)))
      end

      # One client authentication method per request (RFC 6749 section 2.3).
      def authenticate(identity, form, headers)
        id = identity["client_id"]
        secret = identity["client_secret"]
        case secret && identity["token_endpoint_auth_method"]
        when "client_secret_post"
          form.merge("client_id" => id, "client_secret" => secret)
        when "client_secret_basic"
          # Both parts are form-urlencoded before base64 (RFC 6749 section 2.3.1).
          pair = "#{URI.encode_www_form_component(id)}:#{URI.encode_www_form_component(secret)}"
          headers["Authorization"] = "Basic #{Base64.strict_encode64(pair)}"
          form
        else
          form.merge("client_id" => id)
        end
      end

      # +token_type+ is required, but a response without it is still taken
      # for Bearer, as servers that leave it out mean it.
      def bearer?(document)
        type = document["token_type"]
        type.nil? || (type.is_a?(String) && type.casecmp?("bearer"))
      end

      def string(value)
        value.is_a?(String) && !value.empty? ? value : nil
      end
    end
  end
end
