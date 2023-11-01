# KindeApi::OrganizationsApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**add_organization_users**](OrganizationsApi.md#add_organization_users) | **POST** /api/v1/organizations/{org_code}/users | Add Organization Users |
| [**create_organization**](OrganizationsApi.md#create_organization) | **POST** /api/v1/organization | Create Organization |
| [**create_organization_user_permission**](OrganizationsApi.md#create_organization_user_permission) | **POST** /api/v1/organizations/{org_code}/users/{user_id}/permissions | Add Organization User Permission |
| [**create_organization_user_role**](OrganizationsApi.md#create_organization_user_role) | **POST** /api/v1/organizations/{org_code}/users/{user_id}/roles | Add Organization User Role |
| [**delete_organization**](OrganizationsApi.md#delete_organization) | **DELETE** /api/v1/organization/{org_code} | Delete Organization |
| [**delete_organization_feature_flag_override**](OrganizationsApi.md#delete_organization_feature_flag_override) | **DELETE** /api/v1/organizations/{org_code}/feature_flags/{feature_flag_key} | Delete Organization Feature Flag Override |
| [**delete_organization_feature_flag_overrides**](OrganizationsApi.md#delete_organization_feature_flag_overrides) | **DELETE** /api/v1/organizations/{org_code}/feature_flags | Delete Organization Feature Flag Overrides |
| [**delete_organization_user_permission**](OrganizationsApi.md#delete_organization_user_permission) | **DELETE** /api/v1/organizations/{org_code}/users/{user_id}/permissions/{permission_id} | Delete Organization User Permission |
| [**delete_organization_user_role**](OrganizationsApi.md#delete_organization_user_role) | **DELETE** /api/v1/organizations/{org_code}/users/{user_id}/roles/{role_id} | Delete Organization User Role |
| [**get_organization**](OrganizationsApi.md#get_organization) | **GET** /api/v1/organization | Get Organization |
| [**get_organization_feature_flags**](OrganizationsApi.md#get_organization_feature_flags) | **GET** /api/v1/organizations/{org_code}/feature_flags | List Organization Feature Flags |
| [**get_organization_user_permissions**](OrganizationsApi.md#get_organization_user_permissions) | **GET** /api/v1/organizations/{org_code}/users/{user_id}/permissions | List Organization User Permissions |
| [**get_organization_user_roles**](OrganizationsApi.md#get_organization_user_roles) | **GET** /api/v1/organizations/{org_code}/users/{user_id}/roles | List Organization User Roles |
| [**get_organization_users**](OrganizationsApi.md#get_organization_users) | **GET** /api/v1/organizations/{org_code}/users | List Organization Users |
| [**get_organizations**](OrganizationsApi.md#get_organizations) | **GET** /api/v1/organizations | List Organizations |
| [**remove_organization_user**](OrganizationsApi.md#remove_organization_user) | **DELETE** /api/v1/organizations/{org_code}/users/{user_id} | Remove Organization User |
| [**update_organization**](OrganizationsApi.md#update_organization) | **PATCH** /api/v1/organization/{org_code} | Update Organization |
| [**update_organization_feature_flag_override**](OrganizationsApi.md#update_organization_feature_flag_override) | **PATCH** /api/v1/organizations/{org_code}/feature_flags/{feature_flag_key} | Update Organization Feature Flag Override |
| [**update_organization_users**](OrganizationsApi.md#update_organization_users) | **PATCH** /api/v1/organizations/{org_code}/users | Update Organization Users |


## add_organization_users

> <AddOrganizationUsersResponse> add_organization_users(org_code, opts)

Add Organization Users

Add existing users to an organization.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The organization's code.
opts = {
  add_organization_users_request: KindeApi::AddOrganizationUsersRequest.new # AddOrganizationUsersRequest | 
}

begin
  # Add Organization Users
  result = api_instance.add_organization_users(org_code, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->add_organization_users: #{e}"
end
```

#### Using the add_organization_users_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<AddOrganizationUsersResponse>, Integer, Hash)> add_organization_users_with_http_info(org_code, opts)

```ruby
begin
  # Add Organization Users
  data, status_code, headers = api_instance.add_organization_users_with_http_info(org_code, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <AddOrganizationUsersResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->add_organization_users_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |
| **add_organization_users_request** | [**AddOrganizationUsersRequest**](AddOrganizationUsersRequest.md) |  | [optional] |

### Return type

[**AddOrganizationUsersResponse**](AddOrganizationUsersResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## create_organization

> <CreateOrganizationResponse> create_organization(opts)

Create Organization

Create an organization.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
opts = {
  create_organization_request: KindeApi::CreateOrganizationRequest.new # CreateOrganizationRequest | Organization details.
}

begin
  # Create Organization
  result = api_instance.create_organization(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->create_organization: #{e}"
end
```

#### Using the create_organization_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateOrganizationResponse>, Integer, Hash)> create_organization_with_http_info(opts)

```ruby
begin
  # Create Organization
  data, status_code, headers = api_instance.create_organization_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateOrganizationResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->create_organization_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_organization_request** | [**CreateOrganizationRequest**](CreateOrganizationRequest.md) | Organization details. | [optional] |

### Return type

[**CreateOrganizationResponse**](CreateOrganizationResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## create_organization_user_permission

> <SuccessResponse> create_organization_user_permission(org_code, user_id, create_organization_user_permission_request)

Add Organization User Permission

Add permission to an organization user.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The organization's code.
user_id = 'user_id_example' # String | The user's id.
create_organization_user_permission_request = KindeApi::CreateOrganizationUserPermissionRequest.new # CreateOrganizationUserPermissionRequest | Permission details.

begin
  # Add Organization User Permission
  result = api_instance.create_organization_user_permission(org_code, user_id, create_organization_user_permission_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->create_organization_user_permission: #{e}"
end
```

#### Using the create_organization_user_permission_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> create_organization_user_permission_with_http_info(org_code, user_id, create_organization_user_permission_request)

```ruby
begin
  # Add Organization User Permission
  data, status_code, headers = api_instance.create_organization_user_permission_with_http_info(org_code, user_id, create_organization_user_permission_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->create_organization_user_permission_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |
| **user_id** | **String** | The user&#39;s id. |  |
| **create_organization_user_permission_request** | [**CreateOrganizationUserPermissionRequest**](CreateOrganizationUserPermissionRequest.md) | Permission details. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## create_organization_user_role

> <SuccessResponse> create_organization_user_role(org_code, user_id, create_organization_user_role_request)

Add Organization User Role

Add role to an organization user.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The organization's code.
user_id = 'user_id_example' # String | The user's id.
create_organization_user_role_request = KindeApi::CreateOrganizationUserRoleRequest.new # CreateOrganizationUserRoleRequest | Role details.

begin
  # Add Organization User Role
  result = api_instance.create_organization_user_role(org_code, user_id, create_organization_user_role_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->create_organization_user_role: #{e}"
end
```

#### Using the create_organization_user_role_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> create_organization_user_role_with_http_info(org_code, user_id, create_organization_user_role_request)

```ruby
begin
  # Add Organization User Role
  data, status_code, headers = api_instance.create_organization_user_role_with_http_info(org_code, user_id, create_organization_user_role_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->create_organization_user_role_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |
| **user_id** | **String** | The user&#39;s id. |  |
| **create_organization_user_role_request** | [**CreateOrganizationUserRoleRequest**](CreateOrganizationUserRoleRequest.md) | Role details. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## delete_organization

> delete_organization(org_code)

Delete Organization

Delete an organization.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The identifier for the organization.

begin
  # Delete Organization
  api_instance.delete_organization(org_code)
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization: #{e}"
end
```

#### Using the delete_organization_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> delete_organization_with_http_info(org_code)

```ruby
begin
  # Delete Organization
  data, status_code, headers = api_instance.delete_organization_with_http_info(org_code)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The identifier for the organization. |  |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## delete_organization_feature_flag_override

> <SuccessResponse> delete_organization_feature_flag_override(org_code, feature_flag_key)

Delete Organization Feature Flag Override

Delete organization feature flag override.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The identifier for the organization.
feature_flag_key = 'feature_flag_key_example' # String | The identifier for the feature flag.

begin
  # Delete Organization Feature Flag Override
  result = api_instance.delete_organization_feature_flag_override(org_code, feature_flag_key)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_feature_flag_override: #{e}"
end
```

#### Using the delete_organization_feature_flag_override_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_organization_feature_flag_override_with_http_info(org_code, feature_flag_key)

```ruby
begin
  # Delete Organization Feature Flag Override
  data, status_code, headers = api_instance.delete_organization_feature_flag_override_with_http_info(org_code, feature_flag_key)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_feature_flag_override_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The identifier for the organization. |  |
| **feature_flag_key** | **String** | The identifier for the feature flag. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## delete_organization_feature_flag_overrides

> <SuccessResponse> delete_organization_feature_flag_overrides(org_code)

Delete Organization Feature Flag Overrides

Delete all organization feature flag overrides.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The identifier for the organization.

begin
  # Delete Organization Feature Flag Overrides
  result = api_instance.delete_organization_feature_flag_overrides(org_code)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_feature_flag_overrides: #{e}"
end
```

#### Using the delete_organization_feature_flag_overrides_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_organization_feature_flag_overrides_with_http_info(org_code)

```ruby
begin
  # Delete Organization Feature Flag Overrides
  data, status_code, headers = api_instance.delete_organization_feature_flag_overrides_with_http_info(org_code)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_feature_flag_overrides_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The identifier for the organization. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## delete_organization_user_permission

> <SuccessResponse> delete_organization_user_permission(org_code, user_id, permission_id)

Delete Organization User Permission

Delete permission for an organization user.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The organization's code.
user_id = 'user_id_example' # String | The user's id.
permission_id = 'permission_id_example' # String | The permission id.

begin
  # Delete Organization User Permission
  result = api_instance.delete_organization_user_permission(org_code, user_id, permission_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_user_permission: #{e}"
end
```

#### Using the delete_organization_user_permission_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_organization_user_permission_with_http_info(org_code, user_id, permission_id)

```ruby
begin
  # Delete Organization User Permission
  data, status_code, headers = api_instance.delete_organization_user_permission_with_http_info(org_code, user_id, permission_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_user_permission_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |
| **user_id** | **String** | The user&#39;s id. |  |
| **permission_id** | **String** | The permission id. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## delete_organization_user_role

> <SuccessResponse> delete_organization_user_role(org_code, user_id, role_id)

Delete Organization User Role

Delete role for an organization user.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The organization's code.
user_id = 'user_id_example' # String | The user's id.
role_id = 'role_id_example' # String | The role id.

begin
  # Delete Organization User Role
  result = api_instance.delete_organization_user_role(org_code, user_id, role_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_user_role: #{e}"
end
```

#### Using the delete_organization_user_role_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_organization_user_role_with_http_info(org_code, user_id, role_id)

```ruby
begin
  # Delete Organization User Role
  data, status_code, headers = api_instance.delete_organization_user_role_with_http_info(org_code, user_id, role_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_user_role_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |
| **user_id** | **String** | The user&#39;s id. |  |
| **role_id** | **String** | The role id. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_organization

> <Organization> get_organization(opts)

Get Organization

Gets an organization given the organization's code. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
opts = {
  code: 'code_example' # String | The organization's code.
}

begin
  # Get Organization
  result = api_instance.get_organization(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization: #{e}"
end
```

#### Using the get_organization_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Organization>, Integer, Hash)> get_organization_with_http_info(opts)

```ruby
begin
  # Get Organization
  data, status_code, headers = api_instance.get_organization_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Organization>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | The organization&#39;s code. | [optional] |

### Return type

[**Organization**](Organization.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_organization_feature_flags

> <GetOrganizationFeatureFlagsResponse> get_organization_feature_flags(org_code)

List Organization Feature Flags

Get all organization feature flags.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The identifier for the organization.

begin
  # List Organization Feature Flags
  result = api_instance.get_organization_feature_flags(org_code)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_feature_flags: #{e}"
end
```

#### Using the get_organization_feature_flags_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetOrganizationFeatureFlagsResponse>, Integer, Hash)> get_organization_feature_flags_with_http_info(org_code)

```ruby
begin
  # List Organization Feature Flags
  data, status_code, headers = api_instance.get_organization_feature_flags_with_http_info(org_code)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetOrganizationFeatureFlagsResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_feature_flags_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The identifier for the organization. |  |

### Return type

[**GetOrganizationFeatureFlagsResponse**](GetOrganizationFeatureFlagsResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_organization_user_permissions

> <GetOrganizationsUserPermissionsResponse> get_organization_user_permissions(org_code, user_id, opts)

List Organization User Permissions

Get permissions for an organization user.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The organization's code.
user_id = 'user_id_example' # String | The user's id.
opts = {
  expand: 'expand_example' # String | Specify additional data to retrieve. Use \"roles\".
}

begin
  # List Organization User Permissions
  result = api_instance.get_organization_user_permissions(org_code, user_id, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_user_permissions: #{e}"
end
```

#### Using the get_organization_user_permissions_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetOrganizationsUserPermissionsResponse>, Integer, Hash)> get_organization_user_permissions_with_http_info(org_code, user_id, opts)

```ruby
begin
  # List Organization User Permissions
  data, status_code, headers = api_instance.get_organization_user_permissions_with_http_info(org_code, user_id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetOrganizationsUserPermissionsResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_user_permissions_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |
| **user_id** | **String** | The user&#39;s id. |  |
| **expand** | **String** | Specify additional data to retrieve. Use \&quot;roles\&quot;. | [optional] |

### Return type

[**GetOrganizationsUserPermissionsResponse**](GetOrganizationsUserPermissionsResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_organization_user_roles

> <GetOrganizationsUserRolesResponse> get_organization_user_roles(org_code, user_id)

List Organization User Roles

Get roles for an organization user.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The organization's code.
user_id = 'user_id_example' # String | The user's id.

begin
  # List Organization User Roles
  result = api_instance.get_organization_user_roles(org_code, user_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_user_roles: #{e}"
end
```

#### Using the get_organization_user_roles_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetOrganizationsUserRolesResponse>, Integer, Hash)> get_organization_user_roles_with_http_info(org_code, user_id)

```ruby
begin
  # List Organization User Roles
  data, status_code, headers = api_instance.get_organization_user_roles_with_http_info(org_code, user_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetOrganizationsUserRolesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_user_roles_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |
| **user_id** | **String** | The user&#39;s id. |  |

### Return type

[**GetOrganizationsUserRolesResponse**](GetOrganizationsUserRolesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_organization_users

> <GetOrganizationUsersResponse> get_organization_users(org_code, opts)

List Organization Users

Get users in an organization.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The organization's code.
opts = {
  sort: 'name_asc', # String | Field and order to sort the result by.
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  next_token: 'next_token_example', # String | A string to get the next page of results if there are more results.
  permissions: 'permissions_example', # String | Filter by user permissions comma separated (where all match)
  roles: 'roles_example' # String | Filter by user roles comma separated (where all match)
}

begin
  # List Organization Users
  result = api_instance.get_organization_users(org_code, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_users: #{e}"
end
```

#### Using the get_organization_users_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetOrganizationUsersResponse>, Integer, Hash)> get_organization_users_with_http_info(org_code, opts)

```ruby
begin
  # List Organization Users
  data, status_code, headers = api_instance.get_organization_users_with_http_info(org_code, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetOrganizationUsersResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_users_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |
| **sort** | **String** | Field and order to sort the result by. | [optional] |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **next_token** | **String** | A string to get the next page of results if there are more results. | [optional] |
| **permissions** | **String** | Filter by user permissions comma separated (where all match) | [optional] |
| **roles** | **String** | Filter by user roles comma separated (where all match) | [optional] |

### Return type

[**GetOrganizationUsersResponse**](GetOrganizationUsersResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_organizations

> <GetOrganizationsResponse> get_organizations(opts)

List Organizations

Get a list of organizations. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
opts = {
  sort: 'name_asc', # String | Field and order to sort the result by.
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  next_token: 'next_token_example' # String | A string to get the next page of results if there are more results.
}

begin
  # List Organizations
  result = api_instance.get_organizations(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organizations: #{e}"
end
```

#### Using the get_organizations_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetOrganizationsResponse>, Integer, Hash)> get_organizations_with_http_info(opts)

```ruby
begin
  # List Organizations
  data, status_code, headers = api_instance.get_organizations_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetOrganizationsResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organizations_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **sort** | **String** | Field and order to sort the result by. | [optional] |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **next_token** | **String** | A string to get the next page of results if there are more results. | [optional] |

### Return type

[**GetOrganizationsResponse**](GetOrganizationsResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## remove_organization_user

> <SuccessResponse> remove_organization_user(org_code, user_id)

Remove Organization User

Remove user from an organization.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The organization's code.
user_id = 'user_id_example' # String | The user's id.

begin
  # Remove Organization User
  result = api_instance.remove_organization_user(org_code, user_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->remove_organization_user: #{e}"
end
```

#### Using the remove_organization_user_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> remove_organization_user_with_http_info(org_code, user_id)

```ruby
begin
  # Remove Organization User
  data, status_code, headers = api_instance.remove_organization_user_with_http_info(org_code, user_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->remove_organization_user_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |
| **user_id** | **String** | The user&#39;s id. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## update_organization

> <SuccessResponse> update_organization(org_code, opts)

Update Organization

Update an organization.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The identifier for the organization.
opts = {
  update_organization_request: KindeApi::UpdateOrganizationRequest.new # UpdateOrganizationRequest | Organization details.
}

begin
  # Update Organization
  result = api_instance.update_organization(org_code, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->update_organization: #{e}"
end
```

#### Using the update_organization_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_organization_with_http_info(org_code, opts)

```ruby
begin
  # Update Organization
  data, status_code, headers = api_instance.update_organization_with_http_info(org_code, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->update_organization_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The identifier for the organization. |  |
| **update_organization_request** | [**UpdateOrganizationRequest**](UpdateOrganizationRequest.md) | Organization details. | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## update_organization_feature_flag_override

> <SuccessResponse> update_organization_feature_flag_override(org_code, feature_flag_key, value)

Update Organization Feature Flag Override

Update organization feature flag override.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The identifier for the organization
feature_flag_key = 'feature_flag_key_example' # String | The identifier for the feature flag
value = 'value_example' # String | Override value

begin
  # Update Organization Feature Flag Override
  result = api_instance.update_organization_feature_flag_override(org_code, feature_flag_key, value)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->update_organization_feature_flag_override: #{e}"
end
```

#### Using the update_organization_feature_flag_override_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_organization_feature_flag_override_with_http_info(org_code, feature_flag_key, value)

```ruby
begin
  # Update Organization Feature Flag Override
  data, status_code, headers = api_instance.update_organization_feature_flag_override_with_http_info(org_code, feature_flag_key, value)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->update_organization_feature_flag_override_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The identifier for the organization |  |
| **feature_flag_key** | **String** | The identifier for the feature flag |  |
| **value** | **String** | Override value |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## update_organization_users

> <UpdateOrganizationUsersResponse> update_organization_users(org_code, opts)

Update Organization Users

Update users that belong to an organization.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OrganizationsApi.new
org_code = 'org_code_example' # String | The organization's code.
opts = {
  update_organization_users_request: KindeApi::UpdateOrganizationUsersRequest.new # UpdateOrganizationUsersRequest | 
}

begin
  # Update Organization Users
  result = api_instance.update_organization_users(org_code, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->update_organization_users: #{e}"
end
```

#### Using the update_organization_users_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<UpdateOrganizationUsersResponse>, Integer, Hash)> update_organization_users_with_http_info(org_code, opts)

```ruby
begin
  # Update Organization Users
  data, status_code, headers = api_instance.update_organization_users_with_http_info(org_code, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <UpdateOrganizationUsersResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->update_organization_users_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |
| **update_organization_users_request** | [**UpdateOrganizationUsersRequest**](UpdateOrganizationUsersRequest.md) |  | [optional] |

### Return type

[**UpdateOrganizationUsersResponse**](UpdateOrganizationUsersResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8

