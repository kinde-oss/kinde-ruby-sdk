# KindeApi::ApplicationsApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_application**](ApplicationsApi.md#create_application) | **POST** /api/v1/applications | Create Application |
| [**delete_application**](ApplicationsApi.md#delete_application) | **DELETE** /api/v1/applications/{application_id} | Delete Application |
| [**get_application**](ApplicationsApi.md#get_application) | **GET** /api/v1/applications/{application_id} | Get Application |
| [**get_applications**](ApplicationsApi.md#get_applications) | **GET** /api/v1/applications | List Applications |
| [**update_application**](ApplicationsApi.md#update_application) | **PATCH** /api/v1/applications/{application_id} | Update Application |


## create_application

> <CreateApplicationResponse> create_application(opts)

Create Application

Create an application.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::ApplicationsApi.new
opts = {
  create_application_request: KindeApi::CreateApplicationRequest.new # CreateApplicationRequest | Application details.
}

begin
  # Create Application
  result = api_instance.create_application(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->create_application: #{e}"
end
```

#### Using the create_application_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateApplicationResponse>, Integer, Hash)> create_application_with_http_info(opts)

```ruby
begin
  # Create Application
  data, status_code, headers = api_instance.create_application_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateApplicationResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->create_application_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_application_request** | [**CreateApplicationRequest**](CreateApplicationRequest.md) | Application details. | [optional] |

### Return type

[**CreateApplicationResponse**](CreateApplicationResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## delete_application

> <SuccessResponse> delete_application(application_id)

Delete Application

Delete application. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::ApplicationsApi.new
application_id = 'application_id_example' # String | The identifier for the application.

begin
  # Delete Application
  result = api_instance.delete_application(application_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->delete_application: #{e}"
end
```

#### Using the delete_application_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_application_with_http_info(application_id)

```ruby
begin
  # Delete Application
  data, status_code, headers = api_instance.delete_application_with_http_info(application_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->delete_application_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **application_id** | **String** | The identifier for the application. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_application

> <GetApplicationResponse> get_application(application_id)

Get Application

Gets an application given the application's id. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::ApplicationsApi.new
application_id = 'application_id_example' # String | The identifier for the application.

begin
  # Get Application
  result = api_instance.get_application(application_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->get_application: #{e}"
end
```

#### Using the get_application_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetApplicationResponse>, Integer, Hash)> get_application_with_http_info(application_id)

```ruby
begin
  # Get Application
  data, status_code, headers = api_instance.get_application_with_http_info(application_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetApplicationResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->get_application_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **application_id** | **String** | The identifier for the application. |  |

### Return type

[**GetApplicationResponse**](GetApplicationResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_applications

> <GetApplicationsResponse> get_applications(opts)

List Applications

Get a list of applications. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::ApplicationsApi.new
opts = {
  sort: 'name_asc', # String | Field and order to sort the result by.
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  next_token: 'next_token_example' # String | A string to get the next page of results if there are more results.
}

begin
  # List Applications
  result = api_instance.get_applications(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->get_applications: #{e}"
end
```

#### Using the get_applications_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetApplicationsResponse>, Integer, Hash)> get_applications_with_http_info(opts)

```ruby
begin
  # List Applications
  data, status_code, headers = api_instance.get_applications_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetApplicationsResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->get_applications_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **sort** | **String** | Field and order to sort the result by. | [optional] |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **next_token** | **String** | A string to get the next page of results if there are more results. | [optional] |

### Return type

[**GetApplicationsResponse**](GetApplicationsResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## update_application

> update_application(application_id, opts)

Update Application

Update an application.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::ApplicationsApi.new
application_id = 'application_id_example' # String | The identifier for the application.
opts = {
  update_application_request: KindeApi::UpdateApplicationRequest.new # UpdateApplicationRequest | Application details.
}

begin
  # Update Application
  api_instance.update_application(application_id, opts)
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->update_application: #{e}"
end
```

#### Using the update_application_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> update_application_with_http_info(application_id, opts)

```ruby
begin
  # Update Application
  data, status_code, headers = api_instance.update_application_with_http_info(application_id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->update_application_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **application_id** | **String** | The identifier for the application. |  |
| **update_application_request** | [**UpdateApplicationRequest**](UpdateApplicationRequest.md) | Application details. | [optional] |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8

