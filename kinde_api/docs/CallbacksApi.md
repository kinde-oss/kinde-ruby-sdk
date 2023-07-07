# KindeApi::CallbacksApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**add_redirect_callback_urls**](CallbacksApi.md#add_redirect_callback_urls) | **POST** /api/v1/applications/{app_id}/auth_redirect_urls | Add Redirect Callback URLs |
| [**get_callback_urls**](CallbacksApi.md#get_callback_urls) | **GET** /api/v1/applications/{app_id}/auth_redirect_urls | List Callback URLs |
| [**replace_redirect_callback_urls**](CallbacksApi.md#replace_redirect_callback_urls) | **PUT** /api/v1/applications/{app_id}/auth_redirect_urls | Replace redirect callback URLs |


## add_redirect_callback_urls

> add_redirect_callback_urls(app_id, urls)

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
urls = ['inner_example'] # Array<String> | Array of callback urls.

begin
  # Add Redirect Callback URLs
  api_instance.add_redirect_callback_urls(app_id, urls)
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->add_redirect_callback_urls: #{e}"
end
```

#### Using the add_redirect_callback_urls_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> add_redirect_callback_urls_with_http_info(app_id, urls)

```ruby
begin
  # Add Redirect Callback URLs
  data, status_code, headers = api_instance.add_redirect_callback_urls_with_http_info(app_id, urls)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->add_redirect_callback_urls_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **app_id** | **String** | The identifier for the application. |  |
| **urls** | [**Array&lt;String&gt;**](String.md) | Array of callback urls. |  |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: Not defined


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
- **Accept**: application/json; charset=utf-8


## replace_redirect_callback_urls

> replace_redirect_callback_urls(app_id, urls)

Replace redirect callback URLs

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
urls = ['inner_example'] # Array<String> | Array of callback urls.

begin
  # Replace redirect callback URLs
  api_instance.replace_redirect_callback_urls(app_id, urls)
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->replace_redirect_callback_urls: #{e}"
end
```

#### Using the replace_redirect_callback_urls_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> replace_redirect_callback_urls_with_http_info(app_id, urls)

```ruby
begin
  # Replace redirect callback URLs
  data, status_code, headers = api_instance.replace_redirect_callback_urls_with_http_info(app_id, urls)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeApi::ApiError => e
  puts "Error when calling CallbacksApi->replace_redirect_callback_urls_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **app_id** | **String** | The identifier for the application. |  |
| **urls** | [**Array&lt;String&gt;**](String.md) | Array of callback urls. |  |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: Not defined

