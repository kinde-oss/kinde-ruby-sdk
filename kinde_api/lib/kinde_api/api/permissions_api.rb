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
  class PermissionsApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Create Permission
    # Create a new permission.  <div>   <code>create:permissions</code> </div> 
    # @param [Hash] opts the optional parameters
    # @option opts [CreatePermissionRequest] :create_permission_request Permission details.
    # @return [SuccessResponse]
    def create_permission(opts = {})
      data, _status_code, _headers = create_permission_with_http_info(opts)
      data
    end

    # Create Permission
    # Create a new permission.  &lt;div&gt;   &lt;code&gt;create:permissions&lt;/code&gt; &lt;/div&gt; 
    # @param [Hash] opts the optional parameters
    # @option opts [CreatePermissionRequest] :create_permission_request Permission details.
    # @return [Array<(SuccessResponse, Integer, Hash)>] SuccessResponse data, response status code and response headers
    def create_permission_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PermissionsApi.create_permission ...'
      end
      # resource path
      local_var_path = '/api/v1/permissions'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      content_type = @api_client.select_header_content_type(['application/json'])
      if !content_type.nil?
          header_params['Content-Type'] = content_type
      end

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body] || @api_client.object_to_http_body(opts[:'create_permission_request'])

      # return_type
      return_type = opts[:debug_return_type] || 'SuccessResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"PermissionsApi.create_permission",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:POST, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PermissionsApi#create_permission\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Delete Permission
    # Delete permission  <div>   <code>delete:permissions</code> </div> 
    # @param permission_id [String] The identifier for the permission.
    # @param [Hash] opts the optional parameters
    # @return [SuccessResponse]
    def delete_permission(permission_id, opts = {})
      data, _status_code, _headers = delete_permission_with_http_info(permission_id, opts)
      data
    end

    # Delete Permission
    # Delete permission  &lt;div&gt;   &lt;code&gt;delete:permissions&lt;/code&gt; &lt;/div&gt; 
    # @param permission_id [String] The identifier for the permission.
    # @param [Hash] opts the optional parameters
    # @return [Array<(SuccessResponse, Integer, Hash)>] SuccessResponse data, response status code and response headers
    def delete_permission_with_http_info(permission_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PermissionsApi.delete_permission ...'
      end
      # verify the required parameter 'permission_id' is set
      if @api_client.config.client_side_validation && permission_id.nil?
        fail ArgumentError, "Missing the required parameter 'permission_id' when calling PermissionsApi.delete_permission"
      end
      # resource path
      local_var_path = '/api/v1/permissions/{permission_id}'.sub('{' + 'permission_id' + '}', CGI.escape(permission_id.to_s))

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
        :operation => :"PermissionsApi.delete_permission",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PermissionsApi#delete_permission\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # List Permissions
    # The returned list can be sorted by permission name or permission ID in ascending or descending order. The number of records to return at a time can also be controlled using the `page_size` query string parameter.  <div>   <code>read:permissions</code> </div> 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :sort Field and order to sort the result by.
    # @option opts [Integer] :page_size Number of results per page. Defaults to 10 if parameter not sent.
    # @option opts [String] :next_token A string to get the next page of results if there are more results.
    # @return [GetPermissionsResponse]
    def get_permissions(opts = {})
      data, _status_code, _headers = get_permissions_with_http_info(opts)
      data
    end

    # List Permissions
    # The returned list can be sorted by permission name or permission ID in ascending or descending order. The number of records to return at a time can also be controlled using the &#x60;page_size&#x60; query string parameter.  &lt;div&gt;   &lt;code&gt;read:permissions&lt;/code&gt; &lt;/div&gt; 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :sort Field and order to sort the result by.
    # @option opts [Integer] :page_size Number of results per page. Defaults to 10 if parameter not sent.
    # @option opts [String] :next_token A string to get the next page of results if there are more results.
    # @return [Array<(GetPermissionsResponse, Integer, Hash)>] GetPermissionsResponse data, response status code and response headers
    def get_permissions_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PermissionsApi.get_permissions ...'
      end
      allowable_values = ["name_asc", "name_desc", "id_asc", "id_desc"]
      if @api_client.config.client_side_validation && opts[:'sort'] && !allowable_values.include?(opts[:'sort'])
        fail ArgumentError, "invalid value for \"sort\", must be one of #{allowable_values}"
      end
      # resource path
      local_var_path = '/api/v1/permissions'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'sort'] = opts[:'sort'] if !opts[:'sort'].nil?
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'next_token'] = opts[:'next_token'] if !opts[:'next_token'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'application/json; charset=utf-8'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'GetPermissionsResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"PermissionsApi.get_permissions",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PermissionsApi#get_permissions\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Update Permission
    # Update permission  <div>   <code>update:permissions</code> </div> 
    # @param permission_id [String] The identifier for the permission.
    # @param [Hash] opts the optional parameters
    # @option opts [CreatePermissionRequest] :create_permission_request Permission details.
    # @return [SuccessResponse]
    def update_permissions(permission_id, opts = {})
      data, _status_code, _headers = update_permissions_with_http_info(permission_id, opts)
      data
    end

    # Update Permission
    # Update permission  &lt;div&gt;   &lt;code&gt;update:permissions&lt;/code&gt; &lt;/div&gt; 
    # @param permission_id [String] The identifier for the permission.
    # @param [Hash] opts the optional parameters
    # @option opts [CreatePermissionRequest] :create_permission_request Permission details.
    # @return [Array<(SuccessResponse, Integer, Hash)>] SuccessResponse data, response status code and response headers
    def update_permissions_with_http_info(permission_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PermissionsApi.update_permissions ...'
      end
      # verify the required parameter 'permission_id' is set
      if @api_client.config.client_side_validation && permission_id.nil?
        fail ArgumentError, "Missing the required parameter 'permission_id' when calling PermissionsApi.update_permissions"
      end
      # resource path
      local_var_path = '/api/v1/permissions/{permission_id}'.sub('{' + 'permission_id' + '}', CGI.escape(permission_id.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8'])
      # HTTP header 'Content-Type'
      content_type = @api_client.select_header_content_type(['application/json'])
      if !content_type.nil?
          header_params['Content-Type'] = content_type
      end

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body] || @api_client.object_to_http_body(opts[:'create_permission_request'])

      # return_type
      return_type = opts[:debug_return_type] || 'SuccessResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"PermissionsApi.update_permissions",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PermissionsApi#update_permissions\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
