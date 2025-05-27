# KindeApi::ConnectedAppsApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_connected_app_auth_url**](ConnectedAppsApi.md#get_connected_app_auth_url) | **GET** /api/v1/connected_apps/auth_url | Get Connected App URL |
| [**get_connected_app_token**](ConnectedAppsApi.md#get_connected_app_token) | **GET** /api/v1/connected_apps/token | Get Connected App Token |
| [**revoke_connected_app_token**](ConnectedAppsApi.md#revoke_connected_app_token) | **POST** /api/v1/connected_apps/revoke | Revoke Connected App Token |


## get_connected_app_auth_url

> <ConnectedAppsAuthUrl> get_connected_app_auth_url(key_code_ref, opts)

Get Connected App URL

Get a URL that authenticates and authorizes a user to a third-party connected app.  <div>   <code>read:connected_apps</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::ConnectedAppsApi.new
key_code_ref = 'key_code_ref_example' # String | The unique key code reference of the connected app to authenticate against.
opts = {
  user_id: 'user_id_example', # String | The id of the user that needs to authenticate to the third-party connected app.
  org_code: 'org_code_example', # String | The code of the Kinde organization that needs to authenticate to the third-party connected app.
  override_callback_url: 'override_callback_url_example' # String | A URL that overrides the default callback URL setup in your connected app configuration
}

begin
  # Get Connected App URL
  result = api_instance.get_connected_app_auth_url(key_code_ref, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectedAppsApi->get_connected_app_auth_url: #{e}"
end
```

#### Using the get_connected_app_auth_url_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<ConnectedAppsAuthUrl>, Integer, Hash)> get_connected_app_auth_url_with_http_info(key_code_ref, opts)

```ruby
begin
  # Get Connected App URL
  data, status_code, headers = api_instance.get_connected_app_auth_url_with_http_info(key_code_ref, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <ConnectedAppsAuthUrl>
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectedAppsApi->get_connected_app_auth_url_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **key_code_ref** | **String** | The unique key code reference of the connected app to authenticate against. |  |
| **user_id** | **String** | The id of the user that needs to authenticate to the third-party connected app. | [optional] |
| **org_code** | **String** | The code of the Kinde organization that needs to authenticate to the third-party connected app. | [optional] |
| **override_callback_url** | **String** | A URL that overrides the default callback URL setup in your connected app configuration | [optional] |

### Return type

[**ConnectedAppsAuthUrl**](ConnectedAppsAuthUrl.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_connected_app_token

> <ConnectedAppsAccessToken> get_connected_app_token(session_id)

Get Connected App Token

Get an access token that can be used to call the third-party provider linked to the connected app.  <div>   <code>read:connected_apps</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::ConnectedAppsApi.new
session_id = 'session_id_example' # String | The unique sesssion id representing the login session of a user.

begin
  # Get Connected App Token
  result = api_instance.get_connected_app_token(session_id)
  p result
rescue KindeApi::ApiError => e
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
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectedAppsApi->get_connected_app_token_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The unique sesssion id representing the login session of a user. |  |

### Return type

[**ConnectedAppsAccessToken**](ConnectedAppsAccessToken.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## revoke_connected_app_token

> <SuccessResponse> revoke_connected_app_token(session_id)

Revoke Connected App Token

Revoke the tokens linked to the connected app session.  <div>   <code>create:connected_apps</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::ConnectedAppsApi.new
session_id = 'session_id_example' # String | The unique sesssion id representing the login session of a user.

begin
  # Revoke Connected App Token
  result = api_instance.revoke_connected_app_token(session_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectedAppsApi->revoke_connected_app_token: #{e}"
end
```

#### Using the revoke_connected_app_token_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> revoke_connected_app_token_with_http_info(session_id)

```ruby
begin
  # Revoke Connected App Token
  data, status_code, headers = api_instance.revoke_connected_app_token_with_http_info(session_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectedAppsApi->revoke_connected_app_token_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **session_id** | **String** | The unique sesssion id representing the login session of a user. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8

