# KindeApi::UsersApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**add_organization_users**](UsersApi.md#add_organization_users) | **POST** /api/v1/organization/users | Assign Users to an Organization |
| [**create_user**](UsersApi.md#create_user) | **POST** /api/v1/user | Create User |
| [**deleteuser**](UsersApi.md#deleteuser) | **DELETE** /api/v1/user | Delete User |
| [**get_organization_users**](UsersApi.md#get_organization_users) | **GET** /api/v1/organization/users | List Organization Users |
| [**get_user_data**](UsersApi.md#get_user_data) | **GET** /api/v1/user | Get User |
| [**get_users**](UsersApi.md#get_users) | **GET** /api/v1/users | List Users |
| [**remove_organization_users**](UsersApi.md#remove_organization_users) | **PATCH** /api/v1/organization/users | Remove Users from an Organization |
| [**update_user**](UsersApi.md#update_user) | **PATCH** /api/v1/user | Update User |


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

api_instance = KindeApi::UsersApi.new
opts = {
  code: 'code_example', # String | The organization's code.
  add_organization_users_request: KindeApi::AddOrganizationUsersRequest.new # AddOrganizationUsersRequest | 
}

begin
  # Assign Users to an Organization
  result = api_instance.add_organization_users(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->add_organization_users: #{e}"
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
  puts "Error when calling UsersApi->add_organization_users_with_http_info: #{e}"
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


## create_user

> <CreateUserResponse> create_user(opts)

Create User

Creates a user record and optionally zero or more identities for the user. An example identity could be the email address of the user. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
opts = {
  create_user_request: KindeApi::CreateUserRequest.new # CreateUserRequest | The details of the user to create.
}

begin
  # Create User
  result = api_instance.create_user(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->create_user: #{e}"
end
```

#### Using the create_user_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateUserResponse>, Integer, Hash)> create_user_with_http_info(opts)

```ruby
begin
  # Create User
  data, status_code, headers = api_instance.create_user_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateUserResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->create_user_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_user_request** | [**CreateUserRequest**](CreateUserRequest.md) | The details of the user to create. | [optional] |

### Return type

[**CreateUserResponse**](CreateUserResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## deleteuser

> <SuccessResponse> deleteuser(opts)

Delete User

Delete a user record. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
opts = {
  id: 'id_example' # String | The user's id.
}

begin
  # Delete User
  result = api_instance.deleteuser(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->deleteuser: #{e}"
end
```

#### Using the deleteuser_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> deleteuser_with_http_info(opts)

```ruby
begin
  # Delete User
  data, status_code, headers = api_instance.deleteuser_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->deleteuser_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The user&#39;s id. | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

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

api_instance = KindeApi::UsersApi.new
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
  puts "Error when calling UsersApi->get_organization_users: #{e}"
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
  puts "Error when calling UsersApi->get_organization_users_with_http_info: #{e}"
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


## get_user_data

> <User> get_user_data(opts)

Get User

Retrieve a user record. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
opts = {
  id: 'id_example' # String | The user's id.
}

begin
  # Get User
  result = api_instance.get_user_data(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_user_data: #{e}"
end
```

#### Using the get_user_data_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<User>, Integer, Hash)> get_user_data_with_http_info(opts)

```ruby
begin
  # Get User
  data, status_code, headers = api_instance.get_user_data_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <User>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_user_data_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The user&#39;s id. | [optional] |

### Return type

[**User**](User.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_users

> <UsersResponse> get_users(opts)

List Users

The returned list can be sorted by full name or email address in ascending or descending order. The number of records to return at a time can also be controlled using the `page_size` query string parameter. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
opts = {
  sort: 'name_asc', # String | Field and order to sort the result by.
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  user_id: 'user_id_example', # String | ID of the user to filter by.
  next_token: 'next_token_example' # String | A string to get the next page of results if there are more results.
}

begin
  # List Users
  result = api_instance.get_users(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_users: #{e}"
end
```

#### Using the get_users_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<UsersResponse>, Integer, Hash)> get_users_with_http_info(opts)

```ruby
begin
  # List Users
  data, status_code, headers = api_instance.get_users_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <UsersResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_users_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **sort** | **String** | Field and order to sort the result by. | [optional] |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **user_id** | **String** | ID of the user to filter by. | [optional] |
| **next_token** | **String** | A string to get the next page of results if there are more results. | [optional] |

### Return type

[**UsersResponse**](UsersResponse.md)

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

api_instance = KindeApi::UsersApi.new
opts = {
  code: 'code_example', # String | The organization's code.
  remove_organization_users_request: KindeApi::RemoveOrganizationUsersRequest.new # RemoveOrganizationUsersRequest | 
}

begin
  # Remove Users from an Organization
  result = api_instance.remove_organization_users(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->remove_organization_users: #{e}"
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
  puts "Error when calling UsersApi->remove_organization_users_with_http_info: #{e}"
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


## update_user

> <User> update_user(update_user_request, opts)

Update User

Update a user record. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
update_user_request = KindeApi::UpdateUserRequest.new # UpdateUserRequest | The user to update.
opts = {
  id: 'id_example' # String | The user's id.
}

begin
  # Update User
  result = api_instance.update_user(update_user_request, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->update_user: #{e}"
end
```

#### Using the update_user_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<User>, Integer, Hash)> update_user_with_http_info(update_user_request, opts)

```ruby
begin
  # Update User
  data, status_code, headers = api_instance.update_user_with_http_info(update_user_request, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <User>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->update_user_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **update_user_request** | [**UpdateUserRequest**](UpdateUserRequest.md) | The user to update. |  |
| **id** | **String** | The user&#39;s id. | [optional] |

### Return type

[**User**](User.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8

