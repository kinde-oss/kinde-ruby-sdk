# KindeApi::OrganizationsApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**add_organization_logo**](OrganizationsApi.md#add_organization_logo) | **POST** /api/v1/organizations/{org_code}/logos/{type} | Add organization logo |
| [**add_organization_user_api_scope**](OrganizationsApi.md#add_organization_user_api_scope) | **POST** /api/v1/organizations/{org_code}/users/{user_id}/apis/{api_id}/scopes/{scope_id} | Add scope to organization user api |
| [**add_organization_users**](OrganizationsApi.md#add_organization_users) | **POST** /api/v1/organizations/{org_code}/users | Add Organization Users |
| [**create_organization**](OrganizationsApi.md#create_organization) | **POST** /api/v1/organization | Create organization |
| [**create_organization_user_permission**](OrganizationsApi.md#create_organization_user_permission) | **POST** /api/v1/organizations/{org_code}/users/{user_id}/permissions | Add Organization User Permission |
| [**create_organization_user_role**](OrganizationsApi.md#create_organization_user_role) | **POST** /api/v1/organizations/{org_code}/users/{user_id}/roles | Add Organization User Role |
| [**delete_organization**](OrganizationsApi.md#delete_organization) | **DELETE** /api/v1/organization/{org_code} | Delete Organization |
| [**delete_organization_feature_flag_override**](OrganizationsApi.md#delete_organization_feature_flag_override) | **DELETE** /api/v1/organizations/{org_code}/feature_flags/{feature_flag_key} | Delete Organization Feature Flag Override |
| [**delete_organization_feature_flag_overrides**](OrganizationsApi.md#delete_organization_feature_flag_overrides) | **DELETE** /api/v1/organizations/{org_code}/feature_flags | Delete Organization Feature Flag Overrides |
| [**delete_organization_handle**](OrganizationsApi.md#delete_organization_handle) | **DELETE** /api/v1/organization/{org_code}/handle | Delete organization handle |
| [**delete_organization_logo**](OrganizationsApi.md#delete_organization_logo) | **DELETE** /api/v1/organizations/{org_code}/logos/{type} | Delete organization logo |
| [**delete_organization_user_api_scope**](OrganizationsApi.md#delete_organization_user_api_scope) | **DELETE** /api/v1/organizations/{org_code}/users/{user_id}/apis/{api_id}/scopes/{scope_id} | Delete scope from organization user API |
| [**delete_organization_user_permission**](OrganizationsApi.md#delete_organization_user_permission) | **DELETE** /api/v1/organizations/{org_code}/users/{user_id}/permissions/{permission_id} | Delete Organization User Permission |
| [**delete_organization_user_role**](OrganizationsApi.md#delete_organization_user_role) | **DELETE** /api/v1/organizations/{org_code}/users/{user_id}/roles/{role_id} | Delete Organization User Role |
| [**enable_org_connection**](OrganizationsApi.md#enable_org_connection) | **POST** /api/v1/organizations/{organization_code}/connections/{connection_id} | Enable connection |
| [**get_org_user_mfa**](OrganizationsApi.md#get_org_user_mfa) | **GET** /api/v1/organizations/{org_code}/users/{user_id}/mfa | Get an organization user&#39;s MFA configuration |
| [**get_organization**](OrganizationsApi.md#get_organization) | **GET** /api/v1/organization | Get organization |
| [**get_organization_connections**](OrganizationsApi.md#get_organization_connections) | **GET** /api/v1/organizations/{organization_code}/connections | Get connections |
| [**get_organization_feature_flags**](OrganizationsApi.md#get_organization_feature_flags) | **GET** /api/v1/organizations/{org_code}/feature_flags | List Organization Feature Flags |
| [**get_organization_property_values**](OrganizationsApi.md#get_organization_property_values) | **GET** /api/v1/organizations/{org_code}/properties | Get Organization Property Values |
| [**get_organization_user_permissions**](OrganizationsApi.md#get_organization_user_permissions) | **GET** /api/v1/organizations/{org_code}/users/{user_id}/permissions | List Organization User Permissions |
| [**get_organization_user_roles**](OrganizationsApi.md#get_organization_user_roles) | **GET** /api/v1/organizations/{org_code}/users/{user_id}/roles | List Organization User Roles |
| [**get_organization_users**](OrganizationsApi.md#get_organization_users) | **GET** /api/v1/organizations/{org_code}/users | Get organization users |
| [**get_organizations**](OrganizationsApi.md#get_organizations) | **GET** /api/v1/organizations | Get organizations |
| [**read_organization_logo**](OrganizationsApi.md#read_organization_logo) | **GET** /api/v1/organizations/{org_code}/logos | Read organization logo details |
| [**remove_org_connection**](OrganizationsApi.md#remove_org_connection) | **DELETE** /api/v1/organizations/{organization_code}/connections/{connection_id} | Remove connection |
| [**remove_organization_user**](OrganizationsApi.md#remove_organization_user) | **DELETE** /api/v1/organizations/{org_code}/users/{user_id} | Remove Organization User |
| [**replace_organization_mfa**](OrganizationsApi.md#replace_organization_mfa) | **PUT** /api/v1/organizations/{org_code}/mfa | Replace Organization MFA Configuration |
| [**reset_org_user_mfa**](OrganizationsApi.md#reset_org_user_mfa) | **DELETE** /api/v1/organizations/{org_code}/users/{user_id}/mfa/{factor_id} | Reset specific organization MFA for a user |
| [**reset_org_user_mfa_all**](OrganizationsApi.md#reset_org_user_mfa_all) | **DELETE** /api/v1/organizations/{org_code}/users/{user_id}/mfa | Reset all organization MFA for a user |
| [**update_organization**](OrganizationsApi.md#update_organization) | **PATCH** /api/v1/organization/{org_code} | Update Organization |
| [**update_organization_feature_flag_override**](OrganizationsApi.md#update_organization_feature_flag_override) | **PATCH** /api/v1/organizations/{org_code}/feature_flags/{feature_flag_key} | Update Organization Feature Flag Override |
| [**update_organization_properties**](OrganizationsApi.md#update_organization_properties) | **PATCH** /api/v1/organizations/{org_code}/properties | Update Organization Property values |
| [**update_organization_property**](OrganizationsApi.md#update_organization_property) | **PUT** /api/v1/organizations/{org_code}/properties/{property_key} | Update Organization Property value |
| [**update_organization_sessions**](OrganizationsApi.md#update_organization_sessions) | **PATCH** /api/v1/organizations/{org_code}/sessions | Update organization session configuration |
| [**update_organization_users**](OrganizationsApi.md#update_organization_users) | **PATCH** /api/v1/organizations/{org_code}/users | Update Organization Users |


## add_organization_logo

> <SuccessResponse> add_organization_logo(org_code, type, logo)

Add organization logo

Add organization logo  <div>   <code>update:organizations</code> </div> 

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
org_code = 'org_1ccfb819462' # String | The organization's code.
type = 'dark' # String | The type of logo to add.
logo = File.new('/path/to/some/file') # File | The logo file to upload.

begin
  # Add organization logo
  result = api_instance.add_organization_logo(org_code, type, logo)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->add_organization_logo: #{e}"
end
```

#### Using the add_organization_logo_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> add_organization_logo_with_http_info(org_code, type, logo)

```ruby
begin
  # Add organization logo
  data, status_code, headers = api_instance.add_organization_logo_with_http_info(org_code, type, logo)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->add_organization_logo_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |
| **type** | **String** | The type of logo to add. |  |
| **logo** | **File** | The logo file to upload. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: multipart/form-data
- **Accept**: application/json


## add_organization_user_api_scope

> add_organization_user_api_scope(org_code, user_id, api_id, scope_id)

Add scope to organization user api

Add a scope to an organization user api.  <div>   <code>create:organization_user_api_scopes</code> </div> 

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
user_id = 'kp_5ce676e5d6a24bc9aac2fba35a46e958' # String | User ID
api_id = '838f208d006a482dbd8cdb79a9889f68' # String | API ID
scope_id = 'api_scope_019391daf58d87d8a7213419c016ac95' # String | Scope ID

begin
  # Add scope to organization user api
  api_instance.add_organization_user_api_scope(org_code, user_id, api_id, scope_id)
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->add_organization_user_api_scope: #{e}"
end
```

#### Using the add_organization_user_api_scope_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> add_organization_user_api_scope_with_http_info(org_code, user_id, api_id, scope_id)

```ruby
begin
  # Add scope to organization user api
  data, status_code, headers = api_instance.add_organization_user_api_scope_with_http_info(org_code, user_id, api_id, scope_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->add_organization_user_api_scope_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The identifier for the organization. |  |
| **user_id** | **String** | User ID |  |
| **api_id** | **String** | API ID |  |
| **scope_id** | **String** | Scope ID |  |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## add_organization_users

> <AddOrganizationUsersResponse> add_organization_users(org_code, opts)

Add Organization Users

Add existing users to an organization.  <div>   <code>create:organization_users</code> </div> 

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
- **Accept**: application/json


## create_organization

> <CreateOrganizationResponse> create_organization(create_organization_request)

Create organization

Create a new organization. To learn more read about [multi tenancy using organizations](https://docs.kinde.com/build/organizations/multi-tenancy-using-organizations/)  <div>   <code>create:organizations</code> </div> 

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
create_organization_request = KindeApi::CreateOrganizationRequest.new({name: 'Acme Corp'}) # CreateOrganizationRequest | Organization details.

begin
  # Create organization
  result = api_instance.create_organization(create_organization_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->create_organization: #{e}"
end
```

#### Using the create_organization_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateOrganizationResponse>, Integer, Hash)> create_organization_with_http_info(create_organization_request)

```ruby
begin
  # Create organization
  data, status_code, headers = api_instance.create_organization_with_http_info(create_organization_request)
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
| **create_organization_request** | [**CreateOrganizationRequest**](CreateOrganizationRequest.md) | Organization details. |  |

### Return type

[**CreateOrganizationResponse**](CreateOrganizationResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## create_organization_user_permission

> <SuccessResponse> create_organization_user_permission(org_code, user_id, create_organization_user_permission_request)

Add Organization User Permission

Add permission to an organization user.  <div>   <code>create:organization_user_permissions</code> </div> 

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

Add role to an organization user.  <div>   <code>create:organization_user_roles</code> </div> 

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

> <SuccessResponse> delete_organization(org_code)

Delete Organization

Delete an organization.  <div>   <code>delete:organizations</code> </div> 

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
  result = api_instance.delete_organization(org_code)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization: #{e}"
end
```

#### Using the delete_organization_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_organization_with_http_info(org_code)

```ruby
begin
  # Delete Organization
  data, status_code, headers = api_instance.delete_organization_with_http_info(org_code)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_with_http_info: #{e}"
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
- **Accept**: application/json


## delete_organization_feature_flag_override

> <SuccessResponse> delete_organization_feature_flag_override(org_code, feature_flag_key)

Delete Organization Feature Flag Override

Delete organization feature flag override.  <div>   <code>delete:organization_feature_flags</code> </div> 

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

Delete all organization feature flag overrides.  <div>   <code>delete:organization_feature_flags</code> </div> 

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


## delete_organization_handle

> <SuccessResponse> delete_organization_handle(org_code)

Delete organization handle

Delete organization handle  <div>   <code>delete:organization_handles</code> </div> 

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

begin
  # Delete organization handle
  result = api_instance.delete_organization_handle(org_code)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_handle: #{e}"
end
```

#### Using the delete_organization_handle_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_organization_handle_with_http_info(org_code)

```ruby
begin
  # Delete organization handle
  data, status_code, headers = api_instance.delete_organization_handle_with_http_info(org_code)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_handle_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## delete_organization_logo

> <SuccessResponse> delete_organization_logo(org_code, type)

Delete organization logo

Delete organization logo  <div>   <code>update:organizations</code> </div> 

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
org_code = 'org_1ccfb819462' # String | The organization's code.
type = 'dark' # String | The type of logo to delete.

begin
  # Delete organization logo
  result = api_instance.delete_organization_logo(org_code, type)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_logo: #{e}"
end
```

#### Using the delete_organization_logo_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_organization_logo_with_http_info(org_code, type)

```ruby
begin
  # Delete organization logo
  data, status_code, headers = api_instance.delete_organization_logo_with_http_info(org_code, type)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_logo_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |
| **type** | **String** | The type of logo to delete. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## delete_organization_user_api_scope

> delete_organization_user_api_scope(org_code, user_id, api_id, scope_id)

Delete scope from organization user API

Delete a scope from an organization user api you previously created.  <div>   <code>delete:organization_user_api_scopes</code> </div> 

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
user_id = 'kp_5ce676e5d6a24bc9aac2fba35a46e958' # String | User ID
api_id = '838f208d006a482dbd8cdb79a9889f68' # String | API ID
scope_id = 'api_scope_019391daf58d87d8a7213419c016ac95' # String | Scope ID

begin
  # Delete scope from organization user API
  api_instance.delete_organization_user_api_scope(org_code, user_id, api_id, scope_id)
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_user_api_scope: #{e}"
end
```

#### Using the delete_organization_user_api_scope_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> delete_organization_user_api_scope_with_http_info(org_code, user_id, api_id, scope_id)

```ruby
begin
  # Delete scope from organization user API
  data, status_code, headers = api_instance.delete_organization_user_api_scope_with_http_info(org_code, user_id, api_id, scope_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->delete_organization_user_api_scope_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The identifier for the organization. |  |
| **user_id** | **String** | User ID |  |
| **api_id** | **String** | API ID |  |
| **scope_id** | **String** | Scope ID |  |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## delete_organization_user_permission

> <SuccessResponse> delete_organization_user_permission(org_code, user_id, permission_id)

Delete Organization User Permission

Delete permission for an organization user.  <div>   <code>delete:organization_user_permissions</code> </div> 

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

Delete role for an organization user.  <div>   <code>delete:organization_user_roles</code> </div> 

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


## enable_org_connection

> enable_org_connection(organization_code, connection_id)

Enable connection

Enable an auth connection for an organization.  <div>   <code>create:organization_connections</code> </div> 

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
organization_code = 'org_7d45b01ef13' # String | The unique code for the organization.
connection_id = 'conn_0192c16abb53b44277e597d31877ba5b' # String | The identifier for the connection.

begin
  # Enable connection
  api_instance.enable_org_connection(organization_code, connection_id)
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->enable_org_connection: #{e}"
end
```

#### Using the enable_org_connection_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> enable_org_connection_with_http_info(organization_code, connection_id)

```ruby
begin
  # Enable connection
  data, status_code, headers = api_instance.enable_org_connection_with_http_info(organization_code, connection_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->enable_org_connection_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **organization_code** | **String** | The unique code for the organization. |  |
| **connection_id** | **String** | The identifier for the connection. |  |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_org_user_mfa

> <GetUserMfaResponse> get_org_user_mfa(org_code, user_id)

Get an organization user's MFA configuration

Get an organization user’s MFA configuration.  <div>   <code>read:organization_user_mfa</code> </div> 

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
org_code = 'org_1ccfb819462' # String | The identifier for the organization.
user_id = 'kp_c3143a4b50ad43c88e541d9077681782' # String | The identifier for the user

begin
  # Get an organization user's MFA configuration
  result = api_instance.get_org_user_mfa(org_code, user_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_org_user_mfa: #{e}"
end
```

#### Using the get_org_user_mfa_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetUserMfaResponse>, Integer, Hash)> get_org_user_mfa_with_http_info(org_code, user_id)

```ruby
begin
  # Get an organization user's MFA configuration
  data, status_code, headers = api_instance.get_org_user_mfa_with_http_info(org_code, user_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetUserMfaResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_org_user_mfa_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The identifier for the organization. |  |
| **user_id** | **String** | The identifier for the user |  |

### Return type

[**GetUserMfaResponse**](GetUserMfaResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_organization

> <GetOrganizationResponse> get_organization(opts)

Get organization

Retrieve organization details by code.  <div>   <code>read:organizations</code> </div> 

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
  code: 'org_1ccfb819462' # String | The organization's code.
}

begin
  # Get organization
  result = api_instance.get_organization(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization: #{e}"
end
```

#### Using the get_organization_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetOrganizationResponse>, Integer, Hash)> get_organization_with_http_info(opts)

```ruby
begin
  # Get organization
  data, status_code, headers = api_instance.get_organization_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetOrganizationResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | The organization&#39;s code. | [optional] |

### Return type

[**GetOrganizationResponse**](GetOrganizationResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_organization_connections

> <GetConnectionsResponse> get_organization_connections(organization_code)

Get connections

Gets all connections for an organization.  <div>   <code>read:organization_connections</code> </div> 

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
organization_code = 'org_7d45b01ef13' # String | The organization code.

begin
  # Get connections
  result = api_instance.get_organization_connections(organization_code)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_connections: #{e}"
end
```

#### Using the get_organization_connections_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetConnectionsResponse>, Integer, Hash)> get_organization_connections_with_http_info(organization_code)

```ruby
begin
  # Get connections
  data, status_code, headers = api_instance.get_organization_connections_with_http_info(organization_code)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetConnectionsResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_connections_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **organization_code** | **String** | The organization code. |  |

### Return type

[**GetConnectionsResponse**](GetConnectionsResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_organization_feature_flags

> <GetOrganizationFeatureFlagsResponse> get_organization_feature_flags(org_code)

List Organization Feature Flags

Get all organization feature flags.  <div>   <code>read:organization_feature_flags</code> </div> 

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


## get_organization_property_values

> <GetPropertyValuesResponse> get_organization_property_values(org_code)

Get Organization Property Values

Gets properties for an organization by org code.  <div>   <code>read:organization_properties</code> </div> 

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

begin
  # Get Organization Property Values
  result = api_instance.get_organization_property_values(org_code)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_property_values: #{e}"
end
```

#### Using the get_organization_property_values_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetPropertyValuesResponse>, Integer, Hash)> get_organization_property_values_with_http_info(org_code)

```ruby
begin
  # Get Organization Property Values
  data, status_code, headers = api_instance.get_organization_property_values_with_http_info(org_code)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetPropertyValuesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_property_values_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |

### Return type

[**GetPropertyValuesResponse**](GetPropertyValuesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_organization_user_permissions

> <GetOrganizationsUserPermissionsResponse> get_organization_user_permissions(org_code, user_id, opts)

List Organization User Permissions

Get permissions for an organization user.  <div>   <code>read:organization_user_permissions</code> </div> 

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

Get roles for an organization user.  <div>   <code>read:organization_user_roles</code> </div> 

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

Get organization users

Get user details for all members of an organization.  <div>   <code>read:organization_users</code> </div> 

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
org_code = 'org_1ccfb819462' # String | The organization's code.
opts = {
  sort: 'name_asc', # String | Field and order to sort the result by.
  page_size: 10, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  next_token: 'MTo6OmlkX2FzYw==', # String | A string to get the next page of results if there are more results.
  permissions: 'admin', # String | Filter by user permissions comma separated (where all match)
  roles: 'manager' # String | Filter by user roles comma separated (where all match)
}

begin
  # Get organization users
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
  # Get organization users
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
- **Accept**: application/json


## get_organizations

> <GetOrganizationsResponse> get_organizations(opts)

Get organizations

Get a list of organizations.  <div>   <code>read:organizations</code> </div> 

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
  # Get organizations
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
  # Get organizations
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
- **Accept**: application/json


## read_organization_logo

> <ReadLogoResponse> read_organization_logo(org_code)

Read organization logo details

Read organization logo details  <div>   <code>read:organizations</code> </div> 

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
org_code = 'org_1ccfb819462' # String | The organization's code.

begin
  # Read organization logo details
  result = api_instance.read_organization_logo(org_code)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->read_organization_logo: #{e}"
end
```

#### Using the read_organization_logo_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<ReadLogoResponse>, Integer, Hash)> read_organization_logo_with_http_info(org_code)

```ruby
begin
  # Read organization logo details
  data, status_code, headers = api_instance.read_organization_logo_with_http_info(org_code)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <ReadLogoResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->read_organization_logo_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |

### Return type

[**ReadLogoResponse**](ReadLogoResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## remove_org_connection

> <SuccessResponse> remove_org_connection(organization_code, connection_id)

Remove connection

Turn off an auth connection for an organization  <div>   <code>delete:organization_connections</code> </div> 

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
organization_code = 'org_7d45b01ef13' # String | The unique code for the organization.
connection_id = 'conn_0192c16abb53b44277e597d31877ba5b' # String | The identifier for the connection.

begin
  # Remove connection
  result = api_instance.remove_org_connection(organization_code, connection_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->remove_org_connection: #{e}"
end
```

#### Using the remove_org_connection_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> remove_org_connection_with_http_info(organization_code, connection_id)

```ruby
begin
  # Remove connection
  data, status_code, headers = api_instance.remove_org_connection_with_http_info(organization_code, connection_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->remove_org_connection_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **organization_code** | **String** | The unique code for the organization. |  |
| **connection_id** | **String** | The identifier for the connection. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## remove_organization_user

> <SuccessResponse> remove_organization_user(org_code, user_id)

Remove Organization User

Remove user from an organization.  <div>   <code>delete:organization_users</code> </div> 

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


## replace_organization_mfa

> <SuccessResponse> replace_organization_mfa(org_code, replace_organization_mfa_request)

Replace Organization MFA Configuration

Replace Organization MFA Configuration.  <div>   <code>update:organization_mfa</code> </div> 

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
replace_organization_mfa_request = KindeApi::ReplaceOrganizationMFARequest.new({enabled_factors: ['mfa:email']}) # ReplaceOrganizationMFARequest | MFA details.

begin
  # Replace Organization MFA Configuration
  result = api_instance.replace_organization_mfa(org_code, replace_organization_mfa_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->replace_organization_mfa: #{e}"
end
```

#### Using the replace_organization_mfa_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> replace_organization_mfa_with_http_info(org_code, replace_organization_mfa_request)

```ruby
begin
  # Replace Organization MFA Configuration
  data, status_code, headers = api_instance.replace_organization_mfa_with_http_info(org_code, replace_organization_mfa_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->replace_organization_mfa_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The identifier for the organization |  |
| **replace_organization_mfa_request** | [**ReplaceOrganizationMFARequest**](ReplaceOrganizationMFARequest.md) | MFA details. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## reset_org_user_mfa

> <SuccessResponse> reset_org_user_mfa(org_code, user_id, factor_id)

Reset specific organization MFA for a user

Reset a specific organization MFA factor for a user.  <div>   <code>delete:organization_user_mfa</code> </div> 

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
org_code = 'org_1ccfb819462' # String | The identifier for the organization.
user_id = 'kp_c3143a4b50ad43c88e541d9077681782' # String | The identifier for the user
factor_id = 'mfa_0193278a00ac29b3f6d4e4d462d55c47' # String | The identifier for the MFA factor

begin
  # Reset specific organization MFA for a user
  result = api_instance.reset_org_user_mfa(org_code, user_id, factor_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->reset_org_user_mfa: #{e}"
end
```

#### Using the reset_org_user_mfa_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> reset_org_user_mfa_with_http_info(org_code, user_id, factor_id)

```ruby
begin
  # Reset specific organization MFA for a user
  data, status_code, headers = api_instance.reset_org_user_mfa_with_http_info(org_code, user_id, factor_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->reset_org_user_mfa_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The identifier for the organization. |  |
| **user_id** | **String** | The identifier for the user |  |
| **factor_id** | **String** | The identifier for the MFA factor |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## reset_org_user_mfa_all

> <SuccessResponse> reset_org_user_mfa_all(org_code, user_id)

Reset all organization MFA for a user

Reset all organization MFA factors for a user.  <div>   <code>delete:organization_user_mfa</code> </div> 

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
org_code = 'org_1ccfb819462' # String | The identifier for the organization.
user_id = 'kp_c3143a4b50ad43c88e541d9077681782' # String | The identifier for the user

begin
  # Reset all organization MFA for a user
  result = api_instance.reset_org_user_mfa_all(org_code, user_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->reset_org_user_mfa_all: #{e}"
end
```

#### Using the reset_org_user_mfa_all_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> reset_org_user_mfa_all_with_http_info(org_code, user_id)

```ruby
begin
  # Reset all organization MFA for a user
  data, status_code, headers = api_instance.reset_org_user_mfa_all_with_http_info(org_code, user_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->reset_org_user_mfa_all_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The identifier for the organization. |  |
| **user_id** | **String** | The identifier for the user |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## update_organization

> <SuccessResponse> update_organization(org_code, opts)

Update Organization

Update an organization.  <div>   <code>update:organizations</code> </div> 

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
org_code = 'org_1ccfb819462' # String | The identifier for the organization.
opts = {
  expand: 'billing', # String | Specify additional data to retrieve. Use \"billing\".
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
| **expand** | **String** | Specify additional data to retrieve. Use \&quot;billing\&quot;. | [optional] |
| **update_organization_request** | [**UpdateOrganizationRequest**](UpdateOrganizationRequest.md) | Organization details. | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## update_organization_feature_flag_override

> <SuccessResponse> update_organization_feature_flag_override(org_code, feature_flag_key, value)

Update Organization Feature Flag Override

Update organization feature flag override.  <div>   <code>update:organization_feature_flags</code> </div> 

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


## update_organization_properties

> <SuccessResponse> update_organization_properties(org_code, update_organization_properties_request)

Update Organization Property values

Update organization property values.  <div>   <code>update:organization_properties</code> </div> 

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
update_organization_properties_request = KindeApi::UpdateOrganizationPropertiesRequest.new({properties: 3.56}) # UpdateOrganizationPropertiesRequest | Properties to update.

begin
  # Update Organization Property values
  result = api_instance.update_organization_properties(org_code, update_organization_properties_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->update_organization_properties: #{e}"
end
```

#### Using the update_organization_properties_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_organization_properties_with_http_info(org_code, update_organization_properties_request)

```ruby
begin
  # Update Organization Property values
  data, status_code, headers = api_instance.update_organization_properties_with_http_info(org_code, update_organization_properties_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->update_organization_properties_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The identifier for the organization |  |
| **update_organization_properties_request** | [**UpdateOrganizationPropertiesRequest**](UpdateOrganizationPropertiesRequest.md) | Properties to update. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## update_organization_property

> <SuccessResponse> update_organization_property(org_code, property_key, value)

Update Organization Property value

Update organization property value.  <div>   <code>update:organization_properties</code> </div> 

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
property_key = 'property_key_example' # String | The identifier for the property
value = 'value_example' # String | The new property value

begin
  # Update Organization Property value
  result = api_instance.update_organization_property(org_code, property_key, value)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->update_organization_property: #{e}"
end
```

#### Using the update_organization_property_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_organization_property_with_http_info(org_code, property_key, value)

```ruby
begin
  # Update Organization Property value
  data, status_code, headers = api_instance.update_organization_property_with_http_info(org_code, property_key, value)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->update_organization_property_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The identifier for the organization |  |
| **property_key** | **String** | The identifier for the property |  |
| **value** | **String** | The new property value |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## update_organization_sessions

> <SuccessResponse> update_organization_sessions(org_code, update_organization_sessions_request)

Update organization session configuration

Update the organization's session configuration.  <div>   <code>update:organizations</code> </div> 

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
org_code = 'org_1ccfb819462' # String | The organization's code.
update_organization_sessions_request = KindeApi::UpdateOrganizationSessionsRequest.new # UpdateOrganizationSessionsRequest | Organization session configuration.

begin
  # Update organization session configuration
  result = api_instance.update_organization_sessions(org_code, update_organization_sessions_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->update_organization_sessions: #{e}"
end
```

#### Using the update_organization_sessions_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_organization_sessions_with_http_info(org_code, update_organization_sessions_request)

```ruby
begin
  # Update organization session configuration
  data, status_code, headers = api_instance.update_organization_sessions_with_http_info(org_code, update_organization_sessions_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->update_organization_sessions_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization&#39;s code. |  |
| **update_organization_sessions_request** | [**UpdateOrganizationSessionsRequest**](UpdateOrganizationSessionsRequest.md) | Organization session configuration. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## update_organization_users

> <UpdateOrganizationUsersResponse> update_organization_users(org_code, opts)

Update Organization Users

Update users that belong to an organization.  <div>   <code>update:organization_users</code> </div> 

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
- **Accept**: application/json

