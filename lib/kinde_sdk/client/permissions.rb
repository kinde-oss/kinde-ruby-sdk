module KindeSdk
  class Client
    module Permissions
      include KindeSdk::Logging
      # Get all permissions for the authenticated user
      # Matches the JavaScript SDK API: getPermissions(options?)
      #
      # @param options [Hash, Symbol] Options for retrieving permissions, or legacy token_type symbol
      # @option options [Boolean] :force_api (false) If true, calls the API to get fresh permissions,
      #   otherwise extracts from token claims. Useful for ensuring latest permissions but may incur additional API calls
      # @option options [Symbol] :token_type (:access_token) The token type to use for soft check (:access_token or :id_token)
      # @return [Hash] Hash containing org_code and permissions array
      # @example
      #   # Soft check (from token)
      #   client.get_permissions
      #   # => { org_code: "org_123", permissions: ["read:users", "write:posts"] }
      #
      #   # Hard check (from API)
      #   client.get_permissions(force_api: true)
      #   # => { org_code: "org_123", permissions: ["read:users", "write:posts", "admin:all"] }
      #
      #   # Legacy backward compatibility
      #   client.get_permissions(:id_token)
      #   # => { org_code: "org_123", permissions: ["read:users", "write:posts"] }
      def get_permissions(options = {})
        # Handle legacy positional argument for backward compatibility
        if options.is_a?(Symbol)
          options = { token_type: options }
        end
        
        # Extract options with defaults - use member variable if not overridden
        force_api = options[:force_api] || @force_api || false
        token_type = options[:token_type] || :access_token

        if force_api
          # Hard check - call API for fresh permissions
          get_permissions_from_api
        else
          # Soft check - extract from token claims
          get_permissions_from_token(token_type)
        end
      end

      # Get a specific permission status
      #
      # @param permission [String] The permission key to check
      # @param options [Hash] Options for retrieving permissions (same as get_permissions)
      # @return [Hash] Hash containing org_code and is_granted status
      def get_permission(permission, options = {})
        permissions_data = get_permissions(options)
        
        {
          org_code: permissions_data[:org_code],
          is_granted: permissions_data[:permissions]&.include?(permission) || false
        }
      end

      # Check if a permission is granted
      #
      # @param permission [String] The permission key to check
      # @param options [Hash] Options for retrieving permissions
      # @return [Boolean] True if permission is granted, false otherwise
      def permission_granted?(permission, options = {})
        get_permission(permission, options)[:is_granted]
      end

      # PHP SDK compatible alias for get_permissions with hard check
      # Matches PHP: $client->getPermissions()
      #
      # @return [Hash] Hash containing org_code and permissions array
      def getPermissions
        # Use client's force_api setting, default to true for PHP SDK compatibility
        force_api_setting = @force_api.nil? ? true : @force_api
        get_permissions(force_api: force_api_setting)
      end

      # Get all permissions with automatic pagination (hard check)
      # Matches PHP: $client->getAllPermissions()
      #
      # @return [Array] Array of permission keys
      def getAllPermissions
        # Use client's force_api setting, default to true for PHP SDK compatibility
        force_api_setting = @force_api.nil? ? true : @force_api
        permissions_data = get_permissions(force_api: force_api_setting)
        permissions_data[:permissions] || []
      end

      # JavaScript SDK compatible alias
      alias_method :all_permissions, :getAllPermissions

      # Backward compatibility method - matches existing Ruby SDK API
      def get_permissions_legacy(token_type = :access_token)
        get_claim("permissions", token_type)&.dig(:value)
      end

      private

      # Get permissions from token claims (soft check)
      # Matches JavaScript logic exactly: token.permissions || token["x-hasura-permissions"] || []
      #
      # @param token_type [Symbol] The token type to use
      # @return [Hash] Hash containing org_code and permissions array
      def get_permissions_from_token(token_type = :access_token)
        # First try standard permissions claim
        permissions = get_claim("permissions", token_type)&.dig(:value)
        
        # Fallback to Hasura-specific permissions (matches JS SDK)
        if permissions.nil? || permissions.empty?
          permissions = get_claim("x-hasura-permissions", token_type)&.dig(:value)
        end
        
        # Final fallback to empty array
        permissions ||= []

        # Get org_code with same fallback pattern
        org_code = get_claim("org_code", token_type)&.dig(:value)
        if org_code.nil?
          org_code = get_claim("x-hasura-org-code", token_type)&.dig(:value)
        end

        # Log warning if no permissions found (helpful for debugging)
        if permissions.empty?
          log_warning("No permissions found in token. This may be expected if user has no permissions assigned.")
        end

        {
          org_code: org_code,
          permissions: permissions
        }
      end

      # Get permissions from API (hard check)
      # Matches JavaScript API endpoint and data extraction exactly
      #
      # @return [Hash] Hash containing org_code and permissions array
      def get_permissions_from_api
        unless token_store.bearer_token
          return {
            org_code: nil,
            permissions: []
          }
        end

        begin
          # Use the same pagination pattern as getAllEntitlements
          all_permissions = paginate_all_results('permissions') do |starting_after|
            user_permissions(page_size: 100, starting_after: starting_after)
          end

          # Extract permission keys (matches JS: data.permissions?.map((permission) => permission.key))
          permission_keys = all_permissions.map do |permission|
            # Handle both OpenStruct and Hash responses
            permission.respond_to?(:key) ? permission.key : permission['key']
          end.compact

          # Extract org_code from API response or fallback to token
          org_code = nil
          if all_permissions.any?
            first_permission = all_permissions.first
            org_code = first_permission.respond_to?(:org_code) ? 
                      first_permission.org_code : 
                      first_permission['org_code']
          end
          
          # Fallback to token if API doesn't provide org_code
          org_code ||= get_claim("org_code", :access_token)&.dig(:value)

          {
            org_code: org_code,
            permissions: permission_keys
          }
        rescue KindeSdk::APIError => e
          log_error("API Error getting permissions: #{e.message}")
          # Graceful fallback to token-based permissions (matches JS behavior)
          get_permissions_from_token
        rescue StandardError => e
          log_error("Unexpected error getting permissions from API: #{e.message}")
          # Graceful fallback to token-based permissions
          get_permissions_from_token
        end
      end
    end
  end
end
