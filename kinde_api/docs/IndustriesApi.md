# KindeApi::IndustriesApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_industries**](IndustriesApi.md#get_industries) | **GET** /api/v1/industries | List industries and industry keys. |


## get_industries

> <SuccessResponse> get_industries(opts)

List industries and industry keys.

Get a list of industries and associated industry keys.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::IndustriesApi.new
opts = {
  industry_key: 'industry_key_example', # String | Industry Key.
  name: 'name_example' # String | Industry name.
}

begin
  # List industries and industry keys.
  result = api_instance.get_industries(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling IndustriesApi->get_industries: #{e}"
end
```

#### Using the get_industries_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> get_industries_with_http_info(opts)

```ruby
begin
  # List industries and industry keys.
  data, status_code, headers = api_instance.get_industries_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling IndustriesApi->get_industries_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **industry_key** | **String** | Industry Key. | [optional] |
| **name** | **String** | Industry name. | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8

