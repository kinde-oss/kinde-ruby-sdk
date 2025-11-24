module KindeSdk
    class Client
      module Entitlements
        # Get all entitlements for the authenticated user
        # Matches the JavaScript SDK API: getEntitlements(options?)
        #
        # @param options [Hash] Options for retrieving entitlements
        # @option options [Boolean] :force_api (false) If true, calls the API to get fresh entitlements,
        #   otherwise uses existing getAllEntitlements method
        # @return [Array] Array of entitlement objects
        def get_entitlements(options = {})
          # Entitlements are always fetched from API (they don't exist in tokens)
          # The options parameter is kept for consistency with other methods
          getAllEntitlements
        end
  
        # Check if user has billing entitlements
        # Matches the JavaScript SDK API: hasBillingEntitlements(params)
        #
        # @param billing_entitlements [Array<String, Hash>] Array of billing entitlement price names or entitlement condition objects to check
        # @param options [Hash] Options for retrieving entitlements
        # @return [Boolean] True if user has all specified billing entitlements, false otherwise
        # @example
        #   # Simple entitlement check
        #   client.has_billing_entitlements?(['premium', 'pro'])
        #   # => true
        #
        #   # Complex condition check with custom logic
        #   client.has_billing_entitlements?([
        #     'premium',
        #     {
        #       entitlement: 'api-access',
        #       condition: ->(entitlement) { entitlement.usage_limit > 100 }
        #     }
        #   ])
        #   # => true
        def has_billing_entitlements?(billing_entitlements, options = {})
          return true if billing_entitlements.nil? || billing_entitlements.empty?
          
          begin
            entitlements = get_entitlements(options)
            billing_entitlements_array = Array(billing_entitlements)
            
            billing_entitlements_array.all? do |entitlement|
              if custom_entitlement_condition?(entitlement)
                # Complex condition with custom logic
                entitlement_key = entitlement[:entitlement] || entitlement['entitlement']
                condition = entitlement[:condition] || entitlement['condition']
                
                matching_entitlement = entitlements.find do |ent|
                  price_name = ent.respond_to?(:price_name) ? ent.price_name : ent['price_name']
                  price_name == entitlement_key
                end
                
                if matching_entitlement && condition
                  condition.call(matching_entitlement)
                else
                  false
                end
              else
                # Simple string entitlement check
                entitlement_price_names = entitlements.map do |ent|
                  ent.respond_to?(:price_name) ? ent.price_name : ent['price_name']
                end.compact
                
                entitlement_price_names.include?(entitlement)
              end
            end
          rescue StandardError => e
            log_error("Error checking billing entitlements: #{e.message}")
            false
          end
        end
  
        # Check if user has feature entitlements
        # 
        # @param entitlement_keys [Array<String>] Array of entitlement feature keys to check
        # @param options [Hash] Options for retrieving entitlements
        # @return [Boolean] True if user has all specified entitlements, false otherwise
        def has_entitlements?(entitlement_keys, options = {})
          return true if entitlement_keys.nil? || entitlement_keys.empty?
          
          begin
            entitlements = get_entitlements(options)
            entitlement_keys_array = Array(entitlement_keys)
            
            # Extract feature keys from entitlements
            entitlement_feature_keys = entitlements.map do |ent|
              ent.respond_to?(:feature_key) ? ent.feature_key : ent['feature_key']
            end.compact
            
            entitlement_keys_array.all? { |key| entitlement_feature_keys.include?(key) }
          rescue StandardError => e
            log_error("Error checking entitlements: #{e.message}")
            false
          end
        end
  
        # JavaScript SDK compatible aliases
        alias_method :hasBillingEntitlements, :has_billing_entitlements?
        alias_method :hasEntitlements, :has_entitlements?
  
        private

        # Check if an entitlement is a custom condition object
        # Matches js-utils isCustomEntitlementCondition pattern
        #
        # @param entitlement [Object] The entitlement to check
        # @return [Boolean] True if it's a custom condition
        def custom_entitlement_condition?(entitlement)
          entitlement.is_a?(Hash) && 
          (entitlement.key?(:entitlement) || entitlement.key?('entitlement')) &&
          (entitlement.key?(:condition) || entitlement.key?('condition')) &&
          (entitlement[:condition]&.respond_to?(:call) || entitlement['condition']&.respond_to?(:call))
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