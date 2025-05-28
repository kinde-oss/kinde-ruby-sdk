# KindeApi::EnvironmentVariablesApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_environment_variable**](EnvironmentVariablesApi.md#create_environment_variable) | **POST** /api/v1/environment_variables | Create environment variable |
| [**delete_environment_variable**](EnvironmentVariablesApi.md#delete_environment_variable) | **DELETE** /api/v1/environment_variables/{variable_id} | Delete environment variable |
| [**get_environment_variable**](EnvironmentVariablesApi.md#get_environment_variable) | **GET** /api/v1/environment_variables/{variable_id} | Get environment variable |
| [**get_environment_variables**](EnvironmentVariablesApi.md#get_environment_variables) | **GET** /api/v1/environment_variables | Get environment variables |
| [**update_environment_variable**](EnvironmentVariablesApi.md#update_environment_variable) | **PATCH** /api/v1/environment_variables/{variable_id} | Update environment variable |


## create_environment_variable

> <CreateEnvironmentVariableResponse> create_environment_variable(create_environment_variable_request)

Create environment variable

Create a new environment variable. This feature is in beta and admin UI is not yet available.  <div>   <code>create:environment_variables</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::EnvironmentVariablesApi.new
create_environment_variable_request = KindeApi::CreateEnvironmentVariableRequest.new({key: 'MY_API_KEY', value: 'some-secret-value'}) # CreateEnvironmentVariableRequest | The environment variable details.

begin
  # Create environment variable
  result = api_instance.create_environment_variable(create_environment_variable_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentVariablesApi->create_environment_variable: #{e}"
end
```

#### Using the create_environment_variable_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateEnvironmentVariableResponse>, Integer, Hash)> create_environment_variable_with_http_info(create_environment_variable_request)

```ruby
begin
  # Create environment variable
  data, status_code, headers = api_instance.create_environment_variable_with_http_info(create_environment_variable_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateEnvironmentVariableResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentVariablesApi->create_environment_variable_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_environment_variable_request** | [**CreateEnvironmentVariableRequest**](CreateEnvironmentVariableRequest.md) | The environment variable details. |  |

### Return type

[**CreateEnvironmentVariableResponse**](CreateEnvironmentVariableResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## delete_environment_variable

> <DeleteEnvironmentVariableResponse> delete_environment_variable(variable_id)

Delete environment variable

Delete an environment variable you previously created. This feature is in beta and admin UI is not yet available.  <div>   <code>delete:environment_variables</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::EnvironmentVariablesApi.new
variable_id = 'env_var_0192b1941f125645fa15bf28a662a0b3' # String | The environment variable's ID.

begin
  # Delete environment variable
  result = api_instance.delete_environment_variable(variable_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentVariablesApi->delete_environment_variable: #{e}"
end
```

#### Using the delete_environment_variable_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<DeleteEnvironmentVariableResponse>, Integer, Hash)> delete_environment_variable_with_http_info(variable_id)

```ruby
begin
  # Delete environment variable
  data, status_code, headers = api_instance.delete_environment_variable_with_http_info(variable_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <DeleteEnvironmentVariableResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentVariablesApi->delete_environment_variable_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **variable_id** | **String** | The environment variable&#39;s ID. |  |

### Return type

[**DeleteEnvironmentVariableResponse**](DeleteEnvironmentVariableResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_environment_variable

> <GetEnvironmentVariableResponse> get_environment_variable(variable_id)

Get environment variable

Retrieve environment variable details by ID. This feature is in beta and admin UI is not yet available.  <div>   <code>read:environment_variables</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::EnvironmentVariablesApi.new
variable_id = 'env_var_0192b1941f125645fa15bf28a662a0b3' # String | The environment variable's ID.

begin
  # Get environment variable
  result = api_instance.get_environment_variable(variable_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentVariablesApi->get_environment_variable: #{e}"
end
```

#### Using the get_environment_variable_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetEnvironmentVariableResponse>, Integer, Hash)> get_environment_variable_with_http_info(variable_id)

```ruby
begin
  # Get environment variable
  data, status_code, headers = api_instance.get_environment_variable_with_http_info(variable_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetEnvironmentVariableResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentVariablesApi->get_environment_variable_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **variable_id** | **String** | The environment variable&#39;s ID. |  |

### Return type

[**GetEnvironmentVariableResponse**](GetEnvironmentVariableResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_environment_variables

> <GetEnvironmentVariablesResponse> get_environment_variables

Get environment variables

Get environment variables. This feature is in beta and admin UI is not yet available.  <div>   <code>read:environment_variables</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::EnvironmentVariablesApi.new

begin
  # Get environment variables
  result = api_instance.get_environment_variables
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentVariablesApi->get_environment_variables: #{e}"
end
```

#### Using the get_environment_variables_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetEnvironmentVariablesResponse>, Integer, Hash)> get_environment_variables_with_http_info

```ruby
begin
  # Get environment variables
  data, status_code, headers = api_instance.get_environment_variables_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetEnvironmentVariablesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentVariablesApi->get_environment_variables_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**GetEnvironmentVariablesResponse**](GetEnvironmentVariablesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## update_environment_variable

> <UpdateEnvironmentVariableResponse> update_environment_variable(variable_id, update_environment_variable_request)

Update environment variable

Update an environment variable you previously created. This feature is in beta and admin UI is not yet available.  <div>   <code>update:environment_variables</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::EnvironmentVariablesApi.new
variable_id = 'env_var_0192b1941f125645fa15bf28a662a0b3' # String | The environment variable's ID.
update_environment_variable_request = KindeApi::UpdateEnvironmentVariableRequest.new # UpdateEnvironmentVariableRequest | The new details for the environment variable

begin
  # Update environment variable
  result = api_instance.update_environment_variable(variable_id, update_environment_variable_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentVariablesApi->update_environment_variable: #{e}"
end
```

#### Using the update_environment_variable_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<UpdateEnvironmentVariableResponse>, Integer, Hash)> update_environment_variable_with_http_info(variable_id, update_environment_variable_request)

```ruby
begin
  # Update environment variable
  data, status_code, headers = api_instance.update_environment_variable_with_http_info(variable_id, update_environment_variable_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <UpdateEnvironmentVariableResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling EnvironmentVariablesApi->update_environment_variable_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **variable_id** | **String** | The environment variable&#39;s ID. |  |
| **update_environment_variable_request** | [**UpdateEnvironmentVariableRequest**](UpdateEnvironmentVariableRequest.md) | The new details for the environment variable |  |

### Return type

[**UpdateEnvironmentVariableResponse**](UpdateEnvironmentVariableResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

