# KindeApi::BusinessApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_business**](BusinessApi.md#get_business) | **GET** /api/v1/business | Get business |
| [**update_business**](BusinessApi.md#update_business) | **PATCH** /api/v1/business | Update business |


## get_business

> <GetBusinessResponse> get_business

Get business

Get your business details.  <div>   <code>read:businesses</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::BusinessApi.new

begin
  # Get business
  result = api_instance.get_business
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling BusinessApi->get_business: #{e}"
end
```

#### Using the get_business_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetBusinessResponse>, Integer, Hash)> get_business_with_http_info

```ruby
begin
  # Get business
  data, status_code, headers = api_instance.get_business_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetBusinessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling BusinessApi->get_business_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**GetBusinessResponse**](GetBusinessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## update_business

> <SuccessResponse> update_business(update_business_request)

Update business

Update your business details.  <div>   <code>update:businesses</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::BusinessApi.new
update_business_request = KindeApi::UpdateBusinessRequest.new # UpdateBusinessRequest | The business details to update.

begin
  # Update business
  result = api_instance.update_business(update_business_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling BusinessApi->update_business: #{e}"
end
```

#### Using the update_business_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_business_with_http_info(update_business_request)

```ruby
begin
  # Update business
  data, status_code, headers = api_instance.update_business_with_http_info(update_business_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling BusinessApi->update_business_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **update_business_request** | [**UpdateBusinessRequest**](UpdateBusinessRequest.md) | The business details to update. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

