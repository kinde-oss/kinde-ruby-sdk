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
  class RolesApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Add role scope
    # Add scope to role.  <div>   <code>create:role_scopes</code> </div> 
    # @param role_id [String] The role id.
    # @param add_role_scope_request [AddRoleScopeRequest] Add scope to role.
    # @param [Hash] opts the optional parameters
    # @return [AddRoleScopeResponse]
    def add_role_scope(role_id, add_role_scope_request, opts = {})
      data, _status_code, _headers = add_role_scope_with_http_info(role_id, add_role_scope_request, opts)
      data
    end

    # Add role scope
    # Add scope to role.  &lt;div&gt;   &lt;code&gt;create:role_scopes&lt;/code&gt; &lt;/div&gt; 
    # @param role_id [String] The role id.
    # @param add_role_scope_request [AddRoleScopeRequest] Add scope to role.
    # @param [Hash] opts the optional parameters
    # @return [Array<(AddRoleScopeResponse, Integer, Hash)>] AddRoleScopeResponse data, response status code and response headers
    def add_role_scope_with_http_info(role_id, add_role_scope_request, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: RolesApi.add_role_scope ...'
      end
      # verify the required parameter 'role_id' is set
      if @api_client.config.client_side_validation && role_id.nil?
        fail ArgumentError, "Missing the required parameter 'role_id' when calling RolesApi.add_role_scope"
      end
      # verify the required parameter 'add_role_scope_request' is set
      if @api_client.config.client_side_validation && add_role_scope_request.nil?
        fail ArgumentError, "Missing the required parameter 'add_role_scope_request' when calling RolesApi.add_role_scope"
      end
      # resource path
      local_var_path = '/api/v1/roles/{role_id}/scopes'.sub('{' + 'role_id' + '}', CGI.escape(role_id.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      content_type = @api_client.select_header_content_type(['application/json'])
      if !content_type.nil?
          header_params['Content-Type'] = content_type
      end

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body] || @api_client.object_to_http_body(add_role_scope_request)

      # return_type
      return_type = opts[:debug_return_type] || 'AddRoleScopeResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"RolesApi.add_role_scope",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:POST, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: RolesApi#add_role_scope\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Create role
    # Create role.  <div>   <code>create:roles</code> </div> 
    # @param [Hash] opts the optional parameters
    # @option opts [CreateRoleRequest] :create_role_request Role details.
    # @return [CreateRolesResponse]
    def create_role(opts = {})
      data, _status_code, _headers = create_role_with_http_info(opts)
      data
    end

    # Create role
    # Create role.  &lt;div&gt;   &lt;code&gt;create:roles&lt;/code&gt; &lt;/div&gt; 
    # @param [Hash] opts the optional parameters
    # @option opts [CreateRoleRequest] :create_role_request Role details.
    # @return [Array<(CreateRolesResponse, Integer, Hash)>] CreateRolesResponse data, response status code and response headers
    def create_role_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: RolesApi.create_role ...'
      end
      # resource path
      local_var_path = '/api/v1/roles'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      content_type = @api_client.select_header_content_type(['application/json'])
      if !content_type.nil?
          header_params['Content-Type'] = content_type
      end

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body] || @api_client.object_to_http_body(opts[:'create_role_request'])

      # return_type
      return_type = opts[:debug_return_type] || 'CreateRolesResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"RolesApi.create_role",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:POST, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: RolesApi#create_role\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Delete role
    # Delete role  <div>   <code>delete:roles</code> </div> 
    # @param role_id [String] The identifier for the role.
    # @param [Hash] opts the optional parameters
    # @return [SuccessResponse]
    def delete_role(role_id, opts = {})
      data, _status_code, _headers = delete_role_with_http_info(role_id, opts)
      data
    end

    # Delete role
    # Delete role  &lt;div&gt;   &lt;code&gt;delete:roles&lt;/code&gt; &lt;/div&gt; 
    # @param role_id [String] The identifier for the role.
    # @param [Hash] opts the optional parameters
    # @return [Array<(SuccessResponse, Integer, Hash)>] SuccessResponse data, response status code and response headers
    def delete_role_with_http_info(role_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: RolesApi.delete_role ...'
      end
      # verify the required parameter 'role_id' is set
      if @api_client.config.client_side_validation && role_id.nil?
        fail ArgumentError, "Missing the required parameter 'role_id' when calling RolesApi.delete_role"
      end
      # resource path
      local_var_path = '/api/v1/roles/{role_id}'.sub('{' + 'role_id' + '}', CGI.escape(role_id.to_s))

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
        :operation => :"RolesApi.delete_role",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: RolesApi#delete_role\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Delete role scope
    # Delete scope from role.  <div>   <code>delete:role_scopes</code> </div> 
    # @param role_id [String] The role id.
    # @param scope_id [String] The scope id.
    # @param [Hash] opts the optional parameters
    # @return [DeleteRoleScopeResponse]
    def delete_role_scope(role_id, scope_id, opts = {})
      data, _status_code, _headers = delete_role_scope_with_http_info(role_id, scope_id, opts)
      data
    end

    # Delete role scope
    # Delete scope from role.  &lt;div&gt;   &lt;code&gt;delete:role_scopes&lt;/code&gt; &lt;/div&gt; 
    # @param role_id [String] The role id.
    # @param scope_id [String] The scope id.
    # @param [Hash] opts the optional parameters
    # @return [Array<(DeleteRoleScopeResponse, Integer, Hash)>] DeleteRoleScopeResponse data, response status code and response headers
    def delete_role_scope_with_http_info(role_id, scope_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: RolesApi.delete_role_scope ...'
      end
      # verify the required parameter 'role_id' is set
      if @api_client.config.client_side_validation && role_id.nil?
        fail ArgumentError, "Missing the required parameter 'role_id' when calling RolesApi.delete_role_scope"
      end
      # verify the required parameter 'scope_id' is set
      if @api_client.config.client_side_validation && scope_id.nil?
        fail ArgumentError, "Missing the required parameter 'scope_id' when calling RolesApi.delete_role_scope"
      end
      # resource path
      local_var_path = '/api/v1/roles/{role_id}/scopes/{scope_id}'.sub('{' + 'role_id' + '}', CGI.escape(role_id.to_s)).sub('{' + 'scope_id' + '}', CGI.escape(scope_id.to_s))

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
      return_type = opts[:debug_return_type] || 'DeleteRoleScopeResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"RolesApi.delete_role_scope",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: RolesApi#delete_role_scope\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Get role
    # Get a role  <div>   <code>read:roles</code> </div> 
    # @param role_id [String] The identifier for the role.
    # @param [Hash] opts the optional parameters
    # @return [GetRoleResponse]
    def get_role(role_id, opts = {})
      data, _status_code, _headers = get_role_with_http_info(role_id, opts)
      data
    end

    # Get role
    # Get a role  &lt;div&gt;   &lt;code&gt;read:roles&lt;/code&gt; &lt;/div&gt; 
    # @param role_id [String] The identifier for the role.
    # @param [Hash] opts the optional parameters
    # @return [Array<(GetRoleResponse, Integer, Hash)>] GetRoleResponse data, response status code and response headers
    def get_role_with_http_info(role_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: RolesApi.get_role ...'
      end
      # verify the required parameter 'role_id' is set
      if @api_client.config.client_side_validation && role_id.nil?
        fail ArgumentError, "Missing the required parameter 'role_id' when calling RolesApi.get_role"
      end
      # resource path
      local_var_path = '/api/v1/roles/{role_id}'.sub('{' + 'role_id' + '}', CGI.escape(role_id.to_s))

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
      return_type = opts[:debug_return_type] || 'GetRoleResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"RolesApi.get_role",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: RolesApi#get_role\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Get role permissions
    # Get permissions for a role.  <div>   <code>read:role_permissions</code> </div> 
    # @param role_id [String] The role&#39;s public id.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :sort Field and order to sort the result by.
    # @option opts [Integer] :page_size Number of results per page. Defaults to 10 if parameter not sent.
    # @option opts [String] :next_token A string to get the next page of results if there are more results.
    # @return [RolePermissionsResponse]
    def get_role_permissions(role_id, opts = {})
      data, _status_code, _headers = get_role_permissions_with_http_info(role_id, opts)
      data
    end

    # Get role permissions
    # Get permissions for a role.  &lt;div&gt;   &lt;code&gt;read:role_permissions&lt;/code&gt; &lt;/div&gt; 
    # @param role_id [String] The role&#39;s public id.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :sort Field and order to sort the result by.
    # @option opts [Integer] :page_size Number of results per page. Defaults to 10 if parameter not sent.
    # @option opts [String] :next_token A string to get the next page of results if there are more results.
    # @return [Array<(RolePermissionsResponse, Integer, Hash)>] RolePermissionsResponse data, response status code and response headers
    def get_role_permissions_with_http_info(role_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: RolesApi.get_role_permissions ...'
      end
      # verify the required parameter 'role_id' is set
      if @api_client.config.client_side_validation && role_id.nil?
        fail ArgumentError, "Missing the required parameter 'role_id' when calling RolesApi.get_role_permissions"
      end
      allowable_values = ["name_asc", "name_desc", "id_asc", "id_desc"]
      if @api_client.config.client_side_validation && opts[:'sort'] && !allowable_values.include?(opts[:'sort'])
        fail ArgumentError, "invalid value for \"sort\", must be one of #{allowable_values}"
      end
      # resource path
      local_var_path = '/api/v1/roles/{role_id}/permissions'.sub('{' + 'role_id' + '}', CGI.escape(role_id.to_s))

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
      return_type = opts[:debug_return_type] || 'RolePermissionsResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"RolesApi.get_role_permissions",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: RolesApi#get_role_permissions\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Get role scopes
    # Get scopes for a role.  <div>   <code>read:role_scopes</code> </div> 
    # @param role_id [String] The role id.
    # @param [Hash] opts the optional parameters
    # @return [RoleScopesResponse]
    def get_role_scopes(role_id, opts = {})
      data, _status_code, _headers = get_role_scopes_with_http_info(role_id, opts)
      data
    end

    # Get role scopes
    # Get scopes for a role.  &lt;div&gt;   &lt;code&gt;read:role_scopes&lt;/code&gt; &lt;/div&gt; 
    # @param role_id [String] The role id.
    # @param [Hash] opts the optional parameters
    # @return [Array<(RoleScopesResponse, Integer, Hash)>] RoleScopesResponse data, response status code and response headers
    def get_role_scopes_with_http_info(role_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: RolesApi.get_role_scopes ...'
      end
      # verify the required parameter 'role_id' is set
      if @api_client.config.client_side_validation && role_id.nil?
        fail ArgumentError, "Missing the required parameter 'role_id' when calling RolesApi.get_role_scopes"
      end
      # resource path
      local_var_path = '/api/v1/roles/{role_id}/scopes'.sub('{' + 'role_id' + '}', CGI.escape(role_id.to_s))

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
      return_type = opts[:debug_return_type] || 'RoleScopesResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"RolesApi.get_role_scopes",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: RolesApi#get_role_scopes\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # List roles
    # The returned list can be sorted by role name or role ID in ascending or descending order. The number of records to return at a time can also be controlled using the `page_size` query string parameter.  <div>   <code>read:roles</code> </div> 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :sort Field and order to sort the result by.
    # @option opts [Integer] :page_size Number of results per page. Defaults to 10 if parameter not sent.
    # @option opts [String] :next_token A string to get the next page of results if there are more results.
    # @return [GetRolesResponse]
    def get_roles(opts = {})
      data, _status_code, _headers = get_roles_with_http_info(opts)
      data
    end

    # List roles
    # The returned list can be sorted by role name or role ID in ascending or descending order. The number of records to return at a time can also be controlled using the &#x60;page_size&#x60; query string parameter.  &lt;div&gt;   &lt;code&gt;read:roles&lt;/code&gt; &lt;/div&gt; 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :sort Field and order to sort the result by.
    # @option opts [Integer] :page_size Number of results per page. Defaults to 10 if parameter not sent.
    # @option opts [String] :next_token A string to get the next page of results if there are more results.
    # @return [Array<(GetRolesResponse, Integer, Hash)>] GetRolesResponse data, response status code and response headers
    def get_roles_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: RolesApi.get_roles ...'
      end
      allowable_values = ["name_asc", "name_desc", "id_asc", "id_desc"]
      if @api_client.config.client_side_validation && opts[:'sort'] && !allowable_values.include?(opts[:'sort'])
        fail ArgumentError, "invalid value for \"sort\", must be one of #{allowable_values}"
      end
      # resource path
      local_var_path = '/api/v1/roles'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'sort'] = opts[:'sort'] if !opts[:'sort'].nil?
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'next_token'] = opts[:'next_token'] if !opts[:'next_token'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'GetRolesResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"RolesApi.get_roles",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: RolesApi#get_roles\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Remove role permission
    # Remove a permission from a role.  <div>   <code>delete:role_permissions</code> </div> 
    # @param role_id [String] The role&#39;s public id.
    # @param permission_id [String] The permission&#39;s public id.
    # @param [Hash] opts the optional parameters
    # @return [SuccessResponse]
    def remove_role_permission(role_id, permission_id, opts = {})
      data, _status_code, _headers = remove_role_permission_with_http_info(role_id, permission_id, opts)
      data
    end

    # Remove role permission
    # Remove a permission from a role.  &lt;div&gt;   &lt;code&gt;delete:role_permissions&lt;/code&gt; &lt;/div&gt; 
    # @param role_id [String] The role&#39;s public id.
    # @param permission_id [String] The permission&#39;s public id.
    # @param [Hash] opts the optional parameters
    # @return [Array<(SuccessResponse, Integer, Hash)>] SuccessResponse data, response status code and response headers
    def remove_role_permission_with_http_info(role_id, permission_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: RolesApi.remove_role_permission ...'
      end
      # verify the required parameter 'role_id' is set
      if @api_client.config.client_side_validation && role_id.nil?
        fail ArgumentError, "Missing the required parameter 'role_id' when calling RolesApi.remove_role_permission"
      end
      # verify the required parameter 'permission_id' is set
      if @api_client.config.client_side_validation && permission_id.nil?
        fail ArgumentError, "Missing the required parameter 'permission_id' when calling RolesApi.remove_role_permission"
      end
      # resource path
      local_var_path = '/api/v1/roles/{role_id}/permissions/{permission_id}'.sub('{' + 'role_id' + '}', CGI.escape(role_id.to_s)).sub('{' + 'permission_id' + '}', CGI.escape(permission_id.to_s))

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
        :operation => :"RolesApi.remove_role_permission",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: RolesApi#remove_role_permission\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Update role permissions
    # Update role permissions.  <div>   <code>update:role_permissions</code> </div> 
    # @param role_id [String] The identifier for the role.
    # @param update_role_permissions_request [UpdateRolePermissionsRequest] 
    # @param [Hash] opts the optional parameters
    # @return [UpdateRolePermissionsResponse]
    def update_role_permissions(role_id, update_role_permissions_request, opts = {})
      data, _status_code, _headers = update_role_permissions_with_http_info(role_id, update_role_permissions_request, opts)
      data
    end

    # Update role permissions
    # Update role permissions.  &lt;div&gt;   &lt;code&gt;update:role_permissions&lt;/code&gt; &lt;/div&gt; 
    # @param role_id [String] The identifier for the role.
    # @param update_role_permissions_request [UpdateRolePermissionsRequest] 
    # @param [Hash] opts the optional parameters
    # @return [Array<(UpdateRolePermissionsResponse, Integer, Hash)>] UpdateRolePermissionsResponse data, response status code and response headers
    def update_role_permissions_with_http_info(role_id, update_role_permissions_request, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: RolesApi.update_role_permissions ...'
      end
      # verify the required parameter 'role_id' is set
      if @api_client.config.client_side_validation && role_id.nil?
        fail ArgumentError, "Missing the required parameter 'role_id' when calling RolesApi.update_role_permissions"
      end
      # verify the required parameter 'update_role_permissions_request' is set
      if @api_client.config.client_side_validation && update_role_permissions_request.nil?
        fail ArgumentError, "Missing the required parameter 'update_role_permissions_request' when calling RolesApi.update_role_permissions"
      end
      # resource path
      local_var_path = '/api/v1/roles/{role_id}/permissions'.sub('{' + 'role_id' + '}', CGI.escape(role_id.to_s))

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
      post_body = opts[:debug_body] || @api_client.object_to_http_body(update_role_permissions_request)

      # return_type
      return_type = opts[:debug_return_type] || 'UpdateRolePermissionsResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"RolesApi.update_role_permissions",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: RolesApi#update_role_permissions\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Update role
    # Update a role  <div>   <code>update:roles</code> </div> 
    # @param role_id [String] The identifier for the role.
    # @param [Hash] opts the optional parameters
    # @option opts [UpdateRolesRequest] :update_roles_request Role details.
    # @return [SuccessResponse]
    def update_roles(role_id, opts = {})
      data, _status_code, _headers = update_roles_with_http_info(role_id, opts)
      data
    end

    # Update role
    # Update a role  &lt;div&gt;   &lt;code&gt;update:roles&lt;/code&gt; &lt;/div&gt; 
    # @param role_id [String] The identifier for the role.
    # @param [Hash] opts the optional parameters
    # @option opts [UpdateRolesRequest] :update_roles_request Role details.
    # @return [Array<(SuccessResponse, Integer, Hash)>] SuccessResponse data, response status code and response headers
    def update_roles_with_http_info(role_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: RolesApi.update_roles ...'
      end
      # verify the required parameter 'role_id' is set
      if @api_client.config.client_side_validation && role_id.nil?
        fail ArgumentError, "Missing the required parameter 'role_id' when calling RolesApi.update_roles"
      end
      # resource path
      local_var_path = '/api/v1/roles/{role_id}'.sub('{' + 'role_id' + '}', CGI.escape(role_id.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      content_type = @api_client.select_header_content_type(['application/json'])
      if !content_type.nil?
          header_params['Content-Type'] = content_type
      end

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body] || @api_client.object_to_http_body(opts[:'update_roles_request'])

      # return_type
      return_type = opts[:debug_return_type] || 'SuccessResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"RolesApi.update_roles",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: RolesApi#update_roles\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
