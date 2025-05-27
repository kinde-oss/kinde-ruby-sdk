# KindeApi::IdentitiesApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**delete_identity**](IdentitiesApi.md#delete_identity) | **DELETE** /api/v1/identities/{identity_id} | Delete identity |
| [**get_identity**](IdentitiesApi.md#get_identity) | **GET** /api/v1/identities/{identity_id} | Get identity |
| [**update_identity**](IdentitiesApi.md#update_identity) | **PATCH** /api/v1/identities/{identity_id} | Update identity |


## delete_identity

> <SuccessResponse> delete_identity(identity_id)

Delete identity

Delete identity by ID.  <div>   <code>delete:identities</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::IdentitiesApi.new
identity_id = 'identity_id_example' # String | The unique identifier for the identity.

begin
  # Delete identity
  result = api_instance.delete_identity(identity_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling IdentitiesApi->delete_identity: #{e}"
end
```

#### Using the delete_identity_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_identity_with_http_info(identity_id)

```ruby
begin
  # Delete identity
  data, status_code, headers = api_instance.delete_identity_with_http_info(identity_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling IdentitiesApi->delete_identity_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **identity_id** | **String** | The unique identifier for the identity. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_identity

> <Identity> get_identity(identity_id)

Get identity

Returns an identity by ID  <div>   <code>read:identities</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::IdentitiesApi.new
identity_id = 'identity_id_example' # String | The unique identifier for the identity.

begin
  # Get identity
  result = api_instance.get_identity(identity_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling IdentitiesApi->get_identity: #{e}"
end
```

#### Using the get_identity_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Identity>, Integer, Hash)> get_identity_with_http_info(identity_id)

```ruby
begin
  # Get identity
  data, status_code, headers = api_instance.get_identity_with_http_info(identity_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Identity>
rescue KindeApi::ApiError => e
  puts "Error when calling IdentitiesApi->get_identity_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **identity_id** | **String** | The unique identifier for the identity. |  |

### Return type

[**Identity**](Identity.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8, application/json


## update_identity

> <SuccessResponse> update_identity(identity_id, update_identity_request)

Update identity

Update identity by ID.  <div>   <code>update:identities</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::IdentitiesApi.new
identity_id = 'identity_id_example' # String | The unique identifier for the identity.
update_identity_request = KindeApi::UpdateIdentityRequest.new # UpdateIdentityRequest | The fields of the identity to update.

begin
  # Update identity
  result = api_instance.update_identity(identity_id, update_identity_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling IdentitiesApi->update_identity: #{e}"
end
```

#### Using the update_identity_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_identity_with_http_info(identity_id, update_identity_request)

```ruby
begin
  # Update identity
  data, status_code, headers = api_instance.update_identity_with_http_info(identity_id, update_identity_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling IdentitiesApi->update_identity_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **identity_id** | **String** | The unique identifier for the identity. |  |
| **update_identity_request** | [**UpdateIdentityRequest**](UpdateIdentityRequest.md) | The fields of the identity to update. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8

