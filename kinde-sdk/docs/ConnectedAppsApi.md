# KindeSdk::ConnectedAppsApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_connected_app_auth_url**](ConnectedAppsApi.md#get_connected_app_auth_url) | **GET** /api/v1/connected_apps/auth_url | Get Connected App URL |
| [**get_connected_app_token**](ConnectedAppsApi.md#get_connected_app_token) | **GET** /api/v1/connected_apps/token | Get Connected App Token |
| [**revoke_connected_app_token**](ConnectedAppsApi.md#revoke_connected_app_token) | **POST** /api/v1/connected_apps/revoke | Revoke Connected App Token |


## get_connected_app_auth_url

> <ConnectedAppsAuthUrl> get_connected_app_auth_url(key_code_ref, user_id)

Get Connected App URL

Get a URL that authenticates and authorizes a user to a third-party connected app.

### Examples

```ruby
require 'time'
require 'kinde_sdk'
# setup authorization
KindeSdk.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeSdk::ConnectedAppsApi.new
key_code_ref = 'key_code_ref_example' # String | The unique key code reference of the connected app to authenticate against.
user_id = 56 # Integer | The id of the user that needs to authenticate to the third-party connected app.

begin
  # Get Connected App URL
  result = api_instance.get_connected_app_auth_url(key_code_ref, user_id)
  p result
rescue KindeSdk::ApiError => e
  puts "Error when calling ConnectedAppsApi->get_connected_app_auth_url: #{e}"
end
```

#### Using the get_connected_app_auth_url_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<ConnectedAppsAuthUrl>, Integer, Hash)> get_connected_app_auth_url_with_http_info(key_code_ref, user_id)

```ruby
begin
  # Get Connected App URL
  data, status_code, headers = api_instance.get_connected_app_auth_url_with_http_info(key_code_ref, user_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <ConnectedAppsAuthUrl>
rescue KindeSdk::ApiError => e
  puts "Error when calling ConnectedAppsApi->get_connected_app_auth_url_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **key_code_ref** | **String** | The unique key code reference of the connected app to authenticate against. |  |
| **user_id** | **Integer** | The id of the user that needs to authenticate to the third-party connected app. |  |

### Return type

[**ConnectedAppsAuthUrl**](ConnectedAppsAuthUrl.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_connected_app_token

> <ConnectedAppsAccessToken> get_connected_app_token(session_id)

Get Connected App Token

Get an access token that can be used to call the third-party provider linked to the connected app.

### Examples

```ruby
require 'time'
require 'kinde_sdk'
# setup authorization
KindeSdk.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeSdk::ConnectedAppsApi.new
session_id = 'session_id_example' # String | The unique sesssion id reprensenting the login session of a user.

begin
  # Get Connected App Token
  result = api_instance.get_connected_app_token(session_id)
  p result
rescue KindeSdk::ApiError => e
  puts "Error when calling ConnectedAppsApi->get_connected_app_token: #{e}"
end
```

#### Using the get_connected_app_token_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<ConnectedAppsAccessToken>, Integer, Hash)> get_connected_app_token_with_http_info(session_id)

```ruby
begin
  # Get Connected App Token
  data, status_code, headers = api_instance.get_connected_app_token_with_http_info(session_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <ConnectedAppsAccessToken>
rescue KindeSdk::ApiError => e
  puts "Error when calling ConnectedAppsApi->get_connected_app_token_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The unique sesssion id reprensenting the login session of a user. |  |

### Return type

[**ConnectedAppsAccessToken**](ConnectedAppsAccessToken.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## revoke_connected_app_token

> <ApiResult> revoke_connected_app_token(session_id)

Revoke Connected App Token

Revoke the tokens linked to the connected app session.

### Examples

```ruby
require 'time'
require 'kinde_sdk'
# setup authorization
KindeSdk.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeSdk::ConnectedAppsApi.new
session_id = 'session_id_example' # String | The unique sesssion id reprensenting the login session of a user.

begin
  # Revoke Connected App Token
  result = api_instance.revoke_connected_app_token(session_id)
  p result
rescue KindeSdk::ApiError => e
  puts "Error when calling ConnectedAppsApi->revoke_connected_app_token: #{e}"
end
```

#### Using the revoke_connected_app_token_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<ApiResult>, Integer, Hash)> revoke_connected_app_token_with_http_info(session_id)

```ruby
begin
  # Revoke Connected App Token
  data, status_code, headers = api_instance.revoke_connected_app_token_with_http_info(session_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <ApiResult>
rescue KindeSdk::ApiError => e
  puts "Error when calling ConnectedAppsApi->revoke_connected_app_token_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The unique sesssion id reprensenting the login session of a user. |  |

### Return type

[**ApiResult**](ApiResult.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

