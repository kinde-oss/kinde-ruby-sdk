# KindeApi::MFAApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**replace_mfa**](MFAApi.md#replace_mfa) | **PUT** /api/v1/mfa | Replace MFA Configuration |


## replace_mfa

> <SuccessResponse> replace_mfa(replace_mfa_request)

Replace MFA Configuration

Replace MFA Configuration.  <div>   <code>update:mfa</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::MFAApi.new
replace_mfa_request = KindeApi::ReplaceMFARequest.new({policy: 'required', enabled_factors: ['mfa:email']}) # ReplaceMFARequest | MFA details.

begin
  # Replace MFA Configuration
  result = api_instance.replace_mfa(replace_mfa_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling MFAApi->replace_mfa: #{e}"
end
```

#### Using the replace_mfa_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> replace_mfa_with_http_info(replace_mfa_request)

```ruby
begin
  # Replace MFA Configuration
  data, status_code, headers = api_instance.replace_mfa_with_http_info(replace_mfa_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling MFAApi->replace_mfa_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **replace_mfa_request** | [**ReplaceMFARequest**](ReplaceMFARequest.md) | MFA details. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

