module KindeSdk
  class Client
    module Permissions
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
    end
  end
end
