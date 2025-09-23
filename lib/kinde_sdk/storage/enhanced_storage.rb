require_relative 'base_storage'
require_relative 'storage_enums'
require 'json'
require 'jwt'

module KindeSdk
  module Storage
    # Enhanced storage class with KSP integration and token management
    class EnhancedStorage < BaseStorage
      class << self
        attr_accessor :jwks_url, :token_time_to_live
        
        # Get token from storage
        # @param request [Object] Request context
        # @param as_hash [Boolean] Whether to return as hash (true) or JSON string (false)  
        # @return [Hash, String, nil] The token data
        def get_token(request = nil, as_hash: true)
          token_json = get_item(StorageEnums::TOKEN, request)
          return nil if token_json.nil? || token_json.empty?
          
          begin
            token_data = JSON.parse(token_json)
            as_hash ? token_data : token_json
          rescue JSON::ParserError
            nil
          end
        end
        
        # Set token in storage
        # @param token [Hash, String] Token data (hash will be JSON-encoded)
        # @param response [Object] Response context
        # @return [Boolean] Success status
        def set_token(token, response = nil)
          token_json = token.is_a?(String) ? token : token.to_json
          expires_at = get_token_time_to_live
          
          set_item(StorageEnums::TOKEN, token_json, response, expires: expires_at)
        end
        
        # Get access token from stored token data
        # @param request [Object] Request context
        # @return [String, nil] The access token
        def get_access_token(request = nil)
          token = get_token(request)
          token&.dig('access_token') || token&.dig(:access_token)
        end
        
        # Get ID token from stored token data
        # @param request [Object] Request context
        # @return [String, nil] The ID token
        def get_id_token(request = nil)
          token = get_token(request)
          token&.dig('id_token') || token&.dig(:id_token)
        end
        
        # Get refresh token from stored token data
        # @param request [Object] Request context
        # @return [String, nil] The refresh token
        def get_refresh_token(request = nil)
          token = get_token(request)
          token&.dig('refresh_token') || token&.dig(:refresh_token)
        end
        
        # Get token expiration time
        # @param request [Object] Request context
        # @return [Integer] Expiration timestamp (0 if not available)
        def get_expired_at(request = nil)
          access_token = get_access_token(request)
          return 0 unless access_token
          
          begin
            # Decode JWT without verification to get expiration
            payload = JWT.decode(access_token, nil, false)[0]
            payload['exp'] || 0
          rescue JWT::DecodeError, StandardError
            0
          end
        end
        
        # Get token time to live (default 15 days)
        # @return [Time] Expiration time
        def get_token_time_to_live
          @token_time_to_live || (Time.now + (15 * 24 * 60 * 60)) # 15 days from now
        end
        
        # Set token time to live
        # @param ttl [Time, Integer] Time to live (Time object or seconds from epoch)
        def set_token_time_to_live(ttl)
          @token_time_to_live = ttl.is_a?(Integer) ? Time.at(ttl) : ttl
        end
        
        # Get state parameter
        # @param request [Object] Request context
        # @return [String, nil] The state value
        def get_state(request = nil)
          get_item(StorageEnums::STATE, request)
        end
        
        # Set state parameter (expires in 2 hours)
        # @param state [String] State value
        # @param response [Object] Response context
        # @return [Boolean] Success status
        def set_state(state, response = nil)
          expires_at = Time.now + (2 * 60 * 60) # 2 hours
          set_item(StorageEnums::STATE, state, response, expires: expires_at)
        end
        
        # Get code verifier for PKCE
        # @param request [Object] Request context
        # @return [String, nil] The code verifier
        def get_code_verifier(request = nil)
          get_item(StorageEnums::CODE_VERIFIER, request)
        end
        
        # Set code verifier for PKCE (expires in 2 hours)
        # @param code_verifier [String] Code verifier value
        # @param response [Object] Response context
        # @return [Boolean] Success status
        def set_code_verifier(code_verifier, response = nil)
          expires_at = Time.now + (2 * 60 * 60) # 2 hours
          set_item(StorageEnums::CODE_VERIFIER, code_verifier, response, expires: expires_at)
        end
        
        # Get user profile from ID token
        # @param request [Object] Request context
        # @return [Hash] User profile data
        def get_user_profile(request = nil)
          id_token = get_id_token(request)
          return {} unless id_token
          
          begin
            payload = JWT.decode(id_token, nil, false)[0]
            {
              id: payload['sub'] || '',
              given_name: payload['given_name'] || '',
              family_name: payload['family_name'] || '',
              email: payload['email'] || '',
              picture: payload['picture'] || ''
            }
          rescue JWT::DecodeError, StandardError
            {}
          end
        end
        
        # Get decoded ID token
        # @param request [Object] Request context
        # @return [Hash] Decoded ID token payload
        def get_decoded_id_token(request = nil)
          id_token = get_id_token(request)
          return {} unless id_token
          
          begin
            JWT.decode(id_token, nil, false)[0]
          rescue JWT::DecodeError, StandardError
            {}
          end
        end
        
        # Get decoded access token
        # @param request [Object] Request context
        # @return [Hash] Decoded access token payload
        def get_decoded_access_token(request = nil)
          access_token = get_access_token(request)
          return {} unless access_token
          
          begin
            JWT.decode(access_token, nil, false)[0]
          rescue JWT::DecodeError, StandardError
            {}
          end
        end
        
        # Get JWKS URL
        # @return [String] The JWKS URL
        # @raise [RuntimeError] If no JWKS URL is configured
        def get_jwks_url
          raise RuntimeError, 'No JWKS URL has been specified' unless @jwks_url
          @jwks_url
        end
        
        # Set JWKS URL
        # @param url [String] The JWKS URL
        def set_jwks_url(url)
          @jwks_url = url
        end
        
        # Get cached JWKS data if available and not expired
        # @param request [Object] Request context
        # @return [Hash, nil] Cached JWKS data or nil if not available/expired
        def get_cached_jwks(request = nil)
          cached_data = get_item(StorageEnums::JWKS_CACHE, request)
          return nil unless cached_data
          
          begin
            data = JSON.parse(cached_data)
            return nil unless data.is_a?(Hash) && data['jwks'] && data['expires_at']
            
            # Check if cache has expired
            if data['expires_at'] < Time.now.to_i
              # Note: We can't remove from cache here without response context
              return nil
            end
            
            data['jwks']
          rescue JSON::ParserError, StandardError
            nil
          end
        end
        
        # Set JWKS data in cache with TTL
        # @param jwks [Hash] The JWKS data to cache
        # @param response [Object] Response context
        # @param ttl_seconds [Integer] TTL in seconds (default: 1 hour)
        def set_cached_jwks(jwks, response = nil, ttl_seconds: 3600)
          expires_at = Time.now.to_i + ttl_seconds
          cache_data = {
            jwks: jwks,
            expires_at: expires_at
          }
          
          expires_time = Time.now + ttl_seconds
          set_item(StorageEnums::JWKS_CACHE, cache_data.to_json, response, expires: expires_time)
        end
        
        # Clear cached JWKS data
        # @param response [Object] Response context
        def clear_cached_jwks(response = nil)
          remove_item(StorageEnums::JWKS_CACHE, response)
        end
        
        # Clear all storage (enhanced version)
        # @param response [Object] Response context
        def clear(response = nil)
          [
            StorageEnums::TOKEN,
            StorageEnums::STATE, 
            StorageEnums::CODE_VERIFIER,
            StorageEnums::USER_PROFILE,
            StorageEnums::JWKS_CACHE,
            StorageEnums::AUTH_STATUS
          ].each do |key|
            remove_item(key, response)
          end
        end
      end
    end
  end
end
