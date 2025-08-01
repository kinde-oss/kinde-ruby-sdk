# KindeFrontendApi::BillingApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_entitlement**](BillingApi.md#get_entitlement) | **GET** /account_api/v1/entitlement | Get entitlement |
| [**get_entitlements**](BillingApi.md#get_entitlements) | **GET** /account_api/v1/entitlements | Get entitlements |


## get_entitlement

> <GetEntitlementResponse> get_entitlement(key)

Get entitlement

Returns a single entitlement by the feature key 

### Examples

```ruby
require 'time'
require 'kinde_frontend_api'
# setup authorization
KindeFrontendApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeFrontendApi::BillingApi.new
key = 'key_example' # String | The key of the feature

begin
  # Get entitlement
  result = api_instance.get_entitlement(key)
  p result
rescue KindeFrontendApi::ApiError => e
  puts "Error when calling BillingApi->get_entitlement: #{e}"
end
```

#### Using the get_entitlement_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetEntitlementResponse>, Integer, Hash)> get_entitlement_with_http_info(key)

```ruby
begin
  # Get entitlement
  data, status_code, headers = api_instance.get_entitlement_with_http_info(key)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetEntitlementResponse>
rescue KindeFrontendApi::ApiError => e
  puts "Error when calling BillingApi->get_entitlement_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **key** | **String** | The key of the feature |  |

### Return type

[**GetEntitlementResponse**](GetEntitlementResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_entitlements

> <GetEntitlementsResponse> get_entitlements(opts)

Get entitlements

Returns all the entitlements a the user currently has access to 

### Examples

```ruby
require 'time'
require 'kinde_frontend_api'
# setup authorization
KindeFrontendApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeFrontendApi::BillingApi.new
opts = {
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  starting_after: 'entitlement_1234567890abcdef' # String | The ID of the entitlement to start after.
}

begin
  # Get entitlements
  result = api_instance.get_entitlements(opts)
  p result
rescue KindeFrontendApi::ApiError => e
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
rescue KindeFrontendApi::ApiError => e
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

