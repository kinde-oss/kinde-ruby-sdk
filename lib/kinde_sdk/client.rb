require_relative '../../kinde_api/lib/kinde_api'
require_relative 'token_manager'
require_relative 'token_store'
require_relative 'current'
require_relative 'errors'
require_relative 'internal/frontend_client'

module KindeSdk
  # Constants for portal page navigation
  module PortalPage
    ORGANIZATION_DETAILS = 'organization_details'
    ORGANIZATION_MEMBERS = 'organization_members'
    ORGANIZATION_PLAN_DETAILS = 'organization_plan_details'
    ORGANIZATION_PAYMENT_DETAILS = 'organization_payment_details'
    ORGANIZATION_PLAN_SELECTION = 'organization_plan_selection'
    PROFILE = 'profile'
  end

  class Client
    include FeatureFlags
    include Permissions

    attr_accessor :kinde_api_client, :auto_refresh_tokens, :token_store

    def initialize(sdk_api_client, tokens_hash, auto_refresh_tokens)
      @kinde_api_client = sdk_api_client
      @auto_refresh_tokens = auto_refresh_tokens
      @token_store = TokenManager.create_store(tokens_hash)

      # refresh the token if it's expired and auto_refresh_tokens is enabled
      refresh_token if auto_refresh_tokens && TokenManager.token_expired?(@token_store)
    end

    # Returns the bearer token for backwards compatibility
    # @return [String]
    def bearer_token
      @token_store.bearer_token
    end

    # Returns the tokens hash for backwards compatibility
    # @return [Hash]
    def tokens_hash
      @token_store.tokens
    end

    # Returns the token expiration time for backwards compatibility
    # @return [Integer]
    def expires_at
      @token_store.expires_at
    end

    def token_expired?
      TokenManager.token_expired?(@token_store)
    end

    def refresh_token
      new_tokens_hash = TokenManager.refresh_tokens(@token_store, Current.session)
      return nil unless new_tokens_hash

      @token_store.set_tokens(new_tokens_hash)
      @kinde_api_client = KindeSdk.api_client(@token_store.bearer_token)
      new_tokens_hash
    end

    # token_type is one of: :access_token, :id_token
    #
    # @return [Hash]
    # @example {name: "scp", value: ["openid", "offline"]}
    def get_claim(claim, token_type = :access_token)
      refresh_token if auto_refresh_tokens && token_expired?

      token = @token_store.tokens[token_type.to_sym]
      return unless token

      value = JWT.decode(token, nil, false)[0][claim]
      return unless value

      { name: claim, value: value }
    end

    # Generate a URL to the user profile portal
    #
    # @param domain [String] The domain of the Kinde instance
    # @param return_url [String] URL to redirect to after completing the profile flow
    # @param sub_nav [String] Sub-navigation section to display
    # @return [Hash] A hash containing the generated URL
    # @raise [StandardError] If the request fails or returns invalid data
    def generate_portal_url(domain:, return_url:, sub_nav: PortalPage::PROFILE)
      refresh_token if auto_refresh_tokens && token_expired?

      unless return_url.start_with?('http')
        raise StandardError, 'generatePortalUrl: returnUrl must be an absolute URL'
      end

      params = {
        'return_url' => return_url,
        'sub_nav' => sub_nav
      }

      response = Faraday.get("#{domain}/account_api/v1/portal_link", params) do |req|
        req.headers['Authorization'] = "Bearer #{@token_store.bearer_token}"
      end

      unless response.success?
        raise StandardError, "Failed to fetch profile URL: #{response.status} #{response.reason_phrase}"
      end

      result = JSON.parse(response.body)
      unless result['url'].is_a?(String)
        raise StandardError, "Invalid URL received from API"
      end

      begin
        { url: URI.parse(result['url']) }
      rescue URI::InvalidURIError => e
        Rails.logger.error(e)
        raise StandardError, "Invalid URL format received from API: #{result['url']}"
      end
    end

    ::KindeApi.constants.filter { |klass| klass.to_s.end_with?("Api") }.each do |klass|
      api_klass = Kernel.const_get("KindeApi::#{klass}")

      define_method(klass.to_s.gsub(/([a-z\d])([A-Z])/) { "#{$1}_#{$2}" }.downcase.split("_api")[0]) do
        init_instance_api(api_klass)
      end
    end

    # Custom oauth method that provides backward compatibility
    def oauth
      oauth_api = init_instance_api(KindeApi::OAuthApi)
      
      # Add backward compatibility for get_user method
      unless oauth_api.respond_to?(:get_user)
        oauth_api.define_singleton_method(:get_user) do |opts = {}|
          # Call the new method
          user_profile_v2 = get_user_profile_v2(opts)
          
          # Convert UserProfileV2 to UserProfile format as a hash
          # This provides backward compatibility without depending on the UserProfile class
          {
            id: user_profile_v2.id || user_profile_v2.sub,
            preferred_email: user_profile_v2.email,
            provided_id: user_profile_v2.provided_id,
            last_name: user_profile_v2.family_name,
            first_name: user_profile_v2.given_name,
            picture: user_profile_v2.picture
          }
        end
      end
      
      oauth_api
    end

    # Frontend API access - Internal use only
    # Uses user access tokens instead of M2M tokens
    def frontend
      @frontend_client ||= FrontendClient.new(@kinde_api_client, @token_store, @auto_refresh_tokens)
    end

    # Internal helper methods for Frontend API - NOT for public consumption
    private

    def get_user_entitlements(page_size: nil, starting_after: nil)
      frontend.billing.get_entitlements(page_size: page_size, starting_after: starting_after)
    end

    def get_user_entitlement(key)
      frontend.billing.get_entitlement(key: key)
    end

    def get_user_feature_flags(page_size: nil, starting_after: nil)
      frontend.feature_flags.get_feature_flags(page_size: page_size, starting_after: starting_after)
    end

    def get_user_permissions(page_size: nil, starting_after: nil)
      frontend.permissions.get_user_permissions(page_size: page_size, starting_after: starting_after)
    end

    def get_user_properties(page_size: nil, starting_after: nil)
      frontend.properties.get_user_properties(page_size: page_size, starting_after: starting_after)
    end

    def get_user_roles(page_size: nil, starting_after: nil)
      frontend.roles.get_user_roles(page_size: page_size, starting_after: starting_after)
    end

    def get_portal_link(subnav: nil, return_url: nil)
      frontend.self_serve_portal.get_portal_link(subnav: subnav, return_url: return_url)
    end

    def get_enhanced_user_profile
      frontend.oauth.get_user_profile_v2
    end

    public

    # Public SDK methods that use Frontend API internally
    def entitlements(page_size: 10, starting_after: nil)
      frontend_client.get_entitlements(page_size: page_size, starting_after: starting_after)
    rescue StandardError => e
      Rails.logger.error("Failed to fetch entitlements: #{e.message}")
      raise KindeSdk::APIError, "Unable to fetch entitlements: #{e.message}"
    end

    def entitlement(key)
      frontend_client.get_entitlement(key)
    rescue StandardError => e
      Rails.logger.error("Failed to fetch entitlement for #{key}: #{e.message}")
      raise KindeSdk::APIError, "Unable to fetch entitlement: #{e.message}"
    end

    def has_entitlement?(feature_key)
      entitlement_response = entitlement(feature_key)
      entitlement_response&.data&.entitlement.present?
    rescue StandardError => e
      Rails.logger.error("Error checking entitlement for #{feature_key}: #{e.message}")
      false
    end

    def user_feature_flags(page_size: 10, starting_after: nil)
      frontend_client.get_feature_flags(page_size: page_size, starting_after: starting_after)
    rescue StandardError => e
      Rails.logger.error("Failed to fetch feature flags: #{e.message}")
      raise KindeSdk::APIError, "Unable to fetch feature flags: #{e.message}"
    end

    def user_permissions(page_size: 10, starting_after: nil)
      frontend_client.get_user_permissions(page_size: page_size, starting_after: starting_after)
    rescue StandardError => e
      Rails.logger.error("Failed to fetch permissions: #{e.message}")
      raise KindeSdk::APIError, "Unable to fetch permissions: #{e.message}"
    end

    def user_properties(page_size: 10, starting_after: nil)
      frontend_client.get_user_properties(page_size: page_size, starting_after: starting_after)
    rescue StandardError => e
      Rails.logger.error("Failed to fetch properties: #{e.message}")
      raise KindeSdk::APIError, "Unable to fetch properties: #{e.message}"
    end

    def user_roles(page_size: 10, starting_after: nil)
      frontend_client.get_user_roles(page_size: page_size, starting_after: starting_after)
    rescue StandardError => e
      Rails.logger.error("Failed to fetch roles: #{e.message}")
      raise KindeSdk::APIError, "Unable to fetch roles: #{e.message}"
    end

    def portal_link(page: nil, return_url: nil)
      frontend_client.get_portal_link(subnav: page, return_url: return_url)
    rescue StandardError => e
      Rails.logger.error("Failed to get portal link: #{e.message}")
      raise KindeSdk::APIError, "Unable to get portal link: #{e.message}"
    end

    def enhanced_user_profile
      frontend_client.get_user_profile_v2
    rescue StandardError => e
      Rails.logger.error("Failed to fetch enhanced profile: #{e.message}")
      raise KindeSdk::APIError, "Unable to fetch enhanced profile: #{e.message}"
    end

    private

    def init_instance_api(api_klass)
      
      instance = api_klass.new(kinde_api_client)
      
      
      main_client = self
      methods_to_prepend = instance.public_methods(false).reject { |m| m.to_s.start_with?("api_client") }
      
      methods_to_prepend.each do |method_name|
        original = instance.method(method_name)
        instance.define_singleton_method(method_name) do |*args, &block|
          main_client.refresh_token if main_client.auto_refresh_tokens && main_client.token_expired?
          original.call(*args, &block)
        end
      end
      instance
    end

    def frontend_client
      @frontend_client ||= KindeSdk::Internal::FrontendClient.new(@token_store, KindeSdk.config.domain)
    end
  end
end

# Frontend Client class - Internal use only
class FrontendClient
  def initialize(api_client, token_store, auto_refresh_tokens)
    @api_client = api_client
    @token_store = token_store
    @auto_refresh_tokens = auto_refresh_tokens
  end

  def billing
    @billing_api ||= init_frontend_api(KindeApi::Frontend::BillingApi)
  end

  def feature_flags
    @feature_flags_api ||= init_frontend_api(KindeApi::Frontend::FeatureFlagsApi)
  end

  def oauth
    @oauth_api ||= init_frontend_api(KindeApi::Frontend::OAuthApi)
  end

  def permissions
    @permissions_api ||= init_frontend_api(KindeApi::Frontend::PermissionsApi)
  end

  def properties
    @properties_api ||= init_frontend_api(KindeApi::Frontend::PropertiesApi)
  end

  def roles
    @roles_api ||= init_frontend_api(KindeApi::Frontend::RolesApi)
  end

  def self_serve_portal
    @self_serve_portal_api ||= init_frontend_api(KindeApi::Frontend::SelfServePortalApi)
  end

  private

  def init_frontend_api(api_class)
    instance = api_class.new(@api_client)
    
    # Add auto-refresh capability to all methods
    methods_to_enhance = instance.public_methods(false).reject { |m| m.to_s.start_with?("api_client") }
    
    methods_to_enhance.each do |method_name|
      original = instance.method(method_name)
      instance.define_singleton_method(method_name) do |*args, &block|
        # Refresh token if needed and auto_refresh is enabled
        if @auto_refresh_tokens && TokenManager.token_expired?(@token_store)
          TokenManager.refresh_tokens(@token_store, Current.session)
        end
        original.call(*args, &block)
      end
    end
    
    instance
  end
end
