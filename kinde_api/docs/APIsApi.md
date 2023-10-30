# KindeApi::APIsApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**add_apis**](APIsApi.md#add_apis) | **POST** /api/v1/apis | Add APIs |
| [**delete_api**](APIsApi.md#delete_api) | **DELETE** /api/v1/apis/{api_id} | Delete API |
| [**get_api**](APIsApi.md#get_api) | **GET** /api/v1/apis/{api_id} | List API details |
| [**get_apis**](APIsApi.md#get_apis) | **GET** /api/v1/apis | List APIs |
| [**update_api_applications**](APIsApi.md#update_api_applications) | **PATCH** /api/v1/apis/{api_id}/applications | Update API Applications |


## add_apis

> <SuccessResponse> add_apis(add_apis_request)

Add APIs

Add APIs. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::APIsApi.new
add_apis_request = KindeApi::AddAPIsRequest.new({name: 'name_example', audience: 'audience_example'}) # AddAPIsRequest | API details.

begin
  # Add APIs
  result = api_instance.add_apis(add_apis_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->add_apis: #{e}"
end
```

#### Using the add_apis_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> add_apis_with_http_info(add_apis_request)

```ruby
begin
  # Add APIs
  data, status_code, headers = api_instance.add_apis_with_http_info(add_apis_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->add_apis_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **add_apis_request** | [**AddAPIsRequest**](AddAPIsRequest.md) | API details. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json; charset=utf-8, application/json


## delete_api

> <SuccessResponse> delete_api(api_id)

Delete API

Deletes API. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::APIsApi.new
api_id = 'api_id_example' # String | The API's id.

begin
  # Delete API
  result = api_instance.delete_api(api_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->delete_api: #{e}"
end
```

#### Using the delete_api_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_api_with_http_info(api_id)

```ruby
begin
  # Delete API
  data, status_code, headers = api_instance.delete_api_with_http_info(api_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->delete_api_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **api_id** | **String** | The API&#39;s id. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8, application/json


## get_api

> <Api> get_api(api_id)

List API details

Returns the details of the API. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::APIsApi.new
api_id = 'api_id_example' # String | The API's id.

begin
  # List API details
  result = api_instance.get_api(api_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->get_api: #{e}"
end
```

#### Using the get_api_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Api>, Integer, Hash)> get_api_with_http_info(api_id)

```ruby
begin
  # List API details
  data, status_code, headers = api_instance.get_api_with_http_info(api_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Api>
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->get_api_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **api_id** | **String** | The API&#39;s id. |  |

### Return type

[**Api**](Api.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8, application/json


## get_apis

> <Apis> get_apis

List APIs

Returns a list of APIs. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::APIsApi.new

begin
  # List APIs
  result = api_instance.get_apis
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->get_apis: #{e}"
end
```

#### Using the get_apis_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Apis>, Integer, Hash)> get_apis_with_http_info

```ruby
begin
  # List APIs
  data, status_code, headers = api_instance.get_apis_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Apis>
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->get_apis_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**Apis**](Apis.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8, application/json


## update_api_applications

> <SuccessResponse> update_api_applications(api_id, update_api_applications_request)

Update API Applications

Update the applications under that API. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::APIsApi.new
api_id = 'api_id_example' # String | The identifier for the API.
update_api_applications_request = KindeApi::UpdateAPIApplicationsRequest.new({applications: [KindeApi::UpdateAPIApplicationsRequestApplicationsInner.new({id: 'id_example'})]}) # UpdateAPIApplicationsRequest | The applications you want to connect or disconnect.

begin
  # Update API Applications
  result = api_instance.update_api_applications(api_id, update_api_applications_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->update_api_applications: #{e}"
end
```

#### Using the update_api_applications_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_api_applications_with_http_info(api_id, update_api_applications_request)

```ruby
begin
  # Update API Applications
  data, status_code, headers = api_instance.update_api_applications_with_http_info(api_id, update_api_applications_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->update_api_applications_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **api_id** | **String** | The identifier for the API. |  |
| **update_api_applications_request** | [**UpdateAPIApplicationsRequest**](UpdateAPIApplicationsRequest.md) | The applications you want to connect or disconnect. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json; charset=utf-8, application/json

