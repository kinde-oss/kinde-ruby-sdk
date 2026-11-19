# frozen_string_literal: true

module KindeSdk
  class AgentAuth
    # What a verified access token says about the caller. Returned by
    # {KindeSdk::AgentAuth#verify_access_token} and placed in the Rack env by
    # {KindeSdk::AgentAuth::Middleware}. Frozen.
    #
    # Identity comes from the token's claims, never from the user profile
    # endpoint.
    #
    # @example
    #   auth = kinde.verify_access_token(token)
    #   auth.user_id                       # => "kp_123"
    #   auth.has_permission?("read:docs")  # => true
    class AuthContext
      # @return [String] the raw access token, for downstream calls. Never log it.
      attr_reader :token
      # @return [String, nil] the Kinde user ID (+sub+)
      attr_reader :user_id
      # @return [String, nil] the user's email, when the token carries it
      attr_reader :email
      # @return [String, nil] the organization code (+org_code+)
      attr_reader :org_code
      # @return [Array<String>] permission keys; empty when the claim is absent
      attr_reader :permissions
      # @return [Array<String>] role keys; empty when the claim is absent
      attr_reader :roles
      # @return [Array<String>] granted OAuth scopes
      attr_reader :scopes
      # @return [String, nil] the agent: +azp+, else +client_id+
      attr_reader :client_id
      # @return [Numeric, nil] expiry (+exp+) in seconds since the epoch
      attr_reader :expires_at
      # @return [Hash{String=>Object}] every claim
      attr_reader :claims

      # Builds a context from a token and its claims.
      #
      # @param token [String] the raw access token
      # @param claims [Hash] the token's claims (string or symbol keys)
      # @return [AuthContext]
      # @example
      #   auth = KindeSdk::AgentAuth::AuthContext.from_claims(token, "sub" => "kp_123", "permissions" => ["read:docs"])
      #   auth.permissions # => ["read:docs"]
      def self.from_claims(token, claims)
        new(token, claims)
      end

      # @param token [String]
      # @param claims [Hash]
      def initialize(token, claims)
        @token = token
        @claims = claims.to_h.transform_keys(&:to_s).freeze
        @user_id = @claims["sub"]
        @email = @claims["email"]
        @org_code = @claims["org_code"]
        @permissions = string_list(@claims["permissions"])
        @roles = role_keys(@claims["roles"])
        @scopes = scope_list(@claims)
        @client_id = @claims["azp"] || @claims["client_id"]
        @expires_at = @claims["exp"]
        freeze
      end

      # Whether the token carries a Kinde permission. Inside an MCP tool, a
      # missing permission is a tool error, not an HTTP 403.
      #
      # @param key [String] the permission key, for example "read:docs"
      # @return [Boolean]
      # @example
      #   return tool_error("No access") unless auth.has_permission?("read:docs")
      def has_permission?(key)
        !key.nil? && permissions.include?(key.to_s)
      end

      # camelCase twin of {#has_permission?}, for parity with the other Kinde SDKs.
      alias_method :hasPermission, :has_permission?

      # @return [String] a description that leaves the token out
      def inspect
        "#<#{self.class.name} user_id=#{user_id.inspect} org_code=#{org_code.inspect} " \
          "client_id=#{client_id.inspect} scopes=#{scopes.inspect} permissions=#{permissions.inspect} " \
          "roles=#{roles.inspect} expires_at=#{expires_at.inspect} token=[REDACTED]>"
      end
      alias to_s inspect

      private

      def string_list(value)
        return [].freeze unless value.is_a?(Array)

        value.map(&:to_s).freeze
      end

      # Kinde sends roles as objects ({"id", "key", "name"}); keep the keys.
      def role_keys(value)
        return [].freeze unless value.is_a?(Array)

        value.filter_map { |role| role.is_a?(Hash) ? (role["key"] || role[:key]) : role }.map(&:to_s).freeze
      end

      def scope_list(claims)
        return string_list(claims["scp"]) if claims["scp"].is_a?(Array)
        return claims["scope"].split(" ").freeze if claims["scope"].is_a?(String)

        [].freeze
      end
    end
  end
end
