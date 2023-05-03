# KindeApi::OrganizationsApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**add_organization_users**](OrganizationsApi.md#add_organization_users) | **POST** /api/v1/organization/users | Assign Users to an Organization |
| [**create_organization**](OrganizationsApi.md#create_organization) | **POST** /api/v1/organization | Create Organization |
| [**delete_organization_feature_flag_override**](OrganizationsApi.md#delete_organization_feature_flag_override) | **DELETE** /api/v1/organizations/{org_code}/feature_flags/{feature_flag_key} | Delete organization feature flag override |
| [**delete_organization_feature_flag_overrides**](OrganizationsApi.md#delete_organization_feature_flag_overrides) | **DELETE** /api/v1/organizations/{org_code}/feature_flags | Delete all organization feature flag overrides |
| [**get_organization**](OrganizationsApi.md#get_organization) | **GET** /api/v1/organization | Get Organization |
| [**get_organization_users**](OrganizationsApi.md#get_organization_users) | **GET** /api/v1/organization/users | List Organization Users |
| [**get_organizations**](OrganizationsApi.md#get_organizations) | **GET** /api/v1/organizations | List Organizations |
| [**remove_organization_users**](OrganizationsApi.md#remove_organization_users) | **PATCH** /api/v1/organization/users | Remove Users from an Organization |
| [**update_organization**](OrganizationsApi.md#update_organization) | **PATCH** /api/v1/organizations/{org_code} | Update Organization |
| [**update_organization_feature_flag_override**](OrganizationsApi.md#update_organization_feature_flag_override) | **PATCH** /api/v1/organizations/{org_code}/feature_flags/{feature_flag_key} | Update organization feature flag override |


## add_organization_users

> <AddOrganizationUsersResponse> add_organization_users(opts)

Assign Users to an Organization

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
opts = {
  code: 'code_example', # String | The organization's code.
  add_organization_users_request: KindeApi::AddOrganizationUsersRequest.new # AddOrganizationUsersRequest | 
}

begin
  # Assign Users to an Organization
  result = api_instance.add_organization_users(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->add_organization_users: #{e}"
end
```

#### Using the add_organization_users_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<AddOrganizationUsersResponse>, Integer, Hash)> add_organization_users_with_http_info(opts)

```ruby
begin
  # Assign Users to an Organization
  data, status_code, headers = api_instance.add_organization_users_with_http_info(opts)
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
| **code** | **String** | The organization&#39;s code. | [optional] |
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


## delete_organization_feature_flag_override

> <SuccessResponse> delete_organization_feature_flag_override(org_code, feature_flag_key)

Delete organization feature flag override

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
  # Delete organization feature flag override
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
  # Delete organization feature flag override
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

Delete all organization feature flag overrides

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
  # Delete all organization feature flag overrides
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
  # Delete all organization feature flag overrides
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


## get_organization_users

> <GetOrganizationsUsersResponse> get_organization_users(opts)

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
opts = {
  sort: 'name_asc', # String | Field and order to sort the result by.
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  next_token: 'next_token_example', # String | A string to get the next page of results if there are more results.
  code: 'code_example', # String | The organization's code.
  permissions: 'permissions_example' # String | Filter by user permissions
}

begin
  # List Organization Users
  result = api_instance.get_organization_users(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_users: #{e}"
end
```

#### Using the get_organization_users_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetOrganizationsUsersResponse>, Integer, Hash)> get_organization_users_with_http_info(opts)

```ruby
begin
  # List Organization Users
  data, status_code, headers = api_instance.get_organization_users_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetOrganizationsUsersResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_users_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **sort** | **String** | Field and order to sort the result by. | [optional] |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **next_token** | **String** | A string to get the next page of results if there are more results. | [optional] |
| **code** | **String** | The organization&#39;s code. | [optional] |
| **permissions** | **String** | Filter by user permissions | [optional] |

### Return type

[**GetOrganizationsUsersResponse**](GetOrganizationsUsersResponse.md)

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


## remove_organization_users

> <RemoveOrganizationUsersResponse> remove_organization_users(opts)

Remove Users from an Organization

Remove existing users from an organization.

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
  code: 'code_example', # String | The organization's code.
  remove_organization_users_request: KindeApi::RemoveOrganizationUsersRequest.new # RemoveOrganizationUsersRequest | 
}

begin
  # Remove Users from an Organization
  result = api_instance.remove_organization_users(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->remove_organization_users: #{e}"
end
```

#### Using the remove_organization_users_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<RemoveOrganizationUsersResponse>, Integer, Hash)> remove_organization_users_with_http_info(opts)

```ruby
begin
  # Remove Users from an Organization
  data, status_code, headers = api_instance.remove_organization_users_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <RemoveOrganizationUsersResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->remove_organization_users_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | The organization&#39;s code. | [optional] |
| **remove_organization_users_request** | [**RemoveOrganizationUsersRequest**](RemoveOrganizationUsersRequest.md) |  | [optional] |

### Return type

[**RemoveOrganizationUsersResponse**](RemoveOrganizationUsersResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## update_organization

> update_organization(opts)

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
opts = {
  update_organization_request: KindeApi::UpdateOrganizationRequest.new # UpdateOrganizationRequest | Organization details.
}

begin
  # Update Organization
  api_instance.update_organization(opts)
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->update_organization: #{e}"
end
```

#### Using the update_organization_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> update_organization_with_http_info(opts)

```ruby
begin
  # Update Organization
  data, status_code, headers = api_instance.update_organization_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeApi::ApiError => e
  puts "Error when calling OrganizationsApi->update_organization_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **update_organization_request** | [**UpdateOrganizationRequest**](UpdateOrganizationRequest.md) | Organization details. | [optional] |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## update_organization_feature_flag_override

> <SuccessResponse> update_organization_feature_flag_override(org_code, feature_flag_key, value)

Update organization feature flag override

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
  # Update organization feature flag override
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
  # Update organization feature flag override
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

