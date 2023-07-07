# KindeApi::RolesApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_role**](RolesApi.md#create_role) | **POST** /api/v1/role | Create a new role |
| [**get_roles**](RolesApi.md#get_roles) | **GET** /api/v1/roles | List Roles |
| [**update_roles**](RolesApi.md#update_roles) | **PATCH** /api/v1/roles/{role_id} | Update a role |


## create_role

> <SuccessResponse> create_role(opts)

Create a new role

Create role.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::RolesApi.new
opts = {
  create_role_request: KindeApi::CreateRoleRequest.new # CreateRoleRequest | Role details.
}

begin
  # Create a new role
  result = api_instance.create_role(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->create_role: #{e}"
end
```

#### Using the create_role_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> create_role_with_http_info(opts)

```ruby
begin
  # Create a new role
  data, status_code, headers = api_instance.create_role_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->create_role_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_role_request** | [**CreateRoleRequest**](CreateRoleRequest.md) | Role details. | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json; charset=utf-8


## get_roles

> <SuccessResponse> get_roles(opts)

List Roles

The returned list can be sorted by role name or role ID in ascending or descending order. The number of records to return at a time can also be controlled using the `page_size` query string parameter. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::RolesApi.new
opts = {
  sort: 'name_asc', # String | Field and order to sort the result by.
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  next_token: 'next_token_example' # String | A string to get the next page of results if there are more results.
}

begin
  # List Roles
  result = api_instance.get_roles(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->get_roles: #{e}"
end
```

#### Using the get_roles_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> get_roles_with_http_info(opts)

```ruby
begin
  # List Roles
  data, status_code, headers = api_instance.get_roles_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->get_roles_with_http_info: #{e}"
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


## update_roles

> <SuccessResponse> update_roles(role_id, opts)

Update a role

Update role

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::RolesApi.new
role_id = 56 # Integer | The identifier for the role.
opts = {
  create_role_request: KindeApi::CreateRoleRequest.new # CreateRoleRequest | Role details.
}

begin
  # Update a role
  result = api_instance.update_roles(role_id, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->update_roles: #{e}"
end
```

#### Using the update_roles_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_roles_with_http_info(role_id, opts)

```ruby
begin
  # Update a role
  data, status_code, headers = api_instance.update_roles_with_http_info(role_id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling RolesApi->update_roles_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **role_id** | **Integer** | The identifier for the role. |  |
| **create_role_request** | [**CreateRoleRequest**](CreateRoleRequest.md) | Role details. | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json; charset=utf-8

