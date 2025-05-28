# KindeApi::BillingMeterUsageApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_meter_usage_record**](BillingMeterUsageApi.md#create_meter_usage_record) | **POST** /api/v1/billing/meter_usage | Create meter usage record |


## create_meter_usage_record

> <CreateMeterUsageRecordResponse> create_meter_usage_record(create_meter_usage_record_request)

Create meter usage record

Create a new meter usage record  <div>   <code>create:meter_usage</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::BillingMeterUsageApi.new
create_meter_usage_record_request = KindeApi::CreateMeterUsageRecordRequest.new({customer_agreement_id: 'agreement_0195ac80a14c2ca2cec97d026d864de0', billing_feature_code: 'pro_gym', meter_value: 'pro_gym'}) # CreateMeterUsageRecordRequest | Meter usage record

begin
  # Create meter usage record
  result = api_instance.create_meter_usage_record(create_meter_usage_record_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling BillingMeterUsageApi->create_meter_usage_record: #{e}"
end
```

#### Using the create_meter_usage_record_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateMeterUsageRecordResponse>, Integer, Hash)> create_meter_usage_record_with_http_info(create_meter_usage_record_request)

```ruby
begin
  # Create meter usage record
  data, status_code, headers = api_instance.create_meter_usage_record_with_http_info(create_meter_usage_record_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateMeterUsageRecordResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling BillingMeterUsageApi->create_meter_usage_record_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_meter_usage_record_request** | [**CreateMeterUsageRecordRequest**](CreateMeterUsageRecordRequest.md) | Meter usage record |  |

### Return type

[**CreateMeterUsageRecordResponse**](CreateMeterUsageRecordResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

