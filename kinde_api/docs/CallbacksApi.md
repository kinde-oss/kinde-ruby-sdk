# KindeApi::CallbacksApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**add_logout_redirect_urls**](CallbacksApi.md#add_logout_redirect_urls) | **POST** /api/v1/applications/{app_id}/auth_logout_urls | Add Logout Redirect URLs |
| [**add_redirect_callback_urls**](CallbacksApi.md#add_redirect_callback_urls) | **POST** /api/v1/applications/{app_id}/auth_redirect_urls | Add Redirect Callback URLs |
| [**delete_callback_urls**](CallbacksApi.md#delete_callback_urls) | **DELETE** /api/v1/applications/{app_id}/auth_redirect_urls | Delete Callback URLs |
| [**delete_logout_urls**](CallbacksApi.md#delete_logout_urls) | **DELETE** /api/v1/applications/{app_id}/auth_logout_urls | Delete Logout URLs |
| [**get_callback_urls**](CallbacksApi.md#get_callback_urls) | **GET** /api/v1/applications/{app_id}/auth_redirect_urls | List Callback URLs |
| [**get_logout_urls**](CallbacksApi.md#get_logout_urls) | **GET** /api/v1/applications/{app_id}/auth_logout_urls | List Logout URLs |
| [**replace_logout_redirect_urls**](CallbacksApi.md#replace_logout_redirect_urls) | **PUT** /api/v1/applications/{app_id}/auth_logout_urls | Replace Logout Redirect URLs |
| [**replace_redirect_callback_urls**](CallbacksApi.md#replace_redirect_callback_urls) | **PUT** /api/v1/applications/{app_id}/auth_redirect_urls | Replace Redirect Callback URLs |


## add_logout_redirect_urls

> <SuccessResponse> add_logout_redirect_urls(app_id, replace_logout_redirect_urls_request)

Add Logout Redirect URLs

Add additional logout redirect URLs. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::CallbacksApi.new
app_id = 'app_id_example' # String | The identifier for the application.
replace_logout_redirect_urls_request = KindeApi::ReplaceLogoutRedirectURLsRequest.new # ReplaceLogoutRedirectURLsRequest | Callback details.

begin
  # Add Logout Redirect URLs
  result = api_instance.add_logout_redirect_urls(app_id, replace_logout_redirect_urls_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->add_logout_redirect_urls: #{e}"
end
```

#### Using the add_logout_redirect_urls_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> add_logout_redirect_urls_with_http_info(app_id, replace_logout_redirect_urls_request)

```ruby
begin
  # Add Logout Redirect URLs
  data, status_code, headers = api_instance.add_logout_redirect_urls_with_http_info(app_id, replace_logout_redirect_urls_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->add_logout_redirect_urls_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **app_id** | **String** | The identifier for the application. |  |
| **replace_logout_redirect_urls_request** | [**ReplaceLogoutRedirectURLsRequest**](ReplaceLogoutRedirectURLsRequest.md) | Callback details. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json; charset=utf-8


## add_redirect_callback_urls

> <SuccessResponse> add_redirect_callback_urls(app_id, replace_redirect_callback_urls_request)

Add Redirect Callback URLs

Add additional redirect callback URLs. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::CallbacksApi.new
app_id = 'app_id_example' # String | The identifier for the application.
replace_redirect_callback_urls_request = KindeApi::ReplaceRedirectCallbackURLsRequest.new # ReplaceRedirectCallbackURLsRequest | Callback details.

begin
  # Add Redirect Callback URLs
  result = api_instance.add_redirect_callback_urls(app_id, replace_redirect_callback_urls_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->add_redirect_callback_urls: #{e}"
end
```

#### Using the add_redirect_callback_urls_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> add_redirect_callback_urls_with_http_info(app_id, replace_redirect_callback_urls_request)

```ruby
begin
  # Add Redirect Callback URLs
  data, status_code, headers = api_instance.add_redirect_callback_urls_with_http_info(app_id, replace_redirect_callback_urls_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->add_redirect_callback_urls_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **app_id** | **String** | The identifier for the application. |  |
| **replace_redirect_callback_urls_request** | [**ReplaceRedirectCallbackURLsRequest**](ReplaceRedirectCallbackURLsRequest.md) | Callback details. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json; charset=utf-8


## delete_callback_urls

> <SuccessResponse> delete_callback_urls(app_id, urls)

Delete Callback URLs

Delete callback URLs. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::CallbacksApi.new
app_id = 'app_id_example' # String | The identifier for the application.
urls = 'urls_example' # String | Urls to delete, comma separated and url encoded.

begin
  # Delete Callback URLs
  result = api_instance.delete_callback_urls(app_id, urls)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->delete_callback_urls: #{e}"
end
```

#### Using the delete_callback_urls_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_callback_urls_with_http_info(app_id, urls)

```ruby
begin
  # Delete Callback URLs
  data, status_code, headers = api_instance.delete_callback_urls_with_http_info(app_id, urls)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->delete_callback_urls_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **app_id** | **String** | The identifier for the application. |  |
| **urls** | **String** | Urls to delete, comma separated and url encoded. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## delete_logout_urls

> <SuccessResponse> delete_logout_urls(app_id, urls)

Delete Logout URLs

Delete logout URLs. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::CallbacksApi.new
app_id = 'app_id_example' # String | The identifier for the application.
urls = 'urls_example' # String | Urls to delete, comma separated and url encoded.

begin
  # Delete Logout URLs
  result = api_instance.delete_logout_urls(app_id, urls)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->delete_logout_urls: #{e}"
end
```

#### Using the delete_logout_urls_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_logout_urls_with_http_info(app_id, urls)

```ruby
begin
  # Delete Logout URLs
  data, status_code, headers = api_instance.delete_logout_urls_with_http_info(app_id, urls)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->delete_logout_urls_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **app_id** | **String** | The identifier for the application. |  |
| **urls** | **String** | Urls to delete, comma separated and url encoded. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_callback_urls

> <RedirectCallbackUrls> get_callback_urls(app_id)

List Callback URLs

Returns an application's redirect callback URLs. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::CallbacksApi.new
app_id = 'app_id_example' # String | The identifier for the application.

begin
  # List Callback URLs
  result = api_instance.get_callback_urls(app_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->get_callback_urls: #{e}"
end
```

#### Using the get_callback_urls_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<RedirectCallbackUrls>, Integer, Hash)> get_callback_urls_with_http_info(app_id)

```ruby
begin
  # List Callback URLs
  data, status_code, headers = api_instance.get_callback_urls_with_http_info(app_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <RedirectCallbackUrls>
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->get_callback_urls_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **app_id** | **String** | The identifier for the application. |  |

### Return type

[**RedirectCallbackUrls**](RedirectCallbackUrls.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_logout_urls

> <LogoutRedirectUrls> get_logout_urls(app_id)

List Logout URLs

Returns an application's logout redirect URLs. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::CallbacksApi.new
app_id = 'app_id_example' # String | The identifier for the application.

begin
  # List Logout URLs
  result = api_instance.get_logout_urls(app_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->get_logout_urls: #{e}"
end
```

#### Using the get_logout_urls_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<LogoutRedirectUrls>, Integer, Hash)> get_logout_urls_with_http_info(app_id)

```ruby
begin
  # List Logout URLs
  data, status_code, headers = api_instance.get_logout_urls_with_http_info(app_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <LogoutRedirectUrls>
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->get_logout_urls_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **app_id** | **String** | The identifier for the application. |  |

### Return type

[**LogoutRedirectUrls**](LogoutRedirectUrls.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## replace_logout_redirect_urls

> <SuccessResponse> replace_logout_redirect_urls(app_id, replace_logout_redirect_urls_request)

Replace Logout Redirect URLs

Replace all logout redirect URLs. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::CallbacksApi.new
app_id = 'app_id_example' # String | The identifier for the application.
replace_logout_redirect_urls_request = KindeApi::ReplaceLogoutRedirectURLsRequest.new # ReplaceLogoutRedirectURLsRequest | Callback details.

begin
  # Replace Logout Redirect URLs
  result = api_instance.replace_logout_redirect_urls(app_id, replace_logout_redirect_urls_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->replace_logout_redirect_urls: #{e}"
end
```

#### Using the replace_logout_redirect_urls_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> replace_logout_redirect_urls_with_http_info(app_id, replace_logout_redirect_urls_request)

```ruby
begin
  # Replace Logout Redirect URLs
  data, status_code, headers = api_instance.replace_logout_redirect_urls_with_http_info(app_id, replace_logout_redirect_urls_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->replace_logout_redirect_urls_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **app_id** | **String** | The identifier for the application. |  |
| **replace_logout_redirect_urls_request** | [**ReplaceLogoutRedirectURLsRequest**](ReplaceLogoutRedirectURLsRequest.md) | Callback details. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json; charset=utf-8


## replace_redirect_callback_urls

> <SuccessResponse> replace_redirect_callback_urls(app_id, replace_redirect_callback_urls_request)

Replace Redirect Callback URLs

Replace all redirect callback URLs. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::CallbacksApi.new
app_id = 'app_id_example' # String | The identifier for the application.
replace_redirect_callback_urls_request = KindeApi::ReplaceRedirectCallbackURLsRequest.new # ReplaceRedirectCallbackURLsRequest | Callback details.

begin
  # Replace Redirect Callback URLs
  result = api_instance.replace_redirect_callback_urls(app_id, replace_redirect_callback_urls_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->replace_redirect_callback_urls: #{e}"
end
```

#### Using the replace_redirect_callback_urls_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> replace_redirect_callback_urls_with_http_info(app_id, replace_redirect_callback_urls_request)

```ruby
begin
  # Replace Redirect Callback URLs
  data, status_code, headers = api_instance.replace_redirect_callback_urls_with_http_info(app_id, replace_redirect_callback_urls_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->replace_redirect_callback_urls_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **app_id** | **String** | The identifier for the application. |  |
| **replace_redirect_callback_urls_request** | [**ReplaceRedirectCallbackURLsRequest**](ReplaceRedirectCallbackURLsRequest.md) | Callback details. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json; charset=utf-8

