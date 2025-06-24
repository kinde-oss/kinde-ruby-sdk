# KindeApi::BillingApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_entitlements**](BillingApi.md#get_entitlements) | **GET** /account_api/v1/entitlements | Get entitlements |


## get_entitlements

> <GetEntitlementsResponse> get_entitlements(opts)

Get entitlements

Returns all the entitlements a the user currently has access to 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::BillingApi.new
opts = {
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  starting_after: 'entitlement_1234567890abcdef' # String | The ID of the entitlement to start after.
}

begin
  # Get entitlements
  result = api_instance.get_entitlements(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling BillingApi->get_entitlements: #{e}"
end
```

#### Using the get_entitlements_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetEntitlementsResponse>, Integer, Hash)> get_entitlements_with_http_info(opts)

```ruby
begin
  # Get entitlements
  data, status_code, headers = api_instance.get_entitlements_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetEntitlementsResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling BillingApi->get_entitlements_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **starting_after** | **String** | The ID of the entitlement to start after. | [optional] |

### Return type

[**GetEntitlementsResponse**](GetEntitlementsResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

