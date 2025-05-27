# KindeApi::RolesApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**add_role_scope**](RolesApi.md#add_role_scope) | **POST** /api/v1/roles/{role_id}/scopes | Add role scope |
| [**create_role**](RolesApi.md#create_role) | **POST** /api/v1/roles | Create role |
| [**delete_role**](RolesApi.md#delete_role) | **DELETE** /api/v1/roles/{role_id} | Delete role |
| [**delete_role_scope**](RolesApi.md#delete_role_scope) | **DELETE** /api/v1/roles/{role_id}/scopes/{scope_id} | Delete role scope |
| [**get_role**](RolesApi.md#get_role) | **GET** /api/v1/roles/{role_id} | Get role |
| [**get_role_permissions**](RolesApi.md#get_role_permissions) | **GET** /api/v1/roles/{role_id}/permissions | Get role permissions |
| [**get_role_scopes**](RolesApi.md#get_role_scopes) | **GET** /api/v1/roles/{role_id}/scopes | Get role scopes |
| [**get_roles**](RolesApi.md#get_roles) | **GET** /api/v1/roles | List roles |
| [**remove_role_permission**](RolesApi.md#remove_role_permission) | **DELETE** /api/v1/roles/{role_id}/permissions/{permission_id} | Remove role permission |
| [**update_role_permissions**](RolesApi.md#update_role_permissions) | **PATCH** /api/v1/roles/{role_id}/permissions | Update role permissions |
| [**update_roles**](RolesApi.md#update_roles) | **PATCH** /api/v1/roles/{role_id} | Update role |


## add_role_scope

> <AddRoleScopeResponse> add_role_scope(role_id, add_role_scope_request)

Add role scope

Add scope to role.  <div>   <code>create:role_scopes</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::RolesApi.new
role_id = 'role_id_example' # String | The role id.
add_role_scope_request = KindeApi::AddRoleScopeRequest.new({scope_id: 'scope_id_example'}) # AddRoleScopeRequest | Add scope to role.

begin
  # Add role scope
  result = api_instance.add_role_scope(role_id, add_role_scope_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->add_role_scope: #{e}"
end
```

#### Using the add_role_scope_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<AddRoleScopeResponse>, Integer, Hash)> add_role_scope_with_http_info(role_id, add_role_scope_request)

```ruby
begin
  # Add role scope
  data, status_code, headers = api_instance.add_role_scope_with_http_info(role_id, add_role_scope_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <AddRoleScopeResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->add_role_scope_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **role_id** | **String** | The role id. |  |
| **add_role_scope_request** | [**AddRoleScopeRequest**](AddRoleScopeRequest.md) | Add scope to role. |  |

### Return type

[**AddRoleScopeResponse**](AddRoleScopeResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## create_role

> <CreateRolesResponse> create_role(opts)

Create role

Create role.  <div>   <code>create:roles</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::RolesApi.new
opts = {
  create_role_request: KindeApi::CreateRoleRequest.new # CreateRoleRequest | Role details.
}

begin
  # Create role
  result = api_instance.create_role(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->create_role: #{e}"
end
```

#### Using the create_role_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateRolesResponse>, Integer, Hash)> create_role_with_http_info(opts)

```ruby
begin
  # Create role
  data, status_code, headers = api_instance.create_role_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateRolesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->create_role_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_role_request** | [**CreateRoleRequest**](CreateRoleRequest.md) | Role details. | [optional] |

### Return type

[**CreateRolesResponse**](CreateRolesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## delete_role

> <SuccessResponse> delete_role(role_id)

Delete role

Delete role  <div>   <code>delete:roles</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::RolesApi.new
role_id = 'role_id_example' # String | The identifier for the role.

begin
  # Delete role
  result = api_instance.delete_role(role_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->delete_role: #{e}"
end
```

#### Using the delete_role_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_role_with_http_info(role_id)

```ruby
begin
  # Delete role
  data, status_code, headers = api_instance.delete_role_with_http_info(role_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->delete_role_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **role_id** | **String** | The identifier for the role. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## delete_role_scope

> <DeleteRoleScopeResponse> delete_role_scope(role_id, scope_id)

Delete role scope

Delete scope from role.  <div>   <code>delete:role_scopes</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::RolesApi.new
role_id = 'role_id_example' # String | The role id.
scope_id = 'scope_id_example' # String | The scope id.

begin
  # Delete role scope
  result = api_instance.delete_role_scope(role_id, scope_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->delete_role_scope: #{e}"
end
```

#### Using the delete_role_scope_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<DeleteRoleScopeResponse>, Integer, Hash)> delete_role_scope_with_http_info(role_id, scope_id)

```ruby
begin
  # Delete role scope
  data, status_code, headers = api_instance.delete_role_scope_with_http_info(role_id, scope_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <DeleteRoleScopeResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->delete_role_scope_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **role_id** | **String** | The role id. |  |
| **scope_id** | **String** | The scope id. |  |

### Return type

[**DeleteRoleScopeResponse**](DeleteRoleScopeResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_role

> <GetRoleResponse> get_role(role_id)

Get role

Get a role  <div>   <code>read:roles</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::RolesApi.new
role_id = 'role_id_example' # String | The identifier for the role.

begin
  # Get role
  result = api_instance.get_role(role_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->get_role: #{e}"
end
```

#### Using the get_role_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetRoleResponse>, Integer, Hash)> get_role_with_http_info(role_id)

```ruby
begin
  # Get role
  data, status_code, headers = api_instance.get_role_with_http_info(role_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetRoleResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->get_role_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **role_id** | **String** | The identifier for the role. |  |

### Return type

[**GetRoleResponse**](GetRoleResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_role_permissions

> <RolePermissionsResponse> get_role_permissions(role_id, opts)

Get role permissions

Get permissions for a role.  <div>   <code>read:role_permissions</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::RolesApi.new
role_id = 'role_id_example' # String | The role's public id.
opts = {
  sort: 'name_asc', # String | Field and order to sort the result by.
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  next_token: 'next_token_example' # String | A string to get the next page of results if there are more results.
}

begin
  # Get role permissions
  result = api_instance.get_role_permissions(role_id, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->get_role_permissions: #{e}"
end
```

#### Using the get_role_permissions_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<RolePermissionsResponse>, Integer, Hash)> get_role_permissions_with_http_info(role_id, opts)

```ruby
begin
  # Get role permissions
  data, status_code, headers = api_instance.get_role_permissions_with_http_info(role_id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <RolePermissionsResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->get_role_permissions_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **role_id** | **String** | The role&#39;s public id. |  |
| **sort** | **String** | Field and order to sort the result by. | [optional] |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **next_token** | **String** | A string to get the next page of results if there are more results. | [optional] |

### Return type

[**RolePermissionsResponse**](RolePermissionsResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_role_scopes

> <RoleScopesResponse> get_role_scopes(role_id)

Get role scopes

Get scopes for a role.  <div>   <code>read:role_scopes</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::RolesApi.new
role_id = 'role_id_example' # String | The role id.

begin
  # Get role scopes
  result = api_instance.get_role_scopes(role_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->get_role_scopes: #{e}"
end
```

#### Using the get_role_scopes_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<RoleScopesResponse>, Integer, Hash)> get_role_scopes_with_http_info(role_id)

```ruby
begin
  # Get role scopes
  data, status_code, headers = api_instance.get_role_scopes_with_http_info(role_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <RoleScopesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->get_role_scopes_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **role_id** | **String** | The role id. |  |

### Return type

[**RoleScopesResponse**](RoleScopesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_roles

> <GetRolesResponse> get_roles(opts)

List roles

The returned list can be sorted by role name or role ID in ascending or descending order. The number of records to return at a time can also be controlled using the `page_size` query string parameter.  <div>   <code>read:roles</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::RolesApi.new
opts = {
  sort: 'name_asc', # String | Field and order to sort the result by.
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  next_token: 'next_token_example' # String | A string to get the next page of results if there are more results.
}

begin
  # List roles
  result = api_instance.get_roles(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->get_roles: #{e}"
end
```

#### Using the get_roles_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetRolesResponse>, Integer, Hash)> get_roles_with_http_info(opts)

```ruby
begin
  # List roles
  data, status_code, headers = api_instance.get_roles_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetRolesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->get_roles_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **sort** | **String** | Field and order to sort the result by. | [optional] |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **next_token** | **String** | A string to get the next page of results if there are more results. | [optional] |

### Return type

[**GetRolesResponse**](GetRolesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## remove_role_permission

> <SuccessResponse> remove_role_permission(role_id, permission_id)

Remove role permission

Remove a permission from a role.  <div>   <code>delete:role_permissions</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::RolesApi.new
role_id = 'role_id_example' # String | The role's public id.
permission_id = 'permission_id_example' # String | The permission's public id.

begin
  # Remove role permission
  result = api_instance.remove_role_permission(role_id, permission_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->remove_role_permission: #{e}"
end
```

#### Using the remove_role_permission_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> remove_role_permission_with_http_info(role_id, permission_id)

```ruby
begin
  # Remove role permission
  data, status_code, headers = api_instance.remove_role_permission_with_http_info(role_id, permission_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->remove_role_permission_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **role_id** | **String** | The role&#39;s public id. |  |
| **permission_id** | **String** | The permission&#39;s public id. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## update_role_permissions

> <UpdateRolePermissionsResponse> update_role_permissions(role_id, update_role_permissions_request)

Update role permissions

Update role permissions.  <div>   <code>update:role_permissions</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::RolesApi.new
role_id = 'role_id_example' # String | The identifier for the role.
update_role_permissions_request = KindeApi::UpdateRolePermissionsRequest.new # UpdateRolePermissionsRequest | 

begin
  # Update role permissions
  result = api_instance.update_role_permissions(role_id, update_role_permissions_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->update_role_permissions: #{e}"
end
```

#### Using the update_role_permissions_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<UpdateRolePermissionsResponse>, Integer, Hash)> update_role_permissions_with_http_info(role_id, update_role_permissions_request)

```ruby
begin
  # Update role permissions
  data, status_code, headers = api_instance.update_role_permissions_with_http_info(role_id, update_role_permissions_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <UpdateRolePermissionsResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->update_role_permissions_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **role_id** | **String** | The identifier for the role. |  |
| **update_role_permissions_request** | [**UpdateRolePermissionsRequest**](UpdateRolePermissionsRequest.md) |  |  |

### Return type

[**UpdateRolePermissionsResponse**](UpdateRolePermissionsResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## update_roles

> <SuccessResponse> update_roles(role_id, opts)

Update role

Update a role  <div>   <code>update:roles</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::RolesApi.new
role_id = 'role_id_example' # String | The identifier for the role.
opts = {
  update_roles_request: KindeApi::UpdateRolesRequest.new({name: 'name_example', key: 'key_example'}) # UpdateRolesRequest | Role details.
}

begin
  # Update role
  result = api_instance.update_roles(role_id, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->update_roles: #{e}"
end
```

#### Using the update_roles_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_roles_with_http_info(role_id, opts)

```ruby
begin
  # Update role
  data, status_code, headers = api_instance.update_roles_with_http_info(role_id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->update_roles_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **role_id** | **String** | The identifier for the role. |  |
| **update_roles_request** | [**UpdateRolesRequest**](UpdateRolesRequest.md) | Role details. | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

