# KindeApi::BillingAgreementsApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_billing_agreement**](BillingAgreementsApi.md#create_billing_agreement) | **POST** /api/v1/billing/agreements | Create billing agreement |
| [**get_billing_agreements**](BillingAgreementsApi.md#get_billing_agreements) | **GET** /api/v1/billing/agreements | Get billing agreements |


## create_billing_agreement

> <SuccessResponse> create_billing_agreement(create_billing_agreement_request)

Create billing agreement

Creates a new billing agreement based on the plan code passed, and cancels the customer's existing agreements  <div>   <code>create:billing_agreements</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::BillingAgreementsApi.new
create_billing_agreement_request = KindeApi::CreateBillingAgreementRequest.new({customer_id: 'customer_0195ac80a14c2ca2cec97d026d864de0', plan_code: 'pro'}) # CreateBillingAgreementRequest | New agreement request values

begin
  # Create billing agreement
  result = api_instance.create_billing_agreement(create_billing_agreement_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling BillingAgreementsApi->create_billing_agreement: #{e}"
end
```

#### Using the create_billing_agreement_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> create_billing_agreement_with_http_info(create_billing_agreement_request)

```ruby
begin
  # Create billing agreement
  data, status_code, headers = api_instance.create_billing_agreement_with_http_info(create_billing_agreement_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling BillingAgreementsApi->create_billing_agreement_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_billing_agreement_request** | [**CreateBillingAgreementRequest**](CreateBillingAgreementRequest.md) | New agreement request values |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## get_billing_agreements

> <GetBillingAgreementsResponse> get_billing_agreements(customer_id, opts)

Get billing agreements

Returns all the agreements a billing customer currently has access to  <div>   <code>read:billing_agreements</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::BillingAgreementsApi.new
customer_id = 'customer_0195ac80a14c2ca2cec97d026d864de0' # String | The ID of the billing customer to retrieve agreements for
opts = {
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  starting_after: 'starting_after_example', # String | The ID of the billing agreement to start after.
  ending_before: 'ending_before_example', # String | The ID of the billing agreement to end before.
  feature_code: 'feature_code_example' # String | The feature code to filter by agreements only containing that feature
}

begin
  # Get billing agreements
  result = api_instance.get_billing_agreements(customer_id, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling BillingAgreementsApi->get_billing_agreements: #{e}"
end
```

#### Using the get_billing_agreements_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetBillingAgreementsResponse>, Integer, Hash)> get_billing_agreements_with_http_info(customer_id, opts)

```ruby
begin
  # Get billing agreements
  data, status_code, headers = api_instance.get_billing_agreements_with_http_info(customer_id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetBillingAgreementsResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling BillingAgreementsApi->get_billing_agreements_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **customer_id** | **String** | The ID of the billing customer to retrieve agreements for |  |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **starting_after** | **String** | The ID of the billing agreement to start after. | [optional] |
| **ending_before** | **String** | The ID of the billing agreement to end before. | [optional] |
| **feature_code** | **String** | The feature code to filter by agreements only containing that feature | [optional] |

### Return type

[**GetBillingAgreementsResponse**](GetBillingAgreementsResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8, application/json

