# KindeApi::FeatureFlagsApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_feature_flag**](FeatureFlagsApi.md#create_feature_flag) | **POST** /api/v1/feature_flags | Create a new feature flag |
| [**delete_feature_flag**](FeatureFlagsApi.md#delete_feature_flag) | **DELETE** /api/v1/feature_flags/{feature_flag_key} | Delete a feature flag |
| [**update_feature_flag**](FeatureFlagsApi.md#update_feature_flag) | **PUT** /api/v1/feature_flags/{feature_flag_key} | Update a feature flag |


## create_feature_flag

> <SuccessResponse> create_feature_flag(name, description, key, type, allow_override_level, default_value)

Create a new feature flag

Create feature flag.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::FeatureFlagsApi.new
name = 'name_example' # String | The name of the flag.
description = 'description_example' # String | Description of the flag purpose.
key = 'key_example' # String | The flag identifier to use in code.
type = 'str' # String | The variable type.
allow_override_level = 'env' # String | Allow the flag to be overridden at a different level.
default_value = 'default_value_example' # String | Default value for the flag used by environments and organizations.

begin
  # Create a new feature flag
  result = api_instance.create_feature_flag(name, description, key, type, allow_override_level, default_value)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling FeatureFlagsApi->create_feature_flag: #{e}"
end
```

#### Using the create_feature_flag_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> create_feature_flag_with_http_info(name, description, key, type, allow_override_level, default_value)

```ruby
begin
  # Create a new feature flag
  data, status_code, headers = api_instance.create_feature_flag_with_http_info(name, description, key, type, allow_override_level, default_value)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling FeatureFlagsApi->create_feature_flag_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | The name of the flag. |  |
| **description** | **String** | Description of the flag purpose. |  |
| **key** | **String** | The flag identifier to use in code. |  |
| **type** | **String** | The variable type. |  |
| **allow_override_level** | **String** | Allow the flag to be overridden at a different level. |  |
| **default_value** | **String** | Default value for the flag used by environments and organizations. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## delete_feature_flag

> <SuccessResponse> delete_feature_flag(feature_flag_key)

Delete a feature flag

Delete feature flag

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::FeatureFlagsApi.new
feature_flag_key = 'feature_flag_key_example' # String | The identifier for the feature flag.

begin
  # Delete a feature flag
  result = api_instance.delete_feature_flag(feature_flag_key)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling FeatureFlagsApi->delete_feature_flag: #{e}"
end
```

#### Using the delete_feature_flag_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_feature_flag_with_http_info(feature_flag_key)

```ruby
begin
  # Delete a feature flag
  data, status_code, headers = api_instance.delete_feature_flag_with_http_info(feature_flag_key)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling FeatureFlagsApi->delete_feature_flag_with_http_info: #{e}"
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


## update_feature_flag

> <SuccessResponse> update_feature_flag(feature_flag_key, name, description, type, allow_override_level, default_value)

Update a feature flag

Update feature flag.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::FeatureFlagsApi.new
feature_flag_key = 'feature_flag_key_example' # String | The key identifier for the feature flag.
name = 'name_example' # String | The name of the flag.
description = 'description_example' # String | Description of the flag purpose.
type = 'str' # String | The variable type
allow_override_level = 'env' # String | Allow the flag to be overridden at a different level.
default_value = 'default_value_example' # String | Default value for the flag used by environments and organizations.

begin
  # Update a feature flag
  result = api_instance.update_feature_flag(feature_flag_key, name, description, type, allow_override_level, default_value)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling FeatureFlagsApi->update_feature_flag: #{e}"
end
```

#### Using the update_feature_flag_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_feature_flag_with_http_info(feature_flag_key, name, description, type, allow_override_level, default_value)

```ruby
begin
  # Update a feature flag
  data, status_code, headers = api_instance.update_feature_flag_with_http_info(feature_flag_key, name, description, type, allow_override_level, default_value)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling FeatureFlagsApi->update_feature_flag_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **feature_flag_key** | **String** | The key identifier for the feature flag. |  |
| **name** | **String** | The name of the flag. |  |
| **description** | **String** | Description of the flag purpose. |  |
| **type** | **String** | The variable type |  |
| **allow_override_level** | **String** | Allow the flag to be overridden at a different level. |  |
| **default_value** | **String** | Default value for the flag used by environments and organizations. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8

