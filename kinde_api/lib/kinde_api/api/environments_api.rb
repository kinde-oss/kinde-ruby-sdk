=begin
#Kinde Management API

# Provides endpoints to manage your Kinde Businesses.  ## Intro  ## How to use  1. [Set up and authorize a machine-to-machine (M2M) application](https://docs.kinde.com/developer-tools/kinde-api/connect-to-kinde-api/).  2. [Generate a test access token](https://docs.kinde.com/developer-tools/kinde-api/access-token-for-api/)  3. Test request any endpoint using the test token 

The version of the OpenAPI document: 1
Contact: support@kinde.com
Generated by: https://openapi-generator.tech
OpenAPI Generator version: 6.4.0

=end

require 'cgi'

module KindeApi
  class EnvironmentsApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Add logo
    # Add environment logo  <div>   <code>update:environments</code> </div> 
    # @param type [String] The type of logo to add.
    # @param logo [File] The logo file to upload.
    # @param [Hash] opts the optional parameters
    # @return [SuccessResponse]
    def add_logo(type, logo, opts = {})
      data, _status_code, _headers = add_logo_with_http_info(type, logo, opts)
      data
    end

    # Add logo
    # Add environment logo  &lt;div&gt;   &lt;code&gt;update:environments&lt;/code&gt; &lt;/div&gt; 
    # @param type [String] The type of logo to add.
    # @param logo [File] The logo file to upload.
    # @param [Hash] opts the optional parameters
    # @return [Array<(SuccessResponse, Integer, Hash)>] SuccessResponse data, response status code and response headers
    def add_logo_with_http_info(type, logo, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: EnvironmentsApi.add_logo ...'
      end
      # verify the required parameter 'type' is set
      if @api_client.config.client_side_validation && type.nil?
        fail ArgumentError, "Missing the required parameter 'type' when calling EnvironmentsApi.add_logo"
      end
      # verify enum value
      allowable_values = ["dark", "light"]
      if @api_client.config.client_side_validation && !allowable_values.include?(type)
        fail ArgumentError, "invalid value for \"type\", must be one of #{allowable_values}"
      end
      # verify the required parameter 'logo' is set
      if @api_client.config.client_side_validation && logo.nil?
        fail ArgumentError, "Missing the required parameter 'logo' when calling EnvironmentsApi.add_logo"
      end
      # resource path
      local_var_path = '/api/v1/environment/logos/{type}'.sub('{' + 'type' + '}', CGI.escape(type.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      content_type = @api_client.select_header_content_type(['multipart/form-data'])
      if !content_type.nil?
          header_params['Content-Type'] = content_type
      end

      # form parameters
      form_params = opts[:form_params] || {}
      form_params['logo'] = logo

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'SuccessResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"EnvironmentsApi.add_logo",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:PUT, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: EnvironmentsApi#add_logo\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Delete Environment Feature Flag Override
    # Delete environment feature flag override.  <div>   <code>delete:environment_feature_flags</code> </div> 
    # @param feature_flag_key [String] The identifier for the feature flag.
    # @param [Hash] opts the optional parameters
    # @return [SuccessResponse]
    def delete_environement_feature_flag_override(feature_flag_key, opts = {})
      data, _status_code, _headers = delete_environement_feature_flag_override_with_http_info(feature_flag_key, opts)
      data
    end

    # Delete Environment Feature Flag Override
    # Delete environment feature flag override.  &lt;div&gt;   &lt;code&gt;delete:environment_feature_flags&lt;/code&gt; &lt;/div&gt; 
    # @param feature_flag_key [String] The identifier for the feature flag.
    # @param [Hash] opts the optional parameters
    # @return [Array<(SuccessResponse, Integer, Hash)>] SuccessResponse data, response status code and response headers
    def delete_environement_feature_flag_override_with_http_info(feature_flag_key, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: EnvironmentsApi.delete_environement_feature_flag_override ...'
      end
      # verify the required parameter 'feature_flag_key' is set
      if @api_client.config.client_side_validation && feature_flag_key.nil?
        fail ArgumentError, "Missing the required parameter 'feature_flag_key' when calling EnvironmentsApi.delete_environement_feature_flag_override"
      end
      # resource path
      local_var_path = '/api/v1/environment/feature_flags/{feature_flag_key}'.sub('{' + 'feature_flag_key' + '}', CGI.escape(feature_flag_key.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'application/json; charset=utf-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'SuccessResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"EnvironmentsApi.delete_environement_feature_flag_override",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: EnvironmentsApi#delete_environement_feature_flag_override\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Delete Environment Feature Flag Overrides
    # Delete all environment feature flag overrides.  <div>   <code>delete:environment_feature_flags</code> </div> 
    # @param [Hash] opts the optional parameters
    # @return [SuccessResponse]
    def delete_environement_feature_flag_overrides(opts = {})
      data, _status_code, _headers = delete_environement_feature_flag_overrides_with_http_info(opts)
      data
    end

    # Delete Environment Feature Flag Overrides
    # Delete all environment feature flag overrides.  &lt;div&gt;   &lt;code&gt;delete:environment_feature_flags&lt;/code&gt; &lt;/div&gt; 
    # @param [Hash] opts the optional parameters
    # @return [Array<(SuccessResponse, Integer, Hash)>] SuccessResponse data, response status code and response headers
    def delete_environement_feature_flag_overrides_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: EnvironmentsApi.delete_environement_feature_flag_overrides ...'
      end
      # resource path
      local_var_path = '/api/v1/environment/feature_flags'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'application/json; charset=utf-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'SuccessResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"EnvironmentsApi.delete_environement_feature_flag_overrides",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: EnvironmentsApi#delete_environement_feature_flag_overrides\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Delete logo
    # Delete environment logo  <div>   <code>update:environments</code> </div> 
    # @param type [String] The type of logo to delete.
    # @param [Hash] opts the optional parameters
    # @return [SuccessResponse]
    def delete_logo(type, opts = {})
      data, _status_code, _headers = delete_logo_with_http_info(type, opts)
      data
    end

    # Delete logo
    # Delete environment logo  &lt;div&gt;   &lt;code&gt;update:environments&lt;/code&gt; &lt;/div&gt; 
    # @param type [String] The type of logo to delete.
    # @param [Hash] opts the optional parameters
    # @return [Array<(SuccessResponse, Integer, Hash)>] SuccessResponse data, response status code and response headers
    def delete_logo_with_http_info(type, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: EnvironmentsApi.delete_logo ...'
      end
      # verify the required parameter 'type' is set
      if @api_client.config.client_side_validation && type.nil?
        fail ArgumentError, "Missing the required parameter 'type' when calling EnvironmentsApi.delete_logo"
      end
      # verify enum value
      allowable_values = ["dark", "light"]
      if @api_client.config.client_side_validation && !allowable_values.include?(type)
        fail ArgumentError, "invalid value for \"type\", must be one of #{allowable_values}"
      end
      # resource path
      local_var_path = '/api/v1/environment/logos/{type}'.sub('{' + 'type' + '}', CGI.escape(type.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'SuccessResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"EnvironmentsApi.delete_logo",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: EnvironmentsApi#delete_logo\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # List Environment Feature Flags
    # Get environment feature flags.  <div>   <code>read:environment_feature_flags</code> </div> 
    # @param [Hash] opts the optional parameters
    # @return [GetEnvironmentFeatureFlagsResponse]
    def get_environement_feature_flags(opts = {})
      data, _status_code, _headers = get_environement_feature_flags_with_http_info(opts)
      data
    end

    # List Environment Feature Flags
    # Get environment feature flags.  &lt;div&gt;   &lt;code&gt;read:environment_feature_flags&lt;/code&gt; &lt;/div&gt; 
    # @param [Hash] opts the optional parameters
    # @return [Array<(GetEnvironmentFeatureFlagsResponse, Integer, Hash)>] GetEnvironmentFeatureFlagsResponse data, response status code and response headers
    def get_environement_feature_flags_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: EnvironmentsApi.get_environement_feature_flags ...'
      end
      # resource path
      local_var_path = '/api/v1/environment/feature_flags'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'application/json; charset=utf-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'GetEnvironmentFeatureFlagsResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"EnvironmentsApi.get_environement_feature_flags",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: EnvironmentsApi#get_environement_feature_flags\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Get environment
    # Gets the current environment.  <div>   <code>read:environments</code> </div> 
    # @param [Hash] opts the optional parameters
    # @return [GetEnvironmentResponse]
    def get_environment(opts = {})
      data, _status_code, _headers = get_environment_with_http_info(opts)
      data
    end

    # Get environment
    # Gets the current environment.  &lt;div&gt;   &lt;code&gt;read:environments&lt;/code&gt; &lt;/div&gt; 
    # @param [Hash] opts the optional parameters
    # @return [Array<(GetEnvironmentResponse, Integer, Hash)>] GetEnvironmentResponse data, response status code and response headers
    def get_environment_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: EnvironmentsApi.get_environment ...'
      end
      # resource path
      local_var_path = '/api/v1/environment'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'GetEnvironmentResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"EnvironmentsApi.get_environment",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: EnvironmentsApi#get_environment\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Read logo details
    # Read environment logo details  <div>   <code>read:environments</code> </div> 
    # @param [Hash] opts the optional parameters
    # @return [ReadEnvLogoResponse]
    def read_logo(opts = {})
      data, _status_code, _headers = read_logo_with_http_info(opts)
      data
    end

    # Read logo details
    # Read environment logo details  &lt;div&gt;   &lt;code&gt;read:environments&lt;/code&gt; &lt;/div&gt; 
    # @param [Hash] opts the optional parameters
    # @return [Array<(ReadEnvLogoResponse, Integer, Hash)>] ReadEnvLogoResponse data, response status code and response headers
    def read_logo_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: EnvironmentsApi.read_logo ...'
      end
      # resource path
      local_var_path = '/api/v1/environment/logos'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'ReadEnvLogoResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"EnvironmentsApi.read_logo",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: EnvironmentsApi#read_logo\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Update Environment Feature Flag Override
    # Update environment feature flag override.  <div>   <code>update:environment_feature_flags</code> </div> 
    # @param feature_flag_key [String] The identifier for the feature flag.
    # @param update_environement_feature_flag_override_request [UpdateEnvironementFeatureFlagOverrideRequest] Flag details.
    # @param [Hash] opts the optional parameters
    # @return [SuccessResponse]
    def update_environement_feature_flag_override(feature_flag_key, update_environement_feature_flag_override_request, opts = {})
      data, _status_code, _headers = update_environement_feature_flag_override_with_http_info(feature_flag_key, update_environement_feature_flag_override_request, opts)
      data
    end

    # Update Environment Feature Flag Override
    # Update environment feature flag override.  &lt;div&gt;   &lt;code&gt;update:environment_feature_flags&lt;/code&gt; &lt;/div&gt; 
    # @param feature_flag_key [String] The identifier for the feature flag.
    # @param update_environement_feature_flag_override_request [UpdateEnvironementFeatureFlagOverrideRequest] Flag details.
    # @param [Hash] opts the optional parameters
    # @return [Array<(SuccessResponse, Integer, Hash)>] SuccessResponse data, response status code and response headers
    def update_environement_feature_flag_override_with_http_info(feature_flag_key, update_environement_feature_flag_override_request, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: EnvironmentsApi.update_environement_feature_flag_override ...'
      end
      # verify the required parameter 'feature_flag_key' is set
      if @api_client.config.client_side_validation && feature_flag_key.nil?
        fail ArgumentError, "Missing the required parameter 'feature_flag_key' when calling EnvironmentsApi.update_environement_feature_flag_override"
      end
      # verify the required parameter 'update_environement_feature_flag_override_request' is set
      if @api_client.config.client_side_validation && update_environement_feature_flag_override_request.nil?
        fail ArgumentError, "Missing the required parameter 'update_environement_feature_flag_override_request' when calling EnvironmentsApi.update_environement_feature_flag_override"
      end
      # resource path
      local_var_path = '/api/v1/environment/feature_flags/{feature_flag_key}'.sub('{' + 'feature_flag_key' + '}', CGI.escape(feature_flag_key.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      content_type = @api_client.select_header_content_type(['application/json'])
      if !content_type.nil?
          header_params['Content-Type'] = content_type
      end

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body] || @api_client.object_to_http_body(update_environement_feature_flag_override_request)

      # return_type
      return_type = opts[:debug_return_type] || 'SuccessResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"EnvironmentsApi.update_environement_feature_flag_override",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: EnvironmentsApi#update_environement_feature_flag_override\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
