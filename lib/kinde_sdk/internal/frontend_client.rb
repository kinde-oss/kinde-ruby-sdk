require 'httparty'
require 'json'
require 'ostruct'

module KindeSdk
  module Internal
    class FrontendClient
      include HTTParty
      
      def initialize(token_store, domain)
        @token_store = token_store
        @domain = domain
        @base_uri = "#{domain}/account_api/v1"
      end

      def get_entitlements(page_size: 10, starting_after: nil)
        make_request('/entitlements', {
          page_size: page_size,
          starting_after: starting_after
        }.compact)
      end

      def get_entitlement(key)
        make_request("/entitlement", { key: key })
      end

      def get_user_permissions(page_size: 10, starting_after: nil)
        make_request('/permissions', {
          page_size: page_size,
          starting_after: starting_after
        }.compact)
      end

      def get_user_properties(page_size: 10, starting_after: nil)
        make_request('/properties', {
          page_size: page_size,
          starting_after: starting_after
        }.compact)
      end

      def get_user_roles(page_size: 10, starting_after: nil)
        make_request('/roles', {
          page_size: page_size,
          starting_after: starting_after
        }.compact)
      end

      def get_feature_flags(page_size: 10, starting_after: nil)
        make_request('/feature_flags', {
          page_size: page_size,
          starting_after: starting_after
        }.compact)
      end

      def get_portal_link(subnav: nil, return_url: nil)
        make_request('/portal_link', {
          subnav: subnav,
          return_url: return_url
        }.compact)
      end

      def get_user_profile_v2
        url = "#{@domain}/oauth2/v2/user_profile"
        
        response = HTTParty.get(url, {
          headers: {
            'Authorization' => "Bearer #{@token_store.bearer_token}",
            'Content-Type' => 'application/json'
          }
        })
        
        handle_response(response)
      end

      private

      def make_request(endpoint, params = {})
        url = "#{@base_uri}#{endpoint}"
        
        response = HTTParty.get(url, {
          query: params,
          headers: {
            'Authorization' => "Bearer #{@token_store.bearer_token}",
            'Content-Type' => 'application/json'
          }
        })
        
        handle_response(response)
      end

      def handle_response(response)
        case response.code
        when 200
          # Parse as OpenStruct for easy access while keeping it internal
          JSON.parse(response.body, object_class: OpenStruct)
        when 401
          raise KindeSdk::AuthenticationError, "Invalid or expired token"
        when 403
          raise KindeSdk::AuthorizationError, "Insufficient permissions"
        when 429
          raise KindeSdk::RateLimitError, "Too many requests"
        else
          raise KindeSdk::APIError, "API request failed with status #{response.code}: #{response.body}"
        end
      end
    end
  end
end