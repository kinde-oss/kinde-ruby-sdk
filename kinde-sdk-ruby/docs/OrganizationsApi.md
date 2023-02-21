# KindeSdk::OrganizationsApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**add_organization_users**](OrganizationsApi.md#add_organization_users) | **POST** /api/v1/organization/users | Assign Users to an Organization |
| [**create_organization**](OrganizationsApi.md#create_organization) | **POST** /api/v1/organization | Create Organization |
| [**get_orgainzations**](OrganizationsApi.md#get_orgainzations) | **GET** /api/v1/organizations | List Organizations |
| [**get_organization**](OrganizationsApi.md#get_organization) | **GET** /api/v1/organization | Get Organization |
| [**get_organization_users**](OrganizationsApi.md#get_organization_users) | **GET** /api/v1/organization/users | List Organization Users |
| [**remove_organization_users**](OrganizationsApi.md#remove_organization_users) | **PATCH** /api/v1/organization/users | Remove Users from an Organization |


## add_organization_users

> <AddOrganizationUsers200Response> add_organization_users(opts)

Assign Users to an Organization

Add existing users to an organization.

### Examples

```ruby
require 'time'
require 'kinde_sdk'
# setup authorization
KindeSdk.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeSdk::OrganizationsApi.new
opts = {
  code: 'code_example', # String | The organization's code.
  add_organization_users_request: KindeSdk::AddOrganizationUsersRequest.new # AddOrganizationUsersRequest | 
}

begin
  # Assign Users to an Organization
  result = api_instance.add_organization_users(opts)
  p result
rescue KindeSdk::ApiError => e
  puts "Error when calling OrganizationsApi->add_organization_users: #{e}"
end
```

#### Using the add_organization_users_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<AddOrganizationUsers200Response>, Integer, Hash)> add_organization_users_with_http_info(opts)

```ruby
begin
  # Assign Users to an Organization
  data, status_code, headers = api_instance.add_organization_users_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <AddOrganizationUsers200Response>
rescue KindeSdk::ApiError => e
  puts "Error when calling OrganizationsApi->add_organization_users_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | The organization&#39;s code. | [optional] |
| **add_organization_users_request** | [**AddOrganizationUsersRequest**](AddOrganizationUsersRequest.md) |  | [optional] |

### Return type

[**AddOrganizationUsers200Response**](AddOrganizationUsers200Response.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## create_organization

> create_organization(opts)

Create Organization

Create an organization.

### Examples

```ruby
require 'time'
require 'kinde_sdk'
# setup authorization
KindeSdk.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeSdk::OrganizationsApi.new
opts = {
  create_organization_request: KindeSdk::CreateOrganizationRequest.new # CreateOrganizationRequest | Organization details.
}

begin
  # Create Organization
  api_instance.create_organization(opts)
rescue KindeSdk::ApiError => e
  puts "Error when calling OrganizationsApi->create_organization: #{e}"
end
```

#### Using the create_organization_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> create_organization_with_http_info(opts)

```ruby
begin
  # Create Organization
  data, status_code, headers = api_instance.create_organization_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeSdk::ApiError => e
  puts "Error when calling OrganizationsApi->create_organization_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_organization_request** | [**CreateOrganizationRequest**](CreateOrganizationRequest.md) | Organization details. | [optional] |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: Not defined


## get_orgainzations

> <Array<Organization>> get_orgainzations(opts)

List Organizations

Get a list of organizations. 

### Examples

```ruby
require 'time'
require 'kinde_sdk'
# setup authorization
KindeSdk.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeSdk::OrganizationsApi.new
opts = {
  sort: 'name_asc', # String | Field and order to sort the result by.
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  next_token: 'next_token_example' # String | A string to get the next page of results if there are more results.
}

begin
  # List Organizations
  result = api_instance.get_orgainzations(opts)
  p result
rescue KindeSdk::ApiError => e
  puts "Error when calling OrganizationsApi->get_orgainzations: #{e}"
end
```

#### Using the get_orgainzations_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Array<Organization>>, Integer, Hash)> get_orgainzations_with_http_info(opts)

```ruby
begin
  # List Organizations
  data, status_code, headers = api_instance.get_orgainzations_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Array<Organization>>
rescue KindeSdk::ApiError => e
  puts "Error when calling OrganizationsApi->get_orgainzations_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **sort** | **String** | Field and order to sort the result by. | [optional] |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **next_token** | **String** | A string to get the next page of results if there are more results. | [optional] |

### Return type

[**Array&lt;Organization&gt;**](Organization.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_organization

> <Organization> get_organization(opts)

Get Organization

Gets an organization given the organization's code. 

### Examples

```ruby
require 'time'
require 'kinde_sdk'
# setup authorization
KindeSdk.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeSdk::OrganizationsApi.new
opts = {
  code: 'code_example' # String | The organization's code.
}

begin
  # Get Organization
  result = api_instance.get_organization(opts)
  p result
rescue KindeSdk::ApiError => e
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
rescue KindeSdk::ApiError => e
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
- **Accept**: application/json


## get_organization_users

> <OrganizationUser> get_organization_users(opts)

List Organization Users

Get users in an organizaiton.

### Examples

```ruby
require 'time'
require 'kinde_sdk'
# setup authorization
KindeSdk.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeSdk::OrganizationsApi.new
opts = {
  sort: 'name_asc', # String | Field and order to sort the result by.
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  next_token: 'next_token_example', # String | A string to get the next page of results if there are more results.
  code: 'code_example' # String | The organization's code.
}

begin
  # List Organization Users
  result = api_instance.get_organization_users(opts)
  p result
rescue KindeSdk::ApiError => e
  puts "Error when calling OrganizationsApi->get_organization_users: #{e}"
end
```

#### Using the get_organization_users_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<OrganizationUser>, Integer, Hash)> get_organization_users_with_http_info(opts)

```ruby
begin
  # List Organization Users
  data, status_code, headers = api_instance.get_organization_users_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <OrganizationUser>
rescue KindeSdk::ApiError => e
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

### Return type

[**OrganizationUser**](OrganizationUser.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## remove_organization_users

> <RemoveOrganizationUsers200Response> remove_organization_users(opts)

Remove Users from an Organization

Remove existing users from an organization.

### Examples

```ruby
require 'time'
require 'kinde_sdk'
# setup authorization
KindeSdk.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeSdk::OrganizationsApi.new
opts = {
  code: 'code_example', # String | The organization's code.
  remove_organization_users_request: KindeSdk::RemoveOrganizationUsersRequest.new # RemoveOrganizationUsersRequest | 
}

begin
  # Remove Users from an Organization
  result = api_instance.remove_organization_users(opts)
  p result
rescue KindeSdk::ApiError => e
  puts "Error when calling OrganizationsApi->remove_organization_users: #{e}"
end
```

#### Using the remove_organization_users_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<RemoveOrganizationUsers200Response>, Integer, Hash)> remove_organization_users_with_http_info(opts)

```ruby
begin
  # Remove Users from an Organization
  data, status_code, headers = api_instance.remove_organization_users_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <RemoveOrganizationUsers200Response>
rescue KindeSdk::ApiError => e
  puts "Error when calling OrganizationsApi->remove_organization_users_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | The organization&#39;s code. | [optional] |
| **remove_organization_users_request** | [**RemoveOrganizationUsersRequest**](RemoveOrganizationUsersRequest.md) |  | [optional] |

### Return type

[**RemoveOrganizationUsers200Response**](RemoveOrganizationUsers200Response.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

