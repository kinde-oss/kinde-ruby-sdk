# KindeApi::PropertiesApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_property**](PropertiesApi.md#create_property) | **POST** /api/v1/properties | Create Property |
| [**delete_property**](PropertiesApi.md#delete_property) | **DELETE** /api/v1/properties/{property_id} | Delete Property |
| [**get_properties**](PropertiesApi.md#get_properties) | **GET** /api/v1/properties | List properties |
| [**get_user_properties**](PropertiesApi.md#get_user_properties) | **GET** /account_api/v1/properties | Get properties |
| [**update_property**](PropertiesApi.md#update_property) | **PUT** /api/v1/properties/{property_id} | Update Property |


## create_property

> <CreatePropertyResponse> create_property(create_property_request)

Create Property

Create property.  <div>   <code>create:properties</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::PropertiesApi.new
create_property_request = KindeApi::CreatePropertyRequest.new({name: 'name_example', key: 'key_example', type: 'single_line_text', context: 'org', is_private: false, category_id: 'category_id_example'}) # CreatePropertyRequest | Property details.

begin
  # Create Property
  result = api_instance.create_property(create_property_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling PropertiesApi->create_property: #{e}"
end
```

#### Using the create_property_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreatePropertyResponse>, Integer, Hash)> create_property_with_http_info(create_property_request)

```ruby
begin
  # Create Property
  data, status_code, headers = api_instance.create_property_with_http_info(create_property_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreatePropertyResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling PropertiesApi->create_property_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_property_request** | [**CreatePropertyRequest**](CreatePropertyRequest.md) | Property details. |  |

### Return type

[**CreatePropertyResponse**](CreatePropertyResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## delete_property

> <SuccessResponse> delete_property(property_id)

Delete Property

Delete property.  <div>   <code>delete:properties</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::PropertiesApi.new
property_id = 'property_id_example' # String | The unique identifier for the property.

begin
  # Delete Property
  result = api_instance.delete_property(property_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling PropertiesApi->delete_property: #{e}"
end
```

#### Using the delete_property_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_property_with_http_info(property_id)

```ruby
begin
  # Delete Property
  data, status_code, headers = api_instance.delete_property_with_http_info(property_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling PropertiesApi->delete_property_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **property_id** | **String** | The unique identifier for the property. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_properties

> <GetPropertiesResponse> get_properties(opts)

List properties

Returns a list of properties  <div>   <code>read:properties</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::PropertiesApi.new
opts = {
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  starting_after: 'starting_after_example', # String | The ID of the property to start after.
  ending_before: 'ending_before_example', # String | The ID of the property to end before.
  context: 'usr' # String | Filter results by user,  organization or application context
}

begin
  # List properties
  result = api_instance.get_properties(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling PropertiesApi->get_properties: #{e}"
end
```

#### Using the get_properties_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetPropertiesResponse>, Integer, Hash)> get_properties_with_http_info(opts)

```ruby
begin
  # List properties
  data, status_code, headers = api_instance.get_properties_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetPropertiesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling PropertiesApi->get_properties_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **starting_after** | **String** | The ID of the property to start after. | [optional] |
| **ending_before** | **String** | The ID of the property to end before. | [optional] |
| **context** | **String** | Filter results by user,  organization or application context | [optional] |

### Return type

[**GetPropertiesResponse**](GetPropertiesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8, application/json


## get_user_properties

> <GetUserPropertiesResponse> get_user_properties(opts)

Get properties

Returns all properties for the user 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::PropertiesApi.new
opts = {
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  starting_after: 'prop_1234567890abcdef' # String | The ID of the property to start after.
}

begin
  # Get properties
  result = api_instance.get_user_properties(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling PropertiesApi->get_user_properties: #{e}"
end
```

#### Using the get_user_properties_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetUserPropertiesResponse>, Integer, Hash)> get_user_properties_with_http_info(opts)

```ruby
begin
  # Get properties
  data, status_code, headers = api_instance.get_user_properties_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetUserPropertiesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling PropertiesApi->get_user_properties_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **starting_after** | **String** | The ID of the property to start after. | [optional] |

### Return type

[**GetUserPropertiesResponse**](GetUserPropertiesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## update_property

> <SuccessResponse> update_property(property_id, update_property_request)

Update Property

Update property.  <div>   <code>update:properties</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::PropertiesApi.new
property_id = 'property_id_example' # String | The unique identifier for the property.
update_property_request = KindeApi::UpdatePropertyRequest.new({name: 'name_example', is_private: false, category_id: 'category_id_example'}) # UpdatePropertyRequest | The fields of the property to update.

begin
  # Update Property
  result = api_instance.update_property(property_id, update_property_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling PropertiesApi->update_property: #{e}"
end
```

#### Using the update_property_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_property_with_http_info(property_id, update_property_request)

```ruby
begin
  # Update Property
  data, status_code, headers = api_instance.update_property_with_http_info(property_id, update_property_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling PropertiesApi->update_property_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **property_id** | **String** | The unique identifier for the property. |  |
| **update_property_request** | [**UpdatePropertyRequest**](UpdatePropertyRequest.md) | The fields of the property to update. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8

