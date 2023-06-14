# KindeApi::PermissionsApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_permission**](PermissionsApi.md#create_permission) | **POST** /api/v1/permissions | Create a new permission |
| [**get_permissions**](PermissionsApi.md#get_permissions) | **GET** /api/v1/permissions | List Permissions |
| [**update_permissions**](PermissionsApi.md#update_permissions) | **PATCH** /api/v1/permissions/{permission_id} | Update a permission |


## create_permission

> <SuccessResponse> create_permission(opts)

Create a new permission

Create permission.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::PermissionsApi.new
opts = {
  create_permission_request: KindeApi::CreatePermissionRequest.new # CreatePermissionRequest | Permission details.
}

begin
  # Create a new permission
  result = api_instance.create_permission(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling PermissionsApi->create_permission: #{e}"
end
```

#### Using the create_permission_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> create_permission_with_http_info(opts)

```ruby
begin
  # Create a new permission
  data, status_code, headers = api_instance.create_permission_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling PermissionsApi->create_permission_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_permission_request** | [**CreatePermissionRequest**](CreatePermissionRequest.md) | Permission details. | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json; charset=utf-8


## get_permissions

> <SuccessResponse> get_permissions(opts)

List Permissions

The returned list can be sorted by permission name or permission ID in ascending or descending order. The number of records to return at a time can also be controlled using the `page_size` query string parameter. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::PermissionsApi.new
opts = {
  sort: 'name_asc', # String | Field and order to sort the result by.
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  next_token: 'next_token_example' # String | A string to get the next page of results if there are more results.
}

begin
  # List Permissions
  result = api_instance.get_permissions(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling PermissionsApi->get_permissions: #{e}"
end
```

#### Using the get_permissions_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> get_permissions_with_http_info(opts)

```ruby
begin
  # List Permissions
  data, status_code, headers = api_instance.get_permissions_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling PermissionsApi->get_permissions_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **sort** | **String** | Field and order to sort the result by. | [optional] |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **next_token** | **String** | A string to get the next page of results if there are more results. | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8


## update_permissions

> <SuccessResponse> update_permissions(permission_id, opts)

Update a permission

Update permission

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::PermissionsApi.new
permission_id = 56 # Integer | The identifier for the permission.
opts = {
  create_permission_request: KindeApi::CreatePermissionRequest.new # CreatePermissionRequest | Permission details.
}

begin
  # Update a permission
  result = api_instance.update_permissions(permission_id, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling PermissionsApi->update_permissions: #{e}"
end
```

#### Using the update_permissions_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_permissions_with_http_info(permission_id, opts)

```ruby
begin
  # Update a permission
  data, status_code, headers = api_instance.update_permissions_with_http_info(permission_id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling PermissionsApi->update_permissions_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **permission_id** | **Integer** | The identifier for the permission. |  |
| **create_permission_request** | [**CreatePermissionRequest**](CreatePermissionRequest.md) | Permission details. | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json; charset=utf-8

