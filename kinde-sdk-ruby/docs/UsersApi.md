# KindeSdk::UsersApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_user**](UsersApi.md#create_user) | **POST** /api/v1/user | Creates a user record |
| [**get_users**](UsersApi.md#get_users) | **GET** /api/v1/users | Returns a paginated list of end-user records for a business |


## create_user

> <CreateUser200Response> create_user(opts)

Creates a user record

Creates a user record and optionally zero or more identities for the user. An example identity could be the email address of the user 

### Examples

```ruby
require 'time'
require 'kinde_sdk'
# setup authorization
KindeSdk.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeSdk::UsersApi.new
opts = {
  create_user_request: KindeSdk::CreateUserRequest.new # CreateUserRequest | The details of the user to create
}

begin
  # Creates a user record
  result = api_instance.create_user(opts)
  p result
rescue KindeSdk::ApiError => e
  puts "Error when calling UsersApi->create_user: #{e}"
end
```

#### Using the create_user_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateUser200Response>, Integer, Hash)> create_user_with_http_info(opts)

```ruby
begin
  # Creates a user record
  data, status_code, headers = api_instance.create_user_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateUser200Response>
rescue KindeSdk::ApiError => e
  puts "Error when calling UsersApi->create_user_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_user_request** | [**CreateUserRequest**](CreateUserRequest.md) | The details of the user to create | [optional] |

### Return type

[**CreateUser200Response**](CreateUser200Response.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## get_users

> <Array<User>> get_users(opts)

Returns a paginated list of end-user records for a business

The returned list can be sorted by full name or email address in ascending or descending order. The number of records to return at a time can also be controlled using the page_size query string parameter. 

### Examples

```ruby
require 'time'
require 'kinde_sdk'
# setup authorization
KindeSdk.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeSdk::UsersApi.new
opts = {
  sort: 'name_asc', # String | Describes the field and order to sort the result by
  page_size: 56, # Integer | The number of items to return
  user_id: 56, # Integer | The id of the user to filter by
  next_token: 'next_token_example' # String | A string to get the next page of results if there are more results
}

begin
  # Returns a paginated list of end-user records for a business
  result = api_instance.get_users(opts)
  p result
rescue KindeSdk::ApiError => e
  puts "Error when calling UsersApi->get_users: #{e}"
end
```

#### Using the get_users_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Array<User>>, Integer, Hash)> get_users_with_http_info(opts)

```ruby
begin
  # Returns a paginated list of end-user records for a business
  data, status_code, headers = api_instance.get_users_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Array<User>>
rescue KindeSdk::ApiError => e
  puts "Error when calling UsersApi->get_users_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **sort** | **String** | Describes the field and order to sort the result by | [optional] |
| **page_size** | **Integer** | The number of items to return | [optional] |
| **user_id** | **Integer** | The id of the user to filter by | [optional] |
| **next_token** | **String** | A string to get the next page of results if there are more results | [optional] |

### Return type

[**Array&lt;User&gt;**](User.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

