# KindeApi::EnvironmentsApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**delete_environement_feature_flag_override**](EnvironmentsApi.md#delete_environement_feature_flag_override) | **DELETE** /api/v1/environment/feature_flags/{feature_flag_key} | Delete environment feature flag override |
| [**delete_environement_feature_flag_overrides**](EnvironmentsApi.md#delete_environement_feature_flag_overrides) | **DELETE** /api/v1/environment/feature_flags/ | Delete all environment feature flag overrides |
| [**update_environement_feature_flag_override**](EnvironmentsApi.md#update_environement_feature_flag_override) | **PATCH** /api/v1/environment/feature_flags/{feature_flag_key} | Update environment feature flag override |


## delete_environement_feature_flag_override

> <SuccessResponse> delete_environement_feature_flag_override(feature_flag_key)

Delete environment feature flag override

Delete environment feature flag override.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::EnvironmentsApi.new
feature_flag_key = 'feature_flag_key_example' # String | The identifier for the feature flag.

begin
  # Delete environment feature flag override
  result = api_instance.delete_environement_feature_flag_override(feature_flag_key)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->delete_environement_feature_flag_override: #{e}"
end
```

#### Using the delete_environement_feature_flag_override_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_environement_feature_flag_override_with_http_info(feature_flag_key)

```ruby
begin
  # Delete environment feature flag override
  data, status_code, headers = api_instance.delete_environement_feature_flag_override_with_http_info(feature_flag_key)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->delete_environement_feature_flag_override_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **feature_flag_key** | **String** | The identifier for the feature flag. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## delete_environement_feature_flag_overrides

> <SuccessResponse> delete_environement_feature_flag_overrides

Delete all environment feature flag overrides

Delete all environment feature flag overrides.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::EnvironmentsApi.new

begin
  # Delete all environment feature flag overrides
  result = api_instance.delete_environement_feature_flag_overrides
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->delete_environement_feature_flag_overrides: #{e}"
end
```

#### Using the delete_environement_feature_flag_overrides_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_environement_feature_flag_overrides_with_http_info

```ruby
begin
  # Delete all environment feature flag overrides
  data, status_code, headers = api_instance.delete_environement_feature_flag_overrides_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->delete_environement_feature_flag_overrides_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## update_environement_feature_flag_override

> <SuccessResponse> update_environement_feature_flag_override(feature_flag_key, value)

Update environment feature flag override

Update environment feature flag override.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::EnvironmentsApi.new
feature_flag_key = 'feature_flag_key_example' # String | The identifier for the feature flag.
value = 'value_example' # String | The override value for the feature flag.

begin
  # Update environment feature flag override
  result = api_instance.update_environement_feature_flag_override(feature_flag_key, value)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->update_environement_feature_flag_override: #{e}"
end
```

#### Using the update_environement_feature_flag_override_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_environement_feature_flag_override_with_http_info(feature_flag_key, value)

```ruby
begin
  # Update environment feature flag override
  data, status_code, headers = api_instance.update_environement_feature_flag_override_with_http_info(feature_flag_key, value)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->update_environement_feature_flag_override_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **feature_flag_key** | **String** | The identifier for the feature flag. |  |
| **value** | **String** | The override value for the feature flag. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8

