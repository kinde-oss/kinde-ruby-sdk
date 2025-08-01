# KindeFrontendApi::PropertiesApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_user_properties**](PropertiesApi.md#get_user_properties) | **GET** /account_api/v1/properties | Get properties |


## get_user_properties

> <GetUserPropertiesResponse> get_user_properties(opts)

Get properties

Returns all properties for the user 

### Examples

```ruby
require 'time'
require 'kinde_frontend_api'
# setup authorization
KindeFrontendApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeFrontendApi::PropertiesApi.new
opts = {
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  starting_after: 'prop_1234567890abcdef' # String | The ID of the property to start after.
}

begin
  # Get properties
  result = api_instance.get_user_properties(opts)
  p result
rescue KindeFrontendApi::ApiError => e
  puts "Error when calling PropertiesApi->get_user_properties: #{e}"
end
```

#### Using the get_user_properties_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetUserPropertiesResponse>, Integer, Hash)> get_user_properties_with_http_info(opts)

```ruby
begin
  # Get properties
  data, status_code, headers = api_instance.get_user_properties_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetUserPropertiesResponse>
rescue KindeFrontendApi::ApiError => e
  puts "Error when calling PropertiesApi->get_user_properties_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **starting_after** | **String** | The ID of the property to start after. | [optional] |

### Return type

[**GetUserPropertiesResponse**](GetUserPropertiesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

