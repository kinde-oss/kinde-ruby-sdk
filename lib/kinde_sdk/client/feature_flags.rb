module KindeSdk
  class Client
    module FeatureFlags
      def get_flag(name, opts = {}, flag_type = nil)
        res = get_claim("feature_flags")&.dig(:value, name)
        return try_default_flag(flag_type, name, opts) unless res

        type =
          case res["t"]
          when "b" then "boolean"
          when "s" then "string"
          when "i" then "integer"
          end

        {
          "code": name,
          "type": type,
          "value": res["v"],
          "is_default": false
        }
      end

      def get_boolean_flag(name, default_value = nil)
        flag_getter_wrapper(name, "b", default_value)
      end

      def get_string_flag(name, default_value = nil)
        flag_getter_wrapper(name, "s", default_value)
      end

      def get_integer_flag(name, default_value = nil)
        flag_getter_wrapper(name, "i", default_value)
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
    end
  end
end
