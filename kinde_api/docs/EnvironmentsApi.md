# KindeApi::EnvironmentsApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**add_logo**](EnvironmentsApi.md#add_logo) | **PUT** /api/v1/environment/logos/{type} | Add logo |
| [**delete_environement_feature_flag_override**](EnvironmentsApi.md#delete_environement_feature_flag_override) | **DELETE** /api/v1/environment/feature_flags/{feature_flag_key} | Delete Environment Feature Flag Override |
| [**delete_environement_feature_flag_overrides**](EnvironmentsApi.md#delete_environement_feature_flag_overrides) | **DELETE** /api/v1/environment/feature_flags | Delete Environment Feature Flag Overrides |
| [**delete_logo**](EnvironmentsApi.md#delete_logo) | **DELETE** /api/v1/environment/logos/{type} | Delete logo |
| [**get_environement_feature_flags**](EnvironmentsApi.md#get_environement_feature_flags) | **GET** /api/v1/environment/feature_flags | List Environment Feature Flags |
| [**get_environment**](EnvironmentsApi.md#get_environment) | **GET** /api/v1/environment | Get environment |
| [**read_logo**](EnvironmentsApi.md#read_logo) | **GET** /api/v1/environment/logos | Read logo details |
| [**update_environement_feature_flag_override**](EnvironmentsApi.md#update_environement_feature_flag_override) | **PATCH** /api/v1/environment/feature_flags/{feature_flag_key} | Update Environment Feature Flag Override |


## add_logo

> <SuccessResponse> add_logo(type, logo)

Add logo

Add environment logo  <div>   <code>update:environments</code> </div> 

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
type = 'dark' # String | The type of logo to add.
logo = File.new('/path/to/some/file') # File | The logo file to upload.

begin
  # Add logo
  result = api_instance.add_logo(type, logo)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->add_logo: #{e}"
end
```

#### Using the add_logo_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> add_logo_with_http_info(type, logo)

```ruby
begin
  # Add logo
  data, status_code, headers = api_instance.add_logo_with_http_info(type, logo)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->add_logo_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **type** | **String** | The type of logo to add. |  |
| **logo** | **File** | The logo file to upload. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: multipart/form-data
- **Accept**: application/json


## delete_environement_feature_flag_override

> <SuccessResponse> delete_environement_feature_flag_override(feature_flag_key)

Delete Environment Feature Flag Override

Delete environment feature flag override.  <div>   <code>delete:environment_feature_flags</code> </div> 

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

Delete all environment feature flag overrides.  <div>   <code>delete:environment_feature_flags</code> </div> 

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


## delete_logo

> <SuccessResponse> delete_logo(type)

Delete logo

Delete environment logo  <div>   <code>update:environments</code> </div> 

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
type = 'dark' # String | The type of logo to delete.

begin
  # Delete logo
  result = api_instance.delete_logo(type)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->delete_logo: #{e}"
end
```

#### Using the delete_logo_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_logo_with_http_info(type)

```ruby
begin
  # Delete logo
  data, status_code, headers = api_instance.delete_logo_with_http_info(type)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->delete_logo_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **type** | **String** | The type of logo to delete. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_environement_feature_flags

> <GetEnvironmentFeatureFlagsResponse> get_environement_feature_flags

List Environment Feature Flags

Get environment feature flags.  <div>   <code>read:environment_feature_flags</code> </div> 

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


## get_environment

> <GetEnvironmentResponse> get_environment

Get environment

Gets the current environment.  <div>   <code>read:environments</code> </div> 

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
  # Get environment
  result = api_instance.get_environment
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->get_environment: #{e}"
end
```

#### Using the get_environment_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetEnvironmentResponse>, Integer, Hash)> get_environment_with_http_info

```ruby
begin
  # Get environment
  data, status_code, headers = api_instance.get_environment_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetEnvironmentResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->get_environment_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**GetEnvironmentResponse**](GetEnvironmentResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## read_logo

> <ReadEnvLogoResponse> read_logo

Read logo details

Read environment logo details  <div>   <code>read:environments</code> </div> 

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
  # Read logo details
  result = api_instance.read_logo
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->read_logo: #{e}"
end
```

#### Using the read_logo_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<ReadEnvLogoResponse>, Integer, Hash)> read_logo_with_http_info

```ruby
begin
  # Read logo details
  data, status_code, headers = api_instance.read_logo_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <ReadEnvLogoResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentsApi->read_logo_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**ReadEnvLogoResponse**](ReadEnvLogoResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## update_environement_feature_flag_override

> <SuccessResponse> update_environement_feature_flag_override(feature_flag_key, update_environement_feature_flag_override_request)

Update Environment Feature Flag Override

Update environment feature flag override.  <div>   <code>update:environment_feature_flags</code> </div> 

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

