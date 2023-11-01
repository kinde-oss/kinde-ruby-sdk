# KindeApi::OAuthApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_user**](OAuthApi.md#get_user) | **GET** /oauth2/user_profile | Get User Profile |
| [**get_user_profile_v2**](OAuthApi.md#get_user_profile_v2) | **GET** /oauth2/v2/user_profile | Returns the details of the currently logged in user |
| [**token_introspection**](OAuthApi.md#token_introspection) | **POST** /oauth2/introspect | Get token details |
| [**token_revocation**](OAuthApi.md#token_revocation) | **POST** /oauth2/revoke | Revoke token |


## get_user

> <UserProfile> get_user

Get User Profile

Contains the id, names and email of the currently logged in user. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OAuthApi.new

begin
  # Get User Profile
  result = api_instance.get_user
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OAuthApi->get_user: #{e}"
end
```

#### Using the get_user_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<UserProfile>, Integer, Hash)> get_user_with_http_info

```ruby
begin
  # Get User Profile
  data, status_code, headers = api_instance.get_user_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <UserProfile>
rescue KindeApi::ApiError => e
  puts "Error when calling OAuthApi->get_user_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**UserProfile**](UserProfile.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_user_profile_v2

> <UserProfileV2> get_user_profile_v2

Returns the details of the currently logged in user

Contains the id, names, profile picture URL and email of the currently logged in user. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OAuthApi.new

begin
  # Returns the details of the currently logged in user
  result = api_instance.get_user_profile_v2
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OAuthApi->get_user_profile_v2: #{e}"
end
```

#### Using the get_user_profile_v2_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<UserProfileV2>, Integer, Hash)> get_user_profile_v2_with_http_info

```ruby
begin
  # Returns the details of the currently logged in user
  data, status_code, headers = api_instance.get_user_profile_v2_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <UserProfileV2>
rescue KindeApi::ApiError => e
  puts "Error when calling OAuthApi->get_user_profile_v2_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**UserProfileV2**](UserProfileV2.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## token_introspection

> <TokenIntrospect> token_introspection(opts)

Get token details

Retrieve information about the provided token.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OAuthApi.new
opts = {
  token: 'token_example', # String | The token to be introspected.
  token_type: 'token_type_example' # String | The provided token's type.
}

begin
  # Get token details
  result = api_instance.token_introspection(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling OAuthApi->token_introspection: #{e}"
end
```

#### Using the token_introspection_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<TokenIntrospect>, Integer, Hash)> token_introspection_with_http_info(opts)

```ruby
begin
  # Get token details
  data, status_code, headers = api_instance.token_introspection_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <TokenIntrospect>
rescue KindeApi::ApiError => e
  puts "Error when calling OAuthApi->token_introspection_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **token** | **String** | The token to be introspected. | [optional] |
| **token_type** | **String** | The provided token&#39;s type. | [optional] |

### Return type

[**TokenIntrospect**](TokenIntrospect.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/x-www-form-urlencoded
- **Accept**: application/json, application/json; charset=utf-8


## token_revocation

> token_revocation(opts)

Revoke token

Revoke a previously issued token.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::OAuthApi.new
opts = {
  token: 'token_example', # String | The token to be revoked.
  client_id: 'client_id_example', # String | The identifier for your client.
  client_secret: 'client_secret_example' # String | The secret associated with your client.
}

begin
  # Revoke token
  api_instance.token_revocation(opts)
rescue KindeApi::ApiError => e
  puts "Error when calling OAuthApi->token_revocation: #{e}"
end
```

#### Using the token_revocation_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> token_revocation_with_http_info(opts)

```ruby
begin
  # Revoke token
  data, status_code, headers = api_instance.token_revocation_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeApi::ApiError => e
  puts "Error when calling OAuthApi->token_revocation_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **token** | **String** | The token to be revoked. | [optional] |
| **client_id** | **String** | The identifier for your client. | [optional] |
| **client_secret** | **String** | The secret associated with your client. | [optional] |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/x-www-form-urlencoded
- **Accept**: application/json, application/json; charset=utf-8

