# KindeApi::RolesApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_role**](RolesApi.md#create_role) | **POST** /api/v1/role | Create Role |
| [**delete_role**](RolesApi.md#delete_role) | **DELETE** /api/v1/roles/{role_id} | Delete Role |
| [**get_role_permission**](RolesApi.md#get_role_permission) | **GET** /api/v1/roles/{role_id}/permissions | Get Role Permissions |
| [**get_roles**](RolesApi.md#get_roles) | **GET** /api/v1/roles | List Roles |
| [**remove_role_permission**](RolesApi.md#remove_role_permission) | **DELETE** /api/v1/roles/{role_id}/permissions/{permission_id} | Remove Role Permission |
| [**update_role_permissions**](RolesApi.md#update_role_permissions) | **PATCH** /api/v1/roles/{role_id}/permissions | Update Role Permissions |
| [**update_roles**](RolesApi.md#update_roles) | **PATCH** /api/v1/roles/{role_id} | Update Role |


## create_role

> <SuccessResponse> create_role(opts)

Create Role

Create role.

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
  # Create Role
  result = api_instance.create_role(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->create_role: #{e}"
end
```

#### Using the create_role_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> create_role_with_http_info(opts)

```ruby
begin
  # Create Role
  data, status_code, headers = api_instance.create_role_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->create_role_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_role_request** | [**CreateRoleRequest**](CreateRoleRequest.md) | Role details. | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json; charset=utf-8


## delete_role

> <SuccessResponse> delete_role(role_id)

Delete Role

Delete role

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
  # Delete Role
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
  # Delete Role
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
- **Accept**: application/json, application/json; charset=utf-8


## get_role_permission

> <Array<RolesPermissionResponseInner>> get_role_permission(role_id, opts)

Get Role Permissions

Get permissions for a role.

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
  # Get Role Permissions
  result = api_instance.get_role_permission(role_id, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->get_role_permission: #{e}"
end
```

#### Using the get_role_permission_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Array<RolesPermissionResponseInner>>, Integer, Hash)> get_role_permission_with_http_info(role_id, opts)

```ruby
begin
  # Get Role Permissions
  data, status_code, headers = api_instance.get_role_permission_with_http_info(role_id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Array<RolesPermissionResponseInner>>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->get_role_permission_with_http_info: #{e}"
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

[**Array&lt;RolesPermissionResponseInner&gt;**](RolesPermissionResponseInner.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_roles

> <GetRolesResponse> get_roles(opts)

List Roles

The returned list can be sorted by role name or role ID in ascending or descending order. The number of records to return at a time can also be controlled using the `page_size` query string parameter. 

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
  # List Roles
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
  # List Roles
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
- **Accept**: application/json, application/json; charset=utf-8


## remove_role_permission

> <SuccessResponse> remove_role_permission(role_id, permission_id)

Remove Role Permission

Remove a permission from a role.

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
  # Remove Role Permission
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
  # Remove Role Permission
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

Update Role Permissions

Update role permissions. 

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
  # Update Role Permissions
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
  # Update Role Permissions
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

Update Role

Update a role

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
  # Update Role
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
  # Update Role
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
- **Accept**: application/json; charset=utf-8

