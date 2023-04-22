require "kinde_api"

module KindeSdk
  class Client
    attr_accessor :kinde_api_client
    attr_accessor :bearer_token
    attr_accessor :tokens_hash

    def initialize(sdk_api_client, tokens_hash)
      @kinde_api_client = sdk_api_client
      @tokens_hash = tokens_hash.transform_keys(&:to_sym)
      @bearer_token = tokens_hash[:access_token]
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

    def get_permissions(token_type = :access_token)
      get_claim("permissions", token_type)&.dig(:value)
    end

    def get_permission(permission, token_type = :access_token)
      {
        org_code: get_claim("org_code", token_type)&.dig(:value),
        is_granted: permission_granted?(permission)
      }
    end

    def permission_granted?(permission, token_type = :access_token)
      get_claim("permissions", token_type)&.dig(:value)&.include?(permission) || false
    end

    ::KindeApi.constants.filter { |klass| klass.to_s.end_with?("Api") }.each do |klass|
      api_klass = Kernel.const_get("KindeApi::#{klass}")

      define_method(klass.to_s.downcase.split("api")[0]) { init_instance_api(api_klass) }
    end

    private

    def flag_getter_wrapper(name, type, default_value = nil)
      v = get_flag(name, { default_value: default_value }, type)[:value]
      raise ArgumentError, "Flag #{name} value type is different from requested type" unless check_type(v, type)

      v
    end

    def try_default_flag(flag_type, name, opts)
      default_value = opts[:default_value]
      raise StandardError, "This flag was not found, and no default value has been provided" if default_value == nil

      if flag_type && !check_type(default_value, flag_type)
        raise ArgumentError, "Flag #{name} value type is different from requested type"
      end

      {
        "code": name,
        "value": default_value,
        "is_default": true
      }
    end

    def check_type(value, type)
      type == "s" && value.is_a?(String) || type == "b" && (value == false || value == true) || type == "i" && value.is_a?(Integer)
    end

    def init_instance_api(api_klass)
      api_klass.new(kinde_api_client)
    end
  end
end
