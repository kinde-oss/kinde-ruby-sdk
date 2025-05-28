require_relative '../../kinde_api/lib/kinde_api'
require_relative 'token_manager'
require_relative 'token_store'
require_relative 'current'

module KindeSdk
  class Client
    include FeatureFlags
    include Permissions

    attr_accessor :kinde_api_client, :auto_refresh_tokens, :token_store

    def initialize(sdk_api_client, tokens_hash, auto_refresh_tokens)
      @kinde_api_client = sdk_api_client
      @auto_refresh_tokens = auto_refresh_tokens
      @token_store = TokenManager.create_store(tokens_hash)

      # refresh the token if it's expired and auto_refresh_tokens is enabled
      refresh_token if auto_refresh_tokens && TokenManager.token_expired?(@token_store)
    end

    # Returns the bearer token for backwards compatibility
    # @return [String]
    def bearer_token
      @token_store.bearer_token
    end

    # Returns the tokens hash for backwards compatibility
    # @return [Hash]
    def tokens_hash
      @token_store.tokens
    end

    # Returns the token expiration time for backwards compatibility
    # @return [Integer]
    def expires_at
      @token_store.expires_at
    end

    def token_expired?
      TokenManager.token_expired?(@token_store)
    end

    def refresh_token
      new_tokens_hash = TokenManager.refresh_tokens(@token_store, Current.session)
      return nil unless new_tokens_hash

      @token_store.set_tokens(new_tokens_hash)
      @kinde_api_client = KindeSdk.api_client(@token_store.bearer_token)
      new_tokens_hash
    end

    # token_type is one of: :access_token, :id_token
    #
    # @return [Hash]
    # @example {name: "scp", value: ["openid", "offline"]}
    def get_claim(claim, token_type = :access_token)
      refresh_token if auto_refresh_tokens && token_expired?

      token = @token_store.tokens[token_type.to_sym]
      return unless token

      value = JWT.decode(token, nil, false)[0][claim]
      return unless value

      { name: claim, value: value }
    end

    # Generate a profile URL for the Kinde portal
    #
    # @param return_url [String] The URL to return to after portal interaction
    # @param sub_nav [String] The sub-navigation section to show
    # @return [Hash] A hash containing the generated URL
    # @raise [StandardError] If the request fails or returns invalid data
    def generate_profile_url(return_url:, sub_nav:)
      refresh_token if auto_refresh_tokens && token_expired?

      response = Faraday.get("#{@kinde_api_client.config.host}/account_api/v1/portal_link") do |req|
        req.params['return_url'] = return_url
        req.params['sub_nav'] = sub_nav
        req.headers['Authorization'] = "Bearer #{@token_store.bearer_token}"
      end

      unless response.success?
        raise StandardError, "Failed to fetch profile URL: #{response.status} #{response.reason_phrase}"
      end

      result = JSON.parse(response.body)
      unless result['url'].is_a?(String)
        raise StandardError, "Invalid URL received from API"
      end

      begin
        { url: URI.parse(result['url']) }
      rescue URI::InvalidURIError => e
        Rails.logger.error(e)
        raise StandardError, "Invalid URL format received from API: #{result['url']}"
      end
    end

    ::KindeApi.constants.filter { |klass| klass.to_s.end_with?("Api") }.each do |klass|
      api_klass = Kernel.const_get("KindeApi::#{klass}")

      define_method(klass.to_s.gsub(/([a-z\d])([A-Z])/) { "#{$1}_#{$2}" }.downcase.split("_api")[0]) do
        init_instance_api(api_klass)
      end
    end

    private

    def init_instance_api(api_klass)
      instance = api_klass.new(kinde_api_client)
      main_client = self
      methods_to_prepend = instance.public_methods(false).reject { |m| m.to_s.start_with?("api_client") }
      methods_to_prepend.each do |method_name|
        original = instance.method(method_name)
        instance.define_singleton_method(method_name) do |*args, &block|
          main_client.refresh_token if main_client.auto_refresh_tokens && main_client.token_expired?
          original.call(*args, &block)
        end
      end
      instance
    end
  end
end
