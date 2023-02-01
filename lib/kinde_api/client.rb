require "kinde_sdk"

module KindeApi
  class Client
    attr_accessor :sdk_api_client
    attr_accessor :bearer_token

    def initialize(sdk_api_client, bearer_token)
      @sdk_api_client = sdk_api_client
      @bearer_token = bearer_token
    end

    def logout
      KindeApi.logout(bearer_token, sdk_api_client)
    end

    ::KindeSdk.constants.filter { |klass| klass.end_with?("Api") }.each do |klass|
      api_klass = Kernel.const_get("KindeSdk::#{klass}")

      define_method(klass.to_s.downcase.split("api")[0]) { init_instance_api(api_klass) }
    end

    private

    def init_instance_api(api_klass)
      api_klass.new(sdk_api_client)
    end
  end
end
