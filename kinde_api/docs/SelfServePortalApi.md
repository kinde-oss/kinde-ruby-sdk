# KindeApi::SelfServePortalApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_portal_link**](SelfServePortalApi.md#get_portal_link) | **GET** /account_api/v1/get_portal_link | Get self-serve portal link |


## get_portal_link

> <GetPortalLink> get_portal_link(opts)

Get self-serve portal link

Returns a link to the self-serve portal for the authenticated user. The user can use this link to manage their account, update their profile, and view their entitlements. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::SelfServePortalApi.new
opts = {
  subnav: 'profile', # String | The area of the portal you want the user to land on
  return_url: 'return_url_example' # String | The URL to redirect the user to after they have completed their actions in the portal.
}

begin
  # Get self-serve portal link
  result = api_instance.get_portal_link(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling SelfServePortalApi->get_portal_link: #{e}"
end
```

#### Using the get_portal_link_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetPortalLink>, Integer, Hash)> get_portal_link_with_http_info(opts)

```ruby
begin
  # Get self-serve portal link
  data, status_code, headers = api_instance.get_portal_link_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetPortalLink>
rescue KindeApi::ApiError => e
  puts "Error when calling SelfServePortalApi->get_portal_link_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **subnav** | **String** | The area of the portal you want the user to land on | [optional] |
| **return_url** | **String** | The URL to redirect the user to after they have completed their actions in the portal. | [optional] |

### Return type

[**GetPortalLink**](GetPortalLink.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

