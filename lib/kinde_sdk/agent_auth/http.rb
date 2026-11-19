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
    # Each call has {TIMEOUT_SECONDS} in total, from the first byte sent to
    # the last byte read. The +timeout+ option of HTTParty alone does not give
    # that: it limits connecting, each write and each read separately, and
    # Net::HTTP repeats a GET once after a read timeout, so a slow answer
    # could take several times as long while a caller holds the cache lock.
    #
    # @api private
    module Http
      # Seconds one call may take in total. Also passed to HTTParty as the
      # limit of each phase.
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
          response = within_deadline do
            HTTParty.post(
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
          end
          [response.code, response.body.to_s]
        rescue *NETWORK_ERRORS
          raise UnavailableError, "Kinde could not be reached"
        end

        # GETs a JSON document from Kinde.
        #
        # @param url [String]
        # @return [Hash] the document, frozen at every level
        # @raise [UnavailableError] on a timeout, network error, non-200 status
        #   or a body that is not a JSON object
        def get_json(url)
          response = within_deadline do
            HTTParty.get(
              url,
              headers: { "Accept" => "application/json" },
              timeout: TIMEOUT_SECONDS,
              follow_redirects: false,
              format: :plain
            )
          end
          raise UnavailableError, "Kinde did not return the requested document" unless response.code == 200

          parse_json(response.body)
        rescue *NETWORK_ERRORS
          raise UnavailableError, "Kinde could not be reached"
        end

        # @param body [String]
        # @return [Hash] frozen at every level, so a document that is kept
        #   (the JWKS, the proxied metadata) cannot be changed by whoever reads it
        # @raise [UnavailableError] when the body is not a JSON object
        def parse_json(body)
          document = JSON.parse(body.to_s, freeze: true)
          raise UnavailableError, "Kinde returned an unexpected response" unless document.is_a?(Hash)

          document
        rescue JSON::ParserError
          raise UnavailableError, "Kinde returned an unexpected response"
        end

        private

        # Runs one request with {TIMEOUT_SECONDS} for all of it. Past that,
        # Timeout::Error is raised in this thread and the callers above turn
        # it into {UnavailableError}; the connection is not reused, so nothing
        # half-read is left behind.
        def within_deadline(&block)
          Timeout.timeout(TIMEOUT_SECONDS, &block)
        end

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
