require 'rack'

module KindeSdk
  module Storage
    # Base storage class providing cookie-based storage with security features
    class BaseStorage
      PREFIX = 'kinde'.freeze
      
      class << self
        attr_accessor :cookie_http_only, :cookie_path, :cookie_domain, :cookie_secure, :cookie_same_site
        
        def initialize_defaults
          @cookie_http_only = true
          @cookie_path = "/"
          @cookie_domain = ""
          @cookie_secure = true
          @cookie_same_site = :lax
        end
        
        def get_item(key, request = nil)
          request = get_request_context(request)
          return nil unless request&.cookies
          
          full_key = build_key(key)
          value = request.cookies[full_key]
          
          if defined?(KindeSdk::KSP) && KindeSdk::KSP.enabled?
            value = KindeSdk::KSP.decrypt(value) if value
          end
          
          value
        end
        
        def set_item(key, value, response = nil, expires: nil, **options)
          response = get_response_context(response)
          return false unless response
          
          full_key = build_key(key)
          
          if defined?(KindeSdk::KSP) && KindeSdk::KSP.enabled?
            value = KindeSdk::KSP.encrypt(value.to_s)
          end
          
          cookie_options = build_cookie_options(expires, options)
          
          if response.respond_to?(:set_cookie)
            response.set_cookie(full_key, cookie_options.merge(value: value))
          elsif response.respond_to?(:cookies)
            if expires
              response.cookies[full_key] = cookie_options.merge(value: value)
            else
              response.cookies[full_key] = value
            end
          else
            return false
          end
          
          true
        end
        
        # Remove item from cookies
        # @param key [String] The storage key
        # @param response [ActionDispatch::Response, Rack::Response] The response object
        def remove_item(key, response = nil)
          response = get_response_context(response)
          return false unless response
          
          full_key = build_key(key)
          
          if response.respond_to?(:delete_cookie)
            response.delete_cookie(full_key)
          elsif response.respond_to?(:cookies)
            response.cookies.delete(full_key)
          end
          
          true
        end
        
        # Clear all Kinde-related cookies
        # @param response [ActionDispatch::Response, Rack::Response] The response object
        def clear(response = nil)
          # Note: In web context, we can't enumerate all cookies, so this is a best-effort clear
          # Applications should call remove_item for specific keys they want to clear
          StorageEnums.constants.each do |const|
            key = StorageEnums.const_get(const)
            remove_item(key, response) if key.is_a?(String)
          end
        end
        
        # Build the full cookie key with prefix
        # @param key [String] The base key
        # @return [String] The prefixed key
        def build_key(key)
          "#{PREFIX}_#{key}"
        end
        
        # Get request context from various sources
        # @param request [Object] Request object or nil for auto-detection
        # @return [Object, nil] Request object
        def get_request_context(request)
          return request if request
          
          # Try Rails controller context
          if defined?(Rails) && Rails.respond_to?(:application)
            begin
              return Current.request if defined?(Current) && Current.respond_to?(:request)
            rescue
              # Ignore errors getting request context
            end
          end
          
          # Try Thread current if available (some Rack middleware sets this)
          Thread.current[:request] if Thread.current[:request]
        end
        
        # Get response context from various sources
        # @param response [Object] Response object or nil for auto-detection
        # @return [Object, nil] Response object  
        def get_response_context(response)
          return response if response
          
          # Try Rails controller context
          if defined?(Rails) && Rails.respond_to?(:application)
            begin
              return Current.response if defined?(Current) && Current.respond_to?(:response)
            rescue
              # Ignore errors getting response context
            end
          end
          
          # Try Thread current if available
          Thread.current[:response] if Thread.current[:response]
        end
        
        # Build cookie options hash
        # @param expires [Time, Integer, nil] Expiration time
        # @param options [Hash] Additional options
        # @return [Hash] Cookie options
        def build_cookie_options(expires, options)
          cookie_options = {
            httponly: @cookie_http_only,
            secure: @cookie_secure,
            same_site: @cookie_same_site,
            path: @cookie_path
          }
          
          cookie_options[:domain] = @cookie_domain unless @cookie_domain.empty?
          
          if expires
            cookie_options[:expires] = expires.is_a?(Integer) ? Time.at(expires) : expires
          end
          
          cookie_options.merge(options)
        end
      end
      
      # Initialize defaults when class is loaded
      initialize_defaults
    end
  end
end
