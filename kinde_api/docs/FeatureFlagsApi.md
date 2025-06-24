# KindeApi::FeatureFlagsApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_feature_flag**](FeatureFlagsApi.md#create_feature_flag) | **POST** /api/v1/feature_flags | Create Feature Flag |
| [**delete_feature_flag**](FeatureFlagsApi.md#delete_feature_flag) | **DELETE** /api/v1/feature_flags/{feature_flag_key} | Delete Feature Flag |
| [**get_feature_flags**](FeatureFlagsApi.md#get_feature_flags) | **GET** /account_api/v1/feature_flags | Get feature flags |
| [**update_feature_flag**](FeatureFlagsApi.md#update_feature_flag) | **PUT** /api/v1/feature_flags/{feature_flag_key} | Replace Feature Flag |


## create_feature_flag

> <SuccessResponse> create_feature_flag(create_feature_flag_request)

Create Feature Flag

Create feature flag.  <div>   <code>create:feature_flags</code> </div> 

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
create_feature_flag_request = KindeApi::CreateFeatureFlagRequest.new({name: 'name_example', key: 'key_example', type: 'str', default_value: 'default_value_example'}) # CreateFeatureFlagRequest | Flag details.

begin
  # Create Feature Flag
  result = api_instance.create_feature_flag(create_feature_flag_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling FeatureFlagsApi->create_feature_flag: #{e}"
end
```

#### Using the create_feature_flag_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> create_feature_flag_with_http_info(create_feature_flag_request)

```ruby
begin
  # Create Feature Flag
  data, status_code, headers = api_instance.create_feature_flag_with_http_info(create_feature_flag_request)
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
| **create_feature_flag_request** | [**CreateFeatureFlagRequest**](CreateFeatureFlagRequest.md) | Flag details. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## delete_feature_flag

> <SuccessResponse> delete_feature_flag(feature_flag_key)

Delete Feature Flag

Delete feature flag  <div>   <code>delete:feature_flags</code> </div> 

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
  # Delete Feature Flag
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
  # Delete Feature Flag
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


## get_feature_flags

> <GetFeatureFlagsResponse> get_feature_flags(opts)

Get feature flags

Returns all the feature flags that affect the user 

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
opts = {
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  starting_after: 'flag_1234567890abcdef' # String | The ID of the flag to start after.
}

begin
  # Get feature flags
  result = api_instance.get_feature_flags(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling FeatureFlagsApi->get_feature_flags: #{e}"
end
```

#### Using the get_feature_flags_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetFeatureFlagsResponse>, Integer, Hash)> get_feature_flags_with_http_info(opts)

```ruby
begin
  # Get feature flags
  data, status_code, headers = api_instance.get_feature_flags_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetFeatureFlagsResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling FeatureFlagsApi->get_feature_flags_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **starting_after** | **String** | The ID of the flag to start after. | [optional] |

### Return type

[**GetFeatureFlagsResponse**](GetFeatureFlagsResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## update_feature_flag

> <SuccessResponse> update_feature_flag(feature_flag_key, name, description, type, allow_override_level, default_value)

Replace Feature Flag

Update feature flag.  <div>   <code>update:feature_flags</code> </div> 

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
  # Replace Feature Flag
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
  # Replace Feature Flag
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

