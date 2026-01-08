module KindeSdk
  class Client
    module Roles
      include KindeSdk::Logging
      # Get all roles for the authenticated user
      # Matches the JavaScript SDK API: getRoles(options?)
      # Implements smart fallback: uses API automatically if token claims are empty
      #
      # @param options [Hash] Options for retrieving roles
      # @option options [Boolean] :force_api (false) If true, calls the API to get fresh roles,
      #   otherwise extracts from token claims. Will auto-fallback to API if token claims are empty.
      # @option options [Symbol] :token_type (:access_token) The token type to use for soft check (:access_token or :id_token)
      # @return [Array] Array of role objects with id, name, and key
      # @example
      #   # Soft check (from token) with auto-fallback to API if empty
      #   client.get_roles
      #   # => [{ id: "role_123", name: "Admin", key: "admin" }]
      #
      #   # Hard check (from API - always fresh)
      #   client.get_roles(force_api: true)
      #   # => [{ id: "role_123", name: "Admin", key: "admin" }]
      def get_roles(options = {})
        # Handle legacy positional argument for backward compatibility
        if options.is_a?(Symbol)
          options = { token_type: options }
        end
        
        # Extract options with defaults - use member variable if not overridden
        force_api = options[:force_api] || @force_api || false
        token_type = options[:token_type] || :access_token

        # Smart fallback logic matching js-utils exactly
        # Check if we have role claims first (efficiency optimization)
        roles_claim = get_claim("roles", token_type)
        
        if force_api || !roles_claim&.dig(:value)&.any?
          # Use API if explicitly requested OR if token claims are empty
          log_info("Using API for roles: force_api=#{force_api}, empty_claims=#{!roles_claim&.dig(:value)&.any?}")
          return get_roles_from_api
        end

        # Use token claims (soft check)
        get_roles_from_token(token_type)
      end

      # Check if user has specific roles
      # Matches JavaScript SDK hasRoles functionality
      #
      # @param role_keys [Array<String>, String] Array of role keys to check, or single role key
      # @param options [Hash] Options for retrieving roles (same as get_roles)
      # @return [Boolean] True if user has all specified roles, false otherwise
      def has_roles?(role_keys, options = {})
        return true if role_keys.nil? || (role_keys.respond_to?(:empty?) && role_keys.empty?)
        
        begin
          user_roles = get_roles(options)
          role_keys_array = Array(role_keys)
          user_role_keys = user_roles.map { |role| role[:key] || role['key'] }.compact
          
          result = role_keys_array.all? { |role_key| user_role_keys.include?(role_key.to_s) }
          log_debug("Role check for #{role_keys_array}: #{result} (user has: #{user_role_keys})")
          result
        rescue StandardError => e
          log_error("Error checking roles: #{e.message}")
          false
        end
      end

      # PHP SDK compatible alias for get_roles with hard check
      # Matches PHP: $client->getRoles()
      #
      # @return [Array] Array of role objects
      def getRoles
        # Use client's force_api setting, default to true for PHP SDK compatibility
        force_api_setting = @force_api.nil? ? true : @force_api
        get_roles(force_api: force_api_setting)
      end

      # JavaScript SDK compatible alias
      alias_method :hasRoles, :has_roles?

      private

      # Get roles from token claims (soft check)
      # Matches JavaScript logic: token.roles || token["x-hasura-roles"] || []
      # Includes helpful warnings like js-utils
      #
      # @param token_type [Symbol] The token type to use
      # @return [Array] Array of role objects
      def get_roles_from_token(token_type = :access_token)
        # First try standard roles claim
        roles = get_claim("roles", token_type)&.dig(:value)
        
        # Fallback to Hasura-specific roles (matches JS SDK)
        if roles.nil? || roles.empty?
          roles = get_claim("x-hasura-roles", token_type)&.dig(:value)
        end
        
        # Warning message matching js-utils behavior
        if roles.nil? || roles.empty?
          log_warning("No roles found in token. Ensure roles have been included in the token customisation within the application settings.")
          return []
        end

        # Ensure consistent format - normalize all role data
        normalize_roles(roles)
      end

      # Get roles from API (hard check)
      # Matches JavaScript API endpoint and data extraction exactly
      #
      # @return [Array] Array of role objects
      def get_roles_from_api
        unless token_store.bearer_token
          log_warning("No bearer token available for API call")
          return []
        end

        begin
          # Use the same pagination pattern as getAllEntitlements
          all_roles = paginate_all_results('roles') do |starting_after|
            user_roles(page_size: 100, starting_after: starting_after)
          end

          # Extract and normalize role data (matches js-utils format exactly)
          normalized_roles = normalize_roles(all_roles)
          log_debug("Retrieved #{normalized_roles.count} roles from API")
          normalized_roles
        rescue KindeSdk::APIError => e
          log_error("API Error getting roles: #{e.message}")
          # Graceful fallback to token-based roles (matches JS behavior)
          log_info("Falling back to token-based roles due to API error")
          get_roles_from_token
        rescue StandardError => e
          log_error("Unexpected error getting roles from API: #{e.message}")
          # Graceful fallback to token-based roles
          log_info("Falling back to token-based roles due to unexpected error")
          get_roles_from_token
        end
      end

      # Normalize role data to consistent format
      # Ensures we always return { id:, name:, key: } format like js-utils
      #
      # @param roles [Array] Raw role data from token or API
      # @return [Array] Normalized role objects
      def normalize_roles(roles)
        return [] if roles.nil?

        Array(roles).map do |role|
          if role.is_a?(Hash) || role.respond_to?(:id)
            {
              id: extract_field(role, :id),
              name: extract_field(role, :name),
              key: extract_field(role, :key)
            }
          else
            # Handle string-only roles (fallback)
            role_str = role.to_s
            {
              id: nil,
              name: role_str,
              key: role_str
            }
          end
        end.compact
      end

      # Helper to extract field from hash or object
      # Checks Hash first to avoid issues with Hash#key requiring an argument
      #
      # @param item [Hash, Object] The item to extract from
      # @param field [Symbol] The field name to extract
      # @return [Object, nil] The field value or nil
      def extract_field(item, field)
        if item.is_a?(Hash)
          item.key?(field) ? item[field] : item[field.to_s]
        elsif item.respond_to?(field)
          item.public_send(field)
        else
          nil
        end
      end
    end
  end
end
