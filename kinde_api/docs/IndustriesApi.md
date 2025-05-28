# KindeApi::IndustriesApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_industries**](IndustriesApi.md#get_industries) | **GET** /api/v1/industries | Get industries |


## get_industries

> <GetIndustriesResponse> get_industries

Get industries

Get a list of industries and associated industry keys.  <div>   <code>read:industries</code> </div> 

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

begin
  # Get industries
  result = api_instance.get_industries
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling IndustriesApi->get_industries: #{e}"
end
```

#### Using the get_industries_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetIndustriesResponse>, Integer, Hash)> get_industries_with_http_info

```ruby
begin
  # Get industries
  data, status_code, headers = api_instance.get_industries_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetIndustriesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling IndustriesApi->get_industries_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**GetIndustriesResponse**](GetIndustriesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

