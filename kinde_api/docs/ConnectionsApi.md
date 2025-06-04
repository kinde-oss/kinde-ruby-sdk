# KindeApi::ConnectionsApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_connection**](ConnectionsApi.md#create_connection) | **POST** /api/v1/connections | Create Connection |
| [**delete_connection**](ConnectionsApi.md#delete_connection) | **DELETE** /api/v1/connections/{connection_id} | Delete Connection |
| [**get_connection**](ConnectionsApi.md#get_connection) | **GET** /api/v1/connections/{connection_id} | Get Connection |
| [**get_connections**](ConnectionsApi.md#get_connections) | **GET** /api/v1/connections | Get connections |
| [**replace_connection**](ConnectionsApi.md#replace_connection) | **PUT** /api/v1/connections/{connection_id} | Replace Connection |
| [**update_connection**](ConnectionsApi.md#update_connection) | **PATCH** /api/v1/connections/{connection_id} | Update Connection |


## create_connection

> <CreateConnectionResponse> create_connection(create_connection_request)

Create Connection

Create Connection.  <div>   <code>create:connections</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::ConnectionsApi.new
create_connection_request = KindeApi::CreateConnectionRequest.new # CreateConnectionRequest | Connection details.

begin
  # Create Connection
  result = api_instance.create_connection(create_connection_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectionsApi->create_connection: #{e}"
end
```

#### Using the create_connection_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateConnectionResponse>, Integer, Hash)> create_connection_with_http_info(create_connection_request)

```ruby
begin
  # Create Connection
  data, status_code, headers = api_instance.create_connection_with_http_info(create_connection_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateConnectionResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectionsApi->create_connection_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_connection_request** | [**CreateConnectionRequest**](CreateConnectionRequest.md) | Connection details. |  |

### Return type

[**CreateConnectionResponse**](CreateConnectionResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## delete_connection

> <SuccessResponse> delete_connection(connection_id)

Delete Connection

Delete connection.  <div>   <code>delete:connections</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::ConnectionsApi.new
connection_id = 'connection_id_example' # String | The identifier for the connection.

begin
  # Delete Connection
  result = api_instance.delete_connection(connection_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectionsApi->delete_connection: #{e}"
end
```

#### Using the delete_connection_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_connection_with_http_info(connection_id)

```ruby
begin
  # Delete Connection
  data, status_code, headers = api_instance.delete_connection_with_http_info(connection_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectionsApi->delete_connection_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **connection_id** | **String** | The identifier for the connection. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_connection

> <Connection> get_connection(connection_id)

Get Connection

Get Connection.  <div>   <code>read:connections</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::ConnectionsApi.new
connection_id = 'connection_id_example' # String | The unique identifier for the connection.

begin
  # Get Connection
  result = api_instance.get_connection(connection_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectionsApi->get_connection: #{e}"
end
```

#### Using the get_connection_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<Connection>, Integer, Hash)> get_connection_with_http_info(connection_id)

```ruby
begin
  # Get Connection
  data, status_code, headers = api_instance.get_connection_with_http_info(connection_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <Connection>
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectionsApi->get_connection_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **connection_id** | **String** | The unique identifier for the connection. |  |

### Return type

[**Connection**](Connection.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_connections

> <GetConnectionsResponse> get_connections(opts)

Get connections

Returns a list of authentication connections. Optionally you can filter this by a home realm domain.  <div>   <code>read:connections</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::ConnectionsApi.new
opts = {
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  home_realm_domain: 'myapp.com', # String | Filter the results by the home realm domain.
  starting_after: 'starting_after_example', # String | The ID of the connection to start after.
  ending_before: 'ending_before_example' # String | The ID of the connection to end before.
}

begin
  # Get connections
  result = api_instance.get_connections(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectionsApi->get_connections: #{e}"
end
```

#### Using the get_connections_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetConnectionsResponse>, Integer, Hash)> get_connections_with_http_info(opts)

```ruby
begin
  # Get connections
  data, status_code, headers = api_instance.get_connections_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetConnectionsResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectionsApi->get_connections_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **home_realm_domain** | **String** | Filter the results by the home realm domain. | [optional] |
| **starting_after** | **String** | The ID of the connection to start after. | [optional] |
| **ending_before** | **String** | The ID of the connection to end before. | [optional] |

### Return type

[**GetConnectionsResponse**](GetConnectionsResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8, application/json


## replace_connection

> <SuccessResponse> replace_connection(connection_id, replace_connection_request)

Replace Connection

Replace Connection Config.  <div>   <code>update:connections</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::ConnectionsApi.new
connection_id = 'connection_id_example' # String | The unique identifier for the connection.
replace_connection_request = KindeApi::ReplaceConnectionRequest.new # ReplaceConnectionRequest | The complete connection configuration to replace the existing one.

begin
  # Replace Connection
  result = api_instance.replace_connection(connection_id, replace_connection_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectionsApi->replace_connection: #{e}"
end
```

#### Using the replace_connection_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> replace_connection_with_http_info(connection_id, replace_connection_request)

```ruby
begin
  # Replace Connection
  data, status_code, headers = api_instance.replace_connection_with_http_info(connection_id, replace_connection_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectionsApi->replace_connection_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **connection_id** | **String** | The unique identifier for the connection. |  |
| **replace_connection_request** | [**ReplaceConnectionRequest**](ReplaceConnectionRequest.md) | The complete connection configuration to replace the existing one. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## update_connection

> <SuccessResponse> update_connection(connection_id, update_connection_request)

Update Connection

Update Connection.  <div>   <code>update:connections</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::ConnectionsApi.new
connection_id = 'connection_id_example' # String | The unique identifier for the connection.
update_connection_request = KindeApi::UpdateConnectionRequest.new # UpdateConnectionRequest | The fields of the connection to update.

begin
  # Update Connection
  result = api_instance.update_connection(connection_id, update_connection_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectionsApi->update_connection: #{e}"
end
```

#### Using the update_connection_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_connection_with_http_info(connection_id, update_connection_request)

```ruby
begin
  # Update Connection
  data, status_code, headers = api_instance.update_connection_with_http_info(connection_id, update_connection_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling ConnectionsApi->update_connection_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **connection_id** | **String** | The unique identifier for the connection. |  |
| **update_connection_request** | [**UpdateConnectionRequest**](UpdateConnectionRequest.md) | The fields of the connection to update. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

