# KindeFrontendApi::OAuthApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_user_profile_v2**](OAuthApi.md#get_user_profile_v2) | **GET** /oauth2/v2/user_profile | Get user profile |
| [**token_introspection**](OAuthApi.md#token_introspection) | **POST** /oauth2/introspect | Introspect |
| [**token_revocation**](OAuthApi.md#token_revocation) | **POST** /oauth2/revoke | Revoke token |


## get_user_profile_v2

> <UserProfileV2> get_user_profile_v2

Get user profile

This endpoint returns a user's ID, names, profile picture URL and email of the currently logged in user. 

### Examples

```ruby
require 'time'
require 'kinde_frontend_api'
# setup authorization
KindeFrontendApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeFrontendApi::OAuthApi.new

begin
  # Get user profile
  result = api_instance.get_user_profile_v2
  p result
rescue KindeFrontendApi::ApiError => e
  puts "Error when calling OAuthApi->get_user_profile_v2: #{e}"
end
```

#### Using the get_user_profile_v2_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<UserProfileV2>, Integer, Hash)> get_user_profile_v2_with_http_info

```ruby
begin
  # Get user profile
  data, status_code, headers = api_instance.get_user_profile_v2_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <UserProfileV2>
rescue KindeFrontendApi::ApiError => e
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

> <TokenIntrospect> token_introspection(token, opts)

Introspect

Retrieve information about the provided token.

### Examples

```ruby
require 'time'
require 'kinde_frontend_api'
# setup authorization
KindeFrontendApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeFrontendApi::OAuthApi.new
token = 'token_example' # String | The token to be introspected.
opts = {
  token_type_hint: 'access_token' # String | A hint about the token type being queried in the request.
}

begin
  # Introspect
  result = api_instance.token_introspection(token, opts)
  p result
rescue KindeFrontendApi::ApiError => e
  puts "Error when calling OAuthApi->token_introspection: #{e}"
end
```

#### Using the token_introspection_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<TokenIntrospect>, Integer, Hash)> token_introspection_with_http_info(token, opts)

```ruby
begin
  # Introspect
  data, status_code, headers = api_instance.token_introspection_with_http_info(token, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <TokenIntrospect>
rescue KindeFrontendApi::ApiError => e
  puts "Error when calling OAuthApi->token_introspection_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **token** | **String** | The token to be introspected. |  |
| **token_type_hint** | **String** | A hint about the token type being queried in the request. | [optional] |

### Return type

[**TokenIntrospect**](TokenIntrospect.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/x-www-form-urlencoded
- **Accept**: application/json, application/json; charset=utf-8


## token_revocation

> token_revocation(client_id, token, opts)

Revoke token

Use this endpoint to invalidate an access or refresh token. The token will no longer be valid for use.

### Examples

```ruby
require 'time'
require 'kinde_frontend_api'
# setup authorization
KindeFrontendApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeFrontendApi::OAuthApi.new
client_id = 'client_id_example' # String | The `client_id` of your application.
token = 'token_example' # String | The token to be revoked.
opts = {
  client_secret: 'client_secret_example', # String | The `client_secret` of your application. Required for backend apps only.
  token_type_hint: 'access_token' # String | The type of token to be revoked.
}

begin
  # Revoke token
  api_instance.token_revocation(client_id, token, opts)
rescue KindeFrontendApi::ApiError => e
  puts "Error when calling OAuthApi->token_revocation: #{e}"
end
```

#### Using the token_revocation_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> token_revocation_with_http_info(client_id, token, opts)

```ruby
begin
  # Revoke token
  data, status_code, headers = api_instance.token_revocation_with_http_info(client_id, token, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeFrontendApi::ApiError => e
  puts "Error when calling OAuthApi->token_revocation_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **client_id** | **String** | The &#x60;client_id&#x60; of your application. |  |
| **token** | **String** | The token to be revoked. |  |
| **client_secret** | **String** | The &#x60;client_secret&#x60; of your application. Required for backend apps only. | [optional] |
| **token_type_hint** | **String** | The type of token to be revoked. | [optional] |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/x-www-form-urlencoded
- **Accept**: application/json

