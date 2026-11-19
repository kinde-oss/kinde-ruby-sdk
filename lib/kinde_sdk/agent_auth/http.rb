# frozen_string_literal: true

require "base64"
require "json"
require "net/http"
require "openssl"
require "socket"
require "timeout"
require "uri"
require "zlib"
require "httparty"

module KindeSdk
  class AgentAuth
    # The two HTTP calls the resource-server helpers make to Kinde. Every
    # network failure becomes {UnavailableError}; nothing is logged here, so no
    # token, secret or Basic header can reach a log.
    #
    # @api private
    module Http
      TIMEOUT_SECONDS = 5
      # Includes a malformed HTTP answer (the three Net classes) and a corrupt
      # compressed body (Zlib::Error), from Kinde or from a proxy in between.
      NETWORK_ERRORS = [
        Timeout::Error, SocketError, SystemCallError, IOError,
        OpenSSL::SSL::SSLError, HTTParty::Error,
        Net::ProtocolError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Zlib::Error
      ].freeze

      class << self
        # POSTs a form to Kinde with the application's Basic credentials.
        #
        # @param url [String]
        # @param params [Hash] form fields
        # @param config [Config]
        # @return [Array(Integer, String)] status code and raw body
        # @raise [UnavailableError] on a timeout or network error
        def post_form(url, params, config)
          response = HTTParty.post(
            url,
            headers: {
              "Authorization" => basic_authorization(config),
              "Content-Type" => "application/x-www-form-urlencoded",
              "Accept" => "application/json"
            },
            body: URI.encode_www_form(params),
            timeout: TIMEOUT_SECONDS,
            follow_redirects: false,
            format: :plain
          )
          [response.code, response.body.to_s]
        rescue *NETWORK_ERRORS
          raise UnavailableError, "Kinde could not be reached"
        end

        # GETs a JSON document from Kinde.
        #
        # @param url [String]
        # @return [Hash]
        # @raise [UnavailableError] on a timeout, network error, non-200 status
        #   or a body that is not a JSON object
        def get_json(url)
          response = HTTParty.get(
            url,
            headers: { "Accept" => "application/json" },
            timeout: TIMEOUT_SECONDS,
            follow_redirects: false,
            format: :plain
          )
          raise UnavailableError, "Kinde did not return the requested document" unless response.code == 200

          parse_json(response.body)
        rescue *NETWORK_ERRORS
          raise UnavailableError, "Kinde could not be reached"
        end

        # @param body [String]
        # @return [Hash]
        # @raise [UnavailableError] when the body is not a JSON object
        def parse_json(body)
          document = JSON.parse(body.to_s)
          raise UnavailableError, "Kinde returned an unexpected response" unless document.is_a?(Hash)

          document
        rescue JSON::ParserError
          raise UnavailableError, "Kinde returned an unexpected response"
        end

        private

        # RFC 6749 section 2.3.1: both parts are form-urlencoded before base64.
        def basic_authorization(config)
          id = URI.encode_www_form_component(config.client_id)
          secret = URI.encode_www_form_component(config.client_secret)
          "Basic #{Base64.strict_encode64("#{id}:#{secret}")}"
        end
      end
    end
  end
end
