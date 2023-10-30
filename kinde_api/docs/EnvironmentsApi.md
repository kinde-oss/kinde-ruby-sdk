# KindeApi::EnvironmentsApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**delete_environement_feature_flag_override**](EnvironmentsApi.md#delete_environement_feature_flag_override) | **DELETE** /api/v1/environment/feature_flags/{feature_flag_key} | Delete Environment Feature Flag Override |
| [**delete_environement_feature_flag_overrides**](EnvironmentsApi.md#delete_environement_feature_flag_overrides) | **DELETE** /api/v1/environment/feature_flags | Delete Environment Feature Flag Overrides |
| [**get_environement_feature_flags**](EnvironmentsApi.md#get_environement_feature_flags) | **GET** /api/v1/environment/feature_flags | List Environment Feature Flags |
| [**update_environement_feature_flag_override**](EnvironmentsApi.md#update_environement_feature_flag_override) | **PATCH** /api/v1/environment/feature_flags/{feature_flag_key} | Update Environment Feature Flag Override |


## delete_environement_feature_flag_override

> <SuccessResponse> delete_environement_feature_flag_override(feature_flag_key)

Delete Environment Feature Flag Override

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
  # Delete Environment Feature Flag Override
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
  # Delete Environment Feature Flag Override
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

Delete Environment Feature Flag Overrides

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
  # Delete Environment Feature Flag Overrides
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
  # Delete Environment Feature Flag Overrides
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


## get_environement_feature_flags

> <GetEnvironmentFeatureFlagsResponse> get_environement_feature_flags

List Environment Feature Flags

Get environment feature flags.

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
  # List Environment Feature Flags
  result = api_instance.get_environement_feature_flags
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->get_environement_feature_flags: #{e}"
end
```

#### Using the get_environement_feature_flags_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetEnvironmentFeatureFlagsResponse>, Integer, Hash)> get_environement_feature_flags_with_http_info

```ruby
begin
  # List Environment Feature Flags
  data, status_code, headers = api_instance.get_environement_feature_flags_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetEnvironmentFeatureFlagsResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->get_environement_feature_flags_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**GetEnvironmentFeatureFlagsResponse**](GetEnvironmentFeatureFlagsResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## update_environement_feature_flag_override

> <SuccessResponse> update_environement_feature_flag_override(feature_flag_key, update_environement_feature_flag_override_request)

Update Environment Feature Flag Override

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
update_environement_feature_flag_override_request = KindeApi::UpdateEnvironementFeatureFlagOverrideRequest.new({value: 'value_example'}) # UpdateEnvironementFeatureFlagOverrideRequest | Flag details.

begin
  # Update Environment Feature Flag Override
  result = api_instance.update_environement_feature_flag_override(feature_flag_key, update_environement_feature_flag_override_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->update_environement_feature_flag_override: #{e}"
end
```

#### Using the update_environement_feature_flag_override_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_environement_feature_flag_override_with_http_info(feature_flag_key, update_environement_feature_flag_override_request)

```ruby
begin
  # Update Environment Feature Flag Override
  data, status_code, headers = api_instance.update_environement_feature_flag_override_with_http_info(feature_flag_key, update_environement_feature_flag_override_request)
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
| **update_environement_feature_flag_override_request** | [**UpdateEnvironementFeatureFlagOverrideRequest**](UpdateEnvironementFeatureFlagOverrideRequest.md) | Flag details. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8

