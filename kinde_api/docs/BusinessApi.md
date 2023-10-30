# KindeApi::BusinessApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_business**](BusinessApi.md#get_business) | **GET** /api/v1/business | List business details |
| [**update_business**](BusinessApi.md#update_business) | **PATCH** /api/v1/business | Update business details |


## get_business

> <SuccessResponse> get_business(code, name, email, opts)

List business details

Get your business details.

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
code = 'code_example' # String | Business code.
name = 'name_example' # String | Business name.
email = 'email_example' # String | Email associated with business.
opts = {
  phone: 'phone_example', # String | Phone number associated with business.
  industry: 'industry_example', # String | The industry your business is in.
  timezone: 'timezone_example', # String | The timezone your business is in.
  privacy_url: 'privacy_url_example', # String | Your Privacy policy URL.
  terms_url: 'terms_url_example' # String | Your Terms and Conditions URL.
}

begin
  # List business details
  result = api_instance.get_business(code, name, email, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling BusinessApi->get_business: #{e}"
end
```

#### Using the get_business_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> get_business_with_http_info(code, name, email, opts)

```ruby
begin
  # List business details
  data, status_code, headers = api_instance.get_business_with_http_info(code, name, email, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling BusinessApi->get_business_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Business code. |  |
| **name** | **String** | Business name. |  |
| **email** | **String** | Email associated with business. |  |
| **phone** | **String** | Phone number associated with business. | [optional] |
| **industry** | **String** | The industry your business is in. | [optional] |
| **timezone** | **String** | The timezone your business is in. | [optional] |
| **privacy_url** | **String** | Your Privacy policy URL. | [optional] |
| **terms_url** | **String** | Your Terms and Conditions URL. | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8


## update_business

> <SuccessResponse> update_business(business_name, primary_email, opts)

Update business details

Update business details.

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
business_name = 'business_name_example' # String | Business name.
primary_email = 'primary_email_example' # String | Email associated with business.
opts = {
  primary_phone: 'primary_phone_example', # String | Phone number associated with business.
  industry_key: 'industry_key_example', # String | The key of the industry your business is in.
  timezone_id: 'timezone_id_example', # String | The ID of the timezone your business is in.
  privacy_url: 'privacy_url_example', # String | Your Privacy policy URL.
  terms_url: 'terms_url_example', # String | Your Terms and Conditions URL.
  is_show_kinde_branding: 'is_show_kinde_branding_example', # String | Display \"Powered by Kinde\" on your sign up, sign in, and subscription pages.
  is_click_wrap: true, # Boolean | Show a policy acceptance checkbox on sign up.
  partner_code: 'partner_code_example' # String | Your Kinde Perk code.
}

begin
  # Update business details
  result = api_instance.update_business(business_name, primary_email, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling BusinessApi->update_business: #{e}"
end
```

#### Using the update_business_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_business_with_http_info(business_name, primary_email, opts)

```ruby
begin
  # Update business details
  data, status_code, headers = api_instance.update_business_with_http_info(business_name, primary_email, opts)
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
| **business_name** | **String** | Business name. |  |
| **primary_email** | **String** | Email associated with business. |  |
| **primary_phone** | **String** | Phone number associated with business. | [optional] |
| **industry_key** | **String** | The key of the industry your business is in. | [optional] |
| **timezone_id** | **String** | The ID of the timezone your business is in. | [optional] |
| **privacy_url** | **String** | Your Privacy policy URL. | [optional] |
| **terms_url** | **String** | Your Terms and Conditions URL. | [optional] |
| **is_show_kinde_branding** | **String** | Display \&quot;Powered by Kinde\&quot; on your sign up, sign in, and subscription pages. | [optional] |
| **is_click_wrap** | **Boolean** | Show a policy acceptance checkbox on sign up. | [optional] |
| **partner_code** | **String** | Your Kinde Perk code. | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8

