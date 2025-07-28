# KindeFrontendApi::FeatureFlagsApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_feature_flags**](FeatureFlagsApi.md#get_feature_flags) | **GET** /account_api/v1/feature_flags | Get feature flags |


## get_feature_flags

> <GetFeatureFlagsResponse> get_feature_flags(opts)

Get feature flags

Returns all the feature flags that affect the user 

### Examples

```ruby
require 'time'
require 'kinde_frontend_api'
# setup authorization
KindeFrontendApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeFrontendApi::FeatureFlagsApi.new
opts = {
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  starting_after: 'flag_1234567890abcdef' # String | The ID of the flag to start after.
}

begin
  # Get feature flags
  result = api_instance.get_feature_flags(opts)
  p result
rescue KindeFrontendApi::ApiError => e
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
rescue KindeFrontendApi::ApiError => e
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

