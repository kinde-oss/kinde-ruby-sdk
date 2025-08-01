module KindeSdk
  class Client
    module Permissions
      # Get all permissions for the authenticated user
      #
      # @param options [Hash] Options for retrieving permissions
      # @option options [Boolean] :force_api (false) If true, calls the API to get fresh permissions,
      #   otherwise extracts from token claims. Useful for ensuring latest permissions but may incur additional API calls
      # @param token_type [Symbol] The token type to use for soft check (:access_token or :id_token)
      # @return [Hash] Hash containing org_code and permissions array
      def get_permissions(options = {}, token_type = :access_token)
        if options[:force_api]
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
      # @param options [Hash] Options for retrieving permissions
      # @option options [Boolean] :force_api (false) If true, calls the API to get fresh permissions
      # @param token_type [Symbol] The token type to use for soft check
      # @return [Hash] Hash containing org_code and is_granted status
      def get_permission(permission, options = {}, token_type = :access_token)
        permissions_data = get_permissions(options, token_type)
        
        {
          org_code: permissions_data[:org_code],
          is_granted: permissions_data[:permissions]&.include?(permission) || false
        }
      end

      # Check if a permission is granted
      #
      # @param permission [String] The permission key to check
      # @param options [Hash] Options for retrieving permissions
      # @option options [Boolean] :force_api (false) If true, calls the API to get fresh permissions
      # @param token_type [Symbol] The token type to use for soft check
      # @return [Boolean] True if permission is granted, false otherwise
      def permission_granted?(permission, options = {}, token_type = :access_token)
        get_permission(permission, options, token_type)[:is_granted]
      end

      # PHP SDK compatible alias for get_permissions with hard check
      #
      # @return [Hash] Hash containing org_code and permissions array
      def getPermissions
        get_permissions(force_api: true)
      end

      # Get all permissions with automatic pagination (hard check)
      #
      # @return [Array] Array of permission keys
      def getAllPermissions
        permissions_data = get_permissions(force_api: true)
        permissions_data[:permissions] || []
      end

      # JavaScript SDK compatible alias
      alias_method :all_permissions, :getAllPermissions

      private

      # Get permissions from token claims (soft check)
      #
      # @param token_type [Symbol] The token type to use
      # @return [Hash] Hash containing org_code and permissions array
      def get_permissions_from_token(token_type = :access_token)
        permissions = get_claim("permissions", token_type)&.dig(:value) || []
        org_code = get_claim("org_code", token_type)&.dig(:value)

        {
          org_code: org_code,
          permissions: permissions
        }
      end

      # Get permissions from API (hard check)
      #
      # @return [Hash] Hash containing org_code and permissions array
      def get_permissions_from_api
        unless token_store.bearer_token
          return {
            org_code: nil,
            permissions: []
          }
        end

        # Use the existing pagination infrastructure like getAllEntitlements
        all_permissions = paginate_all_results('permissions') do |starting_after|
          user_permissions(page_size: 100, starting_after: starting_after)
        end

        # Extract permission keys and org_code from the response
        permission_keys = all_permissions.map(&:key)
        org_code = all_permissions.first&.respond_to?(:org_code) ? 
                   all_permissions.first.org_code : 
                   get_claim("org_code", :access_token)&.dig(:value)

        {
          org_code: org_code,
          permissions: permission_keys
        }
      rescue StandardError => e
        Rails.logger.error("Failed to get permissions from API: #{e.message}")
        # Fallback to token-based permissions on API failure
        get_permissions_from_token
      end
    end
  end
end
