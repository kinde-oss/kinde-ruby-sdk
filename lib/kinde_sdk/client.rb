require "kinde_api"

module KindeSdk
  class Client
    include FeatureFlags
    include Permissions

    attr_accessor :kinde_api_client, :bearer_token, :tokens_hash, :expires_at

    def initialize(sdk_api_client, tokens_hash)
      @kinde_api_client = sdk_api_client
      set_hash_related_data(tokens_hash)
    end

    def token_expired?
      expires_at.to_i > 0 && (expires_at <= Time.now.to_i)
    end

    def refresh_token
      new_tokens_hash = KindeSdk.refresh_token(tokens_hash)
      set_hash_related_data(new_tokens_hash)
      @kinde_api_client = KindeSdk.api_client(tokens_hash["access_token"])
      new_tokens_hash
    end

    # token_type is one of: :access_token, :id_token
    #
    # @return [Hash]
    # @example {name: "scp", value: ["openid", "offline"]}
    def get_claim(claim, token_type = :access_token)
      token = tokens_hash[token_type]
      return unless token

      value = JWT.decode(token, nil, false)[0][claim]
      return unless value

      { name: claim, value: value }
    end

    ::KindeApi.constants.filter { |klass| klass.to_s.end_with?("Api") }.each do |klass|
      api_klass = Kernel.const_get("KindeApi::#{klass}")

      define_method(klass.to_s.gsub(/([a-z\d])([A-Z])/) { "#{$1}_#{$2}" }.downcase.split("_api")[0]) do
        init_instance_api(api_klass)
      end
    end

    private

    def set_hash_related_data(tokens_hash)
      @tokens_hash = tokens_hash.transform_keys(&:to_sym)
      @bearer_token = tokens_hash[:access_token]
      @expires_at = tokens_hash[:expires_at]
    end

    def init_instance_api(api_klass)
      api_klass.new(kinde_api_client)
    end
  end
end
