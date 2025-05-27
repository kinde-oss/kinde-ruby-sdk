# KindeApi::ApplicationsApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_application**](ApplicationsApi.md#create_application) | **POST** /api/v1/applications | Create application |
| [**delete_application**](ApplicationsApi.md#delete_application) | **DELETE** /api/v1/applications/{application_id} | Delete application |
| [**enable_connection**](ApplicationsApi.md#enable_connection) | **POST** /api/v1/applications/{application_id}/connections/{connection_id} | Enable connection |
| [**get_application**](ApplicationsApi.md#get_application) | **GET** /api/v1/applications/{application_id} | Get application |
| [**get_application_connections**](ApplicationsApi.md#get_application_connections) | **GET** /api/v1/applications/{application_id}/connections | Get connections |
| [**get_application_property_values**](ApplicationsApi.md#get_application_property_values) | **GET** /api/v1/applications/{application_id}/properties | Get property values |
| [**get_applications**](ApplicationsApi.md#get_applications) | **GET** /api/v1/applications | Get applications |
| [**remove_connection**](ApplicationsApi.md#remove_connection) | **DELETE** /api/v1/applications/{application_id}/connections/{connection_id} | Remove connection |
| [**update_application**](ApplicationsApi.md#update_application) | **PATCH** /api/v1/applications/{application_id} | Update Application |
| [**update_application_tokens**](ApplicationsApi.md#update_application_tokens) | **PATCH** /api/v1/applications/{application_id}/tokens | Update application tokens |
| [**update_applications_property**](ApplicationsApi.md#update_applications_property) | **PUT** /api/v1/applications/{application_id}/properties/{property_key} | Update property |


## create_application

> <CreateApplicationResponse> create_application(create_application_request)

Create application

Create a new client.  <div>   <code>create:applications</code> </div> 

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
create_application_request = KindeApi::CreateApplicationRequest.new({name: 'React Native app', type: 'reg'}) # CreateApplicationRequest | 

begin
  # Create application
  result = api_instance.create_application(create_application_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->create_application: #{e}"
end
```

#### Using the create_application_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateApplicationResponse>, Integer, Hash)> create_application_with_http_info(create_application_request)

```ruby
begin
  # Create application
  data, status_code, headers = api_instance.create_application_with_http_info(create_application_request)
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
| **create_application_request** | [**CreateApplicationRequest**](CreateApplicationRequest.md) |  |  |

### Return type

[**CreateApplicationResponse**](CreateApplicationResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## delete_application

> <SuccessResponse> delete_application(application_id)

Delete application

Delete a client / application.  <div>   <code>delete:applications</code> </div> 

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
application_id = '20bbffaa4c5e492a962273039d4ae18b' # String | The identifier for the application.

begin
  # Delete application
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
  # Delete application
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
- **Accept**: application/json


## enable_connection

> enable_connection(application_id, connection_id)

Enable connection

Enable an auth connection for an application.  <div>   <code>create:application_connections</code> </div> 

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
application_id = '20bbffaa4c5e492a962273039d4ae18b' # String | The identifier/client ID for the application.
connection_id = 'conn_0192c16abb53b44277e597d31877ba5b' # String | The identifier for the connection.

begin
  # Enable connection
  api_instance.enable_connection(application_id, connection_id)
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->enable_connection: #{e}"
end
```

#### Using the enable_connection_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> enable_connection_with_http_info(application_id, connection_id)

```ruby
begin
  # Enable connection
  data, status_code, headers = api_instance.enable_connection_with_http_info(application_id, connection_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->enable_connection_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **application_id** | **String** | The identifier/client ID for the application. |  |
| **connection_id** | **String** | The identifier for the connection. |  |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_application

> <GetApplicationResponse> get_application(application_id)

Get application

Gets an application given the application's ID.  <div>   <code>read:applications</code> </div> 

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
application_id = '20bbffaa4c5e492a962273039d4ae18b' # String | The identifier for the application.

begin
  # Get application
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
  # Get application
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
- **Accept**: application/json


## get_application_connections

> <GetConnectionsResponse> get_application_connections(application_id)

Get connections

Gets all connections for an application.  <div>   <code>read:application_connections</code> </div> 

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
application_id = '20bbffaa4c5e492a962273039d4ae18b' # String | The identifier/client ID for the application.

begin
  # Get connections
  result = api_instance.get_application_connections(application_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->get_application_connections: #{e}"
end
```

#### Using the get_application_connections_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetConnectionsResponse>, Integer, Hash)> get_application_connections_with_http_info(application_id)

```ruby
begin
  # Get connections
  data, status_code, headers = api_instance.get_application_connections_with_http_info(application_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetConnectionsResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->get_application_connections_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **application_id** | **String** | The identifier/client ID for the application. |  |

### Return type

[**GetConnectionsResponse**](GetConnectionsResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_application_property_values

> <GetPropertyValuesResponse> get_application_property_values(application_id)

Get property values

Gets properties for an application by client ID.  <div>   <code>read:application_properties</code> </div> 

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
application_id = '3b0b5c6c8fcc464fab397f4969b5f482' # String | The application's ID / client ID.

begin
  # Get property values
  result = api_instance.get_application_property_values(application_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->get_application_property_values: #{e}"
end
```

#### Using the get_application_property_values_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetPropertyValuesResponse>, Integer, Hash)> get_application_property_values_with_http_info(application_id)

```ruby
begin
  # Get property values
  data, status_code, headers = api_instance.get_application_property_values_with_http_info(application_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetPropertyValuesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->get_application_property_values_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **application_id** | **String** | The application&#39;s ID / client ID. |  |

### Return type

[**GetPropertyValuesResponse**](GetPropertyValuesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_applications

> <GetApplicationsResponse> get_applications(opts)

Get applications

Get a list of applications / clients.  <div>   <code>read:applications</code> </div> 

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
  # Get applications
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
  # Get applications
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
- **Accept**: application/json


## remove_connection

> <SuccessResponse> remove_connection(application_id, connection_id)

Remove connection

Turn off an auth connection for an application  <div>   <code>delete:application_connections</code> </div> 

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
application_id = '20bbffaa4c5e492a962273039d4ae18b' # String | The identifier/client ID for the application.
connection_id = 'conn_0192c16abb53b44277e597d31877ba5b' # String | The identifier for the connection.

begin
  # Remove connection
  result = api_instance.remove_connection(application_id, connection_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->remove_connection: #{e}"
end
```

#### Using the remove_connection_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> remove_connection_with_http_info(application_id, connection_id)

```ruby
begin
  # Remove connection
  data, status_code, headers = api_instance.remove_connection_with_http_info(application_id, connection_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->remove_connection_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **application_id** | **String** | The identifier/client ID for the application. |  |
| **connection_id** | **String** | The identifier for the connection. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## update_application

> update_application(application_id, opts)

Update Application

Updates a client's settings. For more information, read [Applications in Kinde](https://docs.kinde.com/build/applications/about-applications)  <div>   <code>update:applications</code> </div> 

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
application_id = '20bbffaa4c5e492a962273039d4ae18b' # String | The identifier for the application.
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
- **Accept**: application/json


## update_application_tokens

> <SuccessResponse> update_application_tokens(application_id, update_application_tokens_request)

Update application tokens

Configure tokens for an application.   <div>     <code>update:application_tokens</code>   </div> 

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
application_id = '20bbffaa4c5e492a962273039d4ae18b' # String | The identifier/client ID for the application.
update_application_tokens_request = KindeApi::UpdateApplicationTokensRequest.new # UpdateApplicationTokensRequest | Application tokens.

begin
  # Update application tokens
  result = api_instance.update_application_tokens(application_id, update_application_tokens_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->update_application_tokens: #{e}"
end
```

#### Using the update_application_tokens_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_application_tokens_with_http_info(application_id, update_application_tokens_request)

```ruby
begin
  # Update application tokens
  data, status_code, headers = api_instance.update_application_tokens_with_http_info(application_id, update_application_tokens_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->update_application_tokens_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **application_id** | **String** | The identifier/client ID for the application. |  |
| **update_application_tokens_request** | [**UpdateApplicationTokensRequest**](UpdateApplicationTokensRequest.md) | Application tokens. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## update_applications_property

> <SuccessResponse> update_applications_property(application_id, property_key, update_applications_property_request)

Update property

Update application property value.  <div>   <code>update:application_properties</code> </div> 

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
application_id = '3b0b5c6c8fcc464fab397f4969b5f482' # String | The application's ID / client ID.
property_key = 'kp_some_key' # String | The property's key.
update_applications_property_request = KindeApi::UpdateApplicationsPropertyRequest.new({value: nil}) # UpdateApplicationsPropertyRequest | 

begin
  # Update property
  result = api_instance.update_applications_property(application_id, property_key, update_applications_property_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->update_applications_property: #{e}"
end
```

#### Using the update_applications_property_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_applications_property_with_http_info(application_id, property_key, update_applications_property_request)

```ruby
begin
  # Update property
  data, status_code, headers = api_instance.update_applications_property_with_http_info(application_id, property_key, update_applications_property_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling ApplicationsApi->update_applications_property_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **application_id** | **String** | The application&#39;s ID / client ID. |  |
| **property_key** | **String** | The property&#39;s key. |  |
| **update_applications_property_request** | [**UpdateApplicationsPropertyRequest**](UpdateApplicationsPropertyRequest.md) |  |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

