# KindeApi::TimezonesApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_timezones**](TimezonesApi.md#get_timezones) | **GET** /api/v1/timezones | Get timezones |


## get_timezones

> <GetTimezonesResponse> get_timezones

Get timezones

Get a list of timezones and associated timezone keys.  <div>   <code>read:timezones</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::TimezonesApi.new

begin
  # Get timezones
  result = api_instance.get_timezones
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling TimezonesApi->get_timezones: #{e}"
end
```

#### Using the get_timezones_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetTimezonesResponse>, Integer, Hash)> get_timezones_with_http_info

```ruby
begin
  # Get timezones
  data, status_code, headers = api_instance.get_timezones_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetTimezonesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling TimezonesApi->get_timezones_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**GetTimezonesResponse**](GetTimezonesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

