# frozen_string_literal: true

require "json"
require "httparty"
require "kinde_sdk/agent_auth/http"

module KindeSdk
  class AgentClient
    # Every HTTP call of the agent client. Redirects are never followed, TLS
    # verification is never turned off, and nothing is logged here.
    #
    # @api private
    module Http
      # Timeout for calls to an authorization server or a metadata document.
      TIMEOUT_SECONDS = 5
      METHODS = %i[get post put patch delete head options].freeze

      # What came back: +headers+ maps lower-case names to the list of values.
      Result = Struct.new(:status, :headers, :body, keyword_init: true)

      class << self
        # @param method [Symbol] one of {METHODS}
        # @param url [String]
        # @param headers [Hash{String=>String}]
        # @param body [String, nil]
        # @param timeout [Numeric] seconds
        # @return [Result]
        # @raise [UnavailableError] on a timeout or network error
        def request(method, url, headers: {}, body: nil, timeout: TIMEOUT_SECONDS)
          options = { headers: headers, timeout: timeout, follow_redirects: false, format: :plain }
          options[:body] = body unless body.nil?
          response = HTTParty.public_send(method, url, **options)
          Result.new(status: response.code, headers: header_lists(response), body: response.body.to_s)
        rescue *KindeSdk::AgentAuth::Http::NETWORK_ERRORS
          raise UnavailableError, "#{Url.display(url)} could not be reached"
        end

        # GETs a JSON document.
        #
        # @param url [String]
        # @return [Hash, nil] nil for a non-200 answer or a body that is not a JSON object
        # @raise [UnavailableError] on a timeout or network error
        def get_json(url)
          result = request(:get, url, headers: { "Accept" => "application/json" })
          result.status == 200 ? parse_object(result.body) : nil
        end

        # @param body [String]
        # @return [Hash, nil] the JSON object, or nil when the body is anything else
        def parse_object(body)
          document = JSON.parse(body.to_s)
          document.is_a?(Hash) ? document : nil
        rescue JSON::ParserError
          nil
        end

        private

        def header_lists(response)
          (response.headers.to_hash || {}).each_with_object({}) do |(name, values), lists|
            lists[name.to_s.downcase] = Array(values).map(&:to_s)
          end
        end
      end
    end

    # The wall clock in whole seconds, in one place so specs can move it.
    #
    # @api private
    module Clock
      # @return [Integer] seconds since the epoch
      def self.now
        Time.now.to_i
      end
    end
  end
end
