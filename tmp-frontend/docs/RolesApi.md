# KindeFrontendApi::RolesApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_user_roles**](RolesApi.md#get_user_roles) | **GET** /account_api/v1/roles | Get roles |


## get_user_roles

> <GetUserRolesResponse> get_user_roles(opts)

Get roles

Returns all roles for the user 

### Examples

```ruby
require 'time'
require 'kinde_frontend_api'
# setup authorization
KindeFrontendApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeFrontendApi::RolesApi.new
opts = {
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  starting_after: 'role_1234567890abcdef' # String | The ID of the role to start after.
}

begin
  # Get roles
  result = api_instance.get_user_roles(opts)
  p result
rescue KindeFrontendApi::ApiError => e
  puts "Error when calling RolesApi->get_user_roles: #{e}"
end
```

#### Using the get_user_roles_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetUserRolesResponse>, Integer, Hash)> get_user_roles_with_http_info(opts)

```ruby
begin
  # Get roles
  data, status_code, headers = api_instance.get_user_roles_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetUserRolesResponse>
rescue KindeFrontendApi::ApiError => e
  puts "Error when calling RolesApi->get_user_roles_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **starting_after** | **String** | The ID of the role to start after. | [optional] |

### Return type

[**GetUserRolesResponse**](GetUserRolesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

