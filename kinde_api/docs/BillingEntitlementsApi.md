# KindeApi::BillingEntitlementsApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_billing_entitlements**](BillingEntitlementsApi.md#get_billing_entitlements) | **GET** /api/v1/billing/entitlements | Get billing entitlements |


## get_billing_entitlements

> <GetBillingEntitlementsResponse> get_billing_entitlements(customer_id, opts)

Get billing entitlements

Returns all the entitlements a billing customer currently has access to  <div>   <code>read:billing_entitlements</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::BillingEntitlementsApi.new
customer_id = 'customer_id_example' # String | The ID of the billing customer to retrieve entitlements for
opts = {
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  starting_after: 'starting_after_example', # String | The ID of the billing entitlement to start after.
  ending_before: 'ending_before_example', # String | The ID of the billing entitlement to end before.
  max_value: 'max_value_example', # String | When the maximum limit of an entitlement is null, this value is returned as the maximum limit
  expand: 'plans' # String | Specify additional plan data to retrieve. Use \"plans\".
}

begin
  # Get billing entitlements
  result = api_instance.get_billing_entitlements(customer_id, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling BillingEntitlementsApi->get_billing_entitlements: #{e}"
end
```

#### Using the get_billing_entitlements_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetBillingEntitlementsResponse>, Integer, Hash)> get_billing_entitlements_with_http_info(customer_id, opts)

```ruby
begin
  # Get billing entitlements
  data, status_code, headers = api_instance.get_billing_entitlements_with_http_info(customer_id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetBillingEntitlementsResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling BillingEntitlementsApi->get_billing_entitlements_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **customer_id** | **String** | The ID of the billing customer to retrieve entitlements for |  |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **starting_after** | **String** | The ID of the billing entitlement to start after. | [optional] |
| **ending_before** | **String** | The ID of the billing entitlement to end before. | [optional] |
| **max_value** | **String** | When the maximum limit of an entitlement is null, this value is returned as the maximum limit | [optional] |
| **expand** | **String** | Specify additional plan data to retrieve. Use \&quot;plans\&quot;. | [optional] |

### Return type

[**GetBillingEntitlementsResponse**](GetBillingEntitlementsResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8, application/json

