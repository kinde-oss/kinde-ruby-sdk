module KindeSdk
  class Client
    module FeatureFlags
      # Get all feature flags for the authenticated user
      # Matches the JavaScript SDK API: getFlags(options?)
      #
      # @param options [Hash] Options for retrieving feature flags
      # @option options [Boolean] :force_api (false) If true, calls the API to get fresh flags,
      #   otherwise extracts from token claims. Useful for ensuring latest flags but may incur additional API calls
      # @option options [Symbol] :token_type (:access_token) The token type to use for soft check (:access_token or :id_token)
      # @return [Array] Array of flag objects with key, value, and type
      # @example
      #   # Soft check (from token)
      #   client.get_flags
      #   # => [{ key: "feature_a", value: true, type: "boolean" }]
      #
      #   # Hard check (from API)
      #   client.get_flags(force_api: true)
      #   # => [{ key: "feature_a", value: true, type: "boolean" }]
      def get_flags(options = {})
        # Handle legacy positional argument for backward compatibility
        if options.is_a?(Symbol)
          options = { token_type: options }
        end
        
        # Extract options with defaults - use member variable if not overridden
        force_api = options[:force_api] || @force_api || false
        token_type = options[:token_type] || :access_token

        if force_api
          # Hard check - call API for fresh flags
          get_flags_from_api
        else
          # Soft check - extract from token claims
          get_flags_from_token(token_type)
        end
      end

      # Get a specific feature flag
      # Supports both new API-style calls and legacy 3-parameter calls
      #
      # @param name [String] The flag name/key to retrieve
      # @param options_or_opts [Hash] Options for retrieving flags OR legacy opts hash
      # @param flag_type [String, nil] Legacy flag type parameter (for 3-param calls)
      # @return [Hash, nil] Flag object or nil if not found
      def get_flag(name, options_or_opts = {}, flag_type = nil)
        # Handle legacy 3-parameter signature: get_flag(name, opts, flag_type)
        if flag_type || (options_or_opts.is_a?(Hash) && options_or_opts.key?(:default_value) && !options_or_opts.key?(:force_api))
          return get_flag_legacy(name, options_or_opts, flag_type)
        end

        get_flag_new_api(name, options_or_opts)
      end

      # Check if user has specific feature flags
      #
      # @param flag_conditions [Array] Array of flag keys or flag condition objects
      # @param options [Hash] Options for retrieving flags (same as get_flags)
      # @return [Boolean] True if user has all specified flags, false otherwise
      def has_feature_flags?(flag_conditions, options = {})
        return true if flag_conditions.nil? || flag_conditions.empty?
        
        flags = get_flags(options)
        flag_conditions_array = Array(flag_conditions)
        
        flag_conditions_array.all? { |condition| check_flag_condition(condition, flags) }
      end

      # Legacy methods for backward compatibility
      def get_boolean_flag(name, default_value = nil)
        flag_getter_wrapper(name, "b", default_value)
      end

      def get_string_flag(name, default_value = nil)
        flag_getter_wrapper(name, "s", default_value)
      end

      def get_integer_flag(name, default_value = nil)
        flag_getter_wrapper(name, "i", default_value)
      end

      # PHP SDK compatible alias
      def getFlags
        get_flags(force_api: @force_api || true)
      end

      # JavaScript SDK compatible alias
      alias_method :hasFeatureFlags, :has_feature_flags?

      private

      # New API-style get_flag implementation
      # Handles the modern get_flag(name, options) signature
      #
      # @param name [String] The flag name/key to retrieve
      # @param options [Hash] Options for retrieving flags
      # @return [Hash, nil] Flag object or nil if not found
      def get_flag_new_api(name, options)
        flags = get_flags(options)
        flag = find_flag_by_key(flags, name)
        
        return nil unless flag
        
        {
          code: get_flag_key(flag),
          type: get_flag_type(flag),
          value: get_flag_value(flag),
          is_default: false
        }
      end

      # Check a single flag condition against available flags
      #
      # @param condition [Hash, String] Flag condition to check
      # @param flags [Array] Available flags to check against
      # @return [Boolean] True if condition is met, false otherwise
      def check_flag_condition(condition, flags)
        if condition.is_a?(Hash) && condition.key?(:flag) && condition.key?(:value)
          # Custom condition with specific value
          flag = find_flag_by_key(flags, condition[:flag])
          flag && get_flag_value(flag) == condition[:value]
        else
          # Simple existence check
          !!find_flag_by_key(flags, condition.to_s)
        end
      end

      # Find a flag by its key in the flags array
      #
      # @param flags [Array] Array of flag objects
      # @param key [String] The key to search for
      # @return [Hash, nil] Flag object if found, nil otherwise
      def find_flag_by_key(flags, key)
        flags.find { |f| get_flag_key(f) == key.to_s }
      end

      # Extract the key from a flag object (handles both symbol and string keys)
      #
      # @param flag [Hash] Flag object
      # @return [String] The flag key
      def get_flag_key(flag)
        flag[:key] || flag['key']
      end

      # Extract the value from a flag object (handles both symbol and string keys)
      #
      # @param flag [Hash] Flag object
      # @return [Object] The flag value
      def get_flag_value(flag)
        flag[:value] || flag['value']
      end

      # Extract the type from a flag object (handles both symbol and string keys)
      #
      # @param flag [Hash] Flag object
      # @return [String] The flag type
      def get_flag_type(flag)
        flag[:type] || flag['type']
      end

      # Legacy get_flag implementation for backward compatibility
      # Handles the 3-parameter signature: get_flag(name, opts, flag_type)
      def get_flag_legacy(name, opts = {}, flag_type = nil)
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

      # Get feature flags from token claims (soft check)
      # Matches JavaScript logic: token.feature_flags || token["x-hasura-feature-flags"] || null
      #
      # @param token_type [Symbol] The token type to use
      # @return [Array] Array of flag objects
      def get_flags_from_token(token_type = :access_token)
        # First try standard feature_flags claim
        flags = get_claim("feature_flags", token_type)&.dig(:value)
        
        # Fallback to Hasura-specific flags (matches JS SDK)
        if flags.nil? || flags.empty?
          flags = get_claim("x-hasura-feature-flags", token_type)&.dig(:value)
        end
        
        return [] if flags.nil? || flags.empty?

        # Convert from token format to consistent array format
        if flags.is_a?(Hash)
          flags.map do |key, value|
            {
              key: key.to_s,
              value: value.is_a?(Hash) ? value['v'] : value,
              type: value.is_a?(Hash) ? map_flag_type(value['t']) : 'string'
            }
          end
        else
          []
        end
      end

      # Get feature flags from API (hard check)
      # Matches JavaScript API endpoint and data extraction exactly
      #
      # @return [Array] Array of flag objects
      def get_flags_from_api
        unless token_store.bearer_token
          return []
        end

        begin
          # Use the same pagination pattern as getAllEntitlements
          all_flags = paginate_all_results('feature_flags') do |starting_after|
            user_feature_flags(page_size: 100, starting_after: starting_after)
          end

          # Extract flag data (matches JS: feature_flags?.map((flag) => ({ key, value, type })))
          all_flags.map do |flag|
            {
              key: flag.respond_to?(:key) ? flag.key : flag['key'],
              value: flag.respond_to?(:value) ? flag.value : flag['value'],
              type: flag.respond_to?(:type) ? flag.type : flag['type']
            }
          end.compact
        rescue KindeSdk::APIError => e
          log_error("API Error getting feature flags: #{e.message}")
          # Graceful fallback to token-based flags (matches JS behavior)
          get_flags_from_token
        rescue StandardError => e
          log_error("Unexpected error getting feature flags from API: #{e.message}")
          # Graceful fallback to token-based flags
          get_flags_from_token
        end
      end

      # Map token flag type codes to full names
      def map_flag_type(type_code)
        case type_code
        when "b" then "boolean"
        when "s" then "string"
        when "i" then "integer"
        when "o" then "object"
        else "string"
        end
      end

      # Legacy helper methods
      def flag_getter_wrapper(name, type, default_value = nil)
        v = get_flag_legacy(name, { default_value: default_value }, type)[:value]
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

      # Configurable logging that works with or without Rails
      def log_error(message)
        if defined?(Rails) && Rails.logger
          Rails.logger.error(message)
        elsif @logger
          @logger.error(message)
        elsif respond_to?(:logger) && logger
          logger.error(message)
        else
          $stderr.puts "[KindeSdk] ERROR: #{message}"
        end
      end
    end
  end
end
