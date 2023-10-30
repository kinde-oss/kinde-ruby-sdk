# KindeApi::TimezonesApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_timezones**](TimezonesApi.md#get_timezones) | **GET** /api/v1/timezones | List timezones and timezone IDs. |


## get_timezones

> <SuccessResponse> get_timezones(opts)

List timezones and timezone IDs.

Get a list of timezones and associated timezone keys.

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
opts = {
  timezone_key: 'timezone_key_example', # String | Timezone Key.
  name: 'name_example' # String | Timezone.
}

begin
  # List timezones and timezone IDs.
  result = api_instance.get_timezones(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling TimezonesApi->get_timezones: #{e}"
end
```

#### Using the get_timezones_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> get_timezones_with_http_info(opts)

```ruby
begin
  # List timezones and timezone IDs.
  data, status_code, headers = api_instance.get_timezones_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling TimezonesApi->get_timezones_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **timezone_key** | **String** | Timezone Key. | [optional] |
| **name** | **String** | Timezone. | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8

