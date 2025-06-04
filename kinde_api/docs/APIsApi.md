# KindeApi::APIsApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**add_api_application_scope**](APIsApi.md#add_api_application_scope) | **POST** /api/v1/apis/{api_id}/applications/{application_id}/scopes/{scope_id} | Add scope to API application |
| [**add_api_scope**](APIsApi.md#add_api_scope) | **POST** /api/v1/apis/{api_id}/scopes | Create API scope |
| [**add_apis**](APIsApi.md#add_apis) | **POST** /api/v1/apis | Create API |
| [**delete_api**](APIsApi.md#delete_api) | **DELETE** /api/v1/apis/{api_id} | Delete API |
| [**delete_api_appliation_scope**](APIsApi.md#delete_api_appliation_scope) | **DELETE** /api/v1/apis/{api_id}/applications/{application_id}/scopes/{scope_id} | Delete API application scope |
| [**delete_api_scope**](APIsApi.md#delete_api_scope) | **DELETE** /api/v1/apis/{api_id}/scopes/{scope_id} | Delete API scope |
| [**get_api**](APIsApi.md#get_api) | **GET** /api/v1/apis/{api_id} | Get API |
| [**get_api_scope**](APIsApi.md#get_api_scope) | **GET** /api/v1/apis/{api_id}/scopes/{scope_id} | Get API scope |
| [**get_api_scopes**](APIsApi.md#get_api_scopes) | **GET** /api/v1/apis/{api_id}/scopes | Get API scopes |
| [**get_apis**](APIsApi.md#get_apis) | **GET** /api/v1/apis | Get APIs |
| [**update_api_applications**](APIsApi.md#update_api_applications) | **PATCH** /api/v1/apis/{api_id}/applications | Authorize API applications |
| [**update_api_scope**](APIsApi.md#update_api_scope) | **PATCH** /api/v1/apis/{api_id}/scopes/{scope_id} | Update API scope |


## add_api_application_scope

> add_api_application_scope(api_id, application_id, scope_id)

Add scope to API application

Add a scope to an API application.  <div>   <code>create:api_application_scopes</code> </div> 

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
api_id = '838f208d006a482dbd8cdb79a9889f68' # String | API ID
application_id = '7643b487c97545aab79257fd13a1085a' # String | Application ID
scope_id = 'api_scope_019391daf58d87d8a7213419c016ac95' # String | Scope ID

begin
  # Add scope to API application
  api_instance.add_api_application_scope(api_id, application_id, scope_id)
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->add_api_application_scope: #{e}"
end
```

#### Using the add_api_application_scope_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> add_api_application_scope_with_http_info(api_id, application_id, scope_id)

```ruby
begin
  # Add scope to API application
  data, status_code, headers = api_instance.add_api_application_scope_with_http_info(api_id, application_id, scope_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->add_api_application_scope_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **api_id** | **String** | API ID |  |
| **application_id** | **String** | Application ID |  |
| **scope_id** | **String** | Scope ID |  |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## add_api_scope

> <CreateApiScopesResponse> add_api_scope(api_id, add_api_scope_request)

Create API scope

Create a new API scope.  <div>   <code>create:api_scopes</code> </div> 

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
api_id = '838f208d006a482dbd8cdb79a9889f68' # String | API ID
add_api_scope_request = KindeApi::AddAPIScopeRequest.new({key: 'read:logs'}) # AddAPIScopeRequest | 

begin
  # Create API scope
  result = api_instance.add_api_scope(api_id, add_api_scope_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->add_api_scope: #{e}"
end
```

#### Using the add_api_scope_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateApiScopesResponse>, Integer, Hash)> add_api_scope_with_http_info(api_id, add_api_scope_request)

```ruby
begin
  # Create API scope
  data, status_code, headers = api_instance.add_api_scope_with_http_info(api_id, add_api_scope_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateApiScopesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->add_api_scope_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **api_id** | **String** | API ID |  |
| **add_api_scope_request** | [**AddAPIScopeRequest**](AddAPIScopeRequest.md) |  |  |

### Return type

[**CreateApiScopesResponse**](CreateApiScopesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## add_apis

> <CreateApisResponse> add_apis(add_apis_request)

Create API

Register a new API. For more information read [Register and manage APIs](https://docs.kinde.com/developer-tools/your-apis/register-manage-apis/).  <div>   <code>create:apis</code> </div> 

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
add_apis_request = KindeApi::AddAPIsRequest.new({name: 'Example API', audience: 'https://api.example.com'}) # AddAPIsRequest | 

begin
  # Create API
  result = api_instance.add_apis(add_apis_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->add_apis: #{e}"
end
```

#### Using the add_apis_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateApisResponse>, Integer, Hash)> add_apis_with_http_info(add_apis_request)

```ruby
begin
  # Create API
  data, status_code, headers = api_instance.add_apis_with_http_info(add_apis_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateApisResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->add_apis_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **add_apis_request** | [**AddAPIsRequest**](AddAPIsRequest.md) |  |  |

### Return type

[**CreateApisResponse**](CreateApisResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## delete_api

> <DeleteApiResponse> delete_api(api_id)

Delete API

Delete an API you previously created.  <div>   <code>delete:apis</code> </div> 

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
api_id = '7ccd126599aa422a771abcb341596881' # String | The API's ID.

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

> <Array(<DeleteApiResponse>, Integer, Hash)> delete_api_with_http_info(api_id)

```ruby
begin
  # Delete API
  data, status_code, headers = api_instance.delete_api_with_http_info(api_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <DeleteApiResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->delete_api_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **api_id** | **String** | The API&#39;s ID. |  |

### Return type

[**DeleteApiResponse**](DeleteApiResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## delete_api_appliation_scope

> delete_api_appliation_scope(api_id, application_id, scope_id)

Delete API application scope

Delete an API application scope you previously created.  <div>   <code>delete:apis_application_scopes</code> </div> 

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
api_id = '838f208d006a482dbd8cdb79a9889f68' # String | API ID
application_id = '7643b487c97545aab79257fd13a1085a' # String | Application ID
scope_id = 'api_scope_019391daf58d87d8a7213419c016ac95' # String | Scope ID

begin
  # Delete API application scope
  api_instance.delete_api_appliation_scope(api_id, application_id, scope_id)
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->delete_api_appliation_scope: #{e}"
end
```

#### Using the delete_api_appliation_scope_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> delete_api_appliation_scope_with_http_info(api_id, application_id, scope_id)

```ruby
begin
  # Delete API application scope
  data, status_code, headers = api_instance.delete_api_appliation_scope_with_http_info(api_id, application_id, scope_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->delete_api_appliation_scope_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **api_id** | **String** | API ID |  |
| **application_id** | **String** | Application ID |  |
| **scope_id** | **String** | Scope ID |  |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## delete_api_scope

> delete_api_scope(api_id, scope_id)

Delete API scope

Delete an API scope you previously created.  <div>   <code>delete:apis_scopes</code> </div> 

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
api_id = '838f208d006a482dbd8cdb79a9889f68' # String | API ID
scope_id = 'api_scope_019391daf58d87d8a7213419c016ac95' # String | Scope ID

begin
  # Delete API scope
  api_instance.delete_api_scope(api_id, scope_id)
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->delete_api_scope: #{e}"
end
```

#### Using the delete_api_scope_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> delete_api_scope_with_http_info(api_id, scope_id)

```ruby
begin
  # Delete API scope
  data, status_code, headers = api_instance.delete_api_scope_with_http_info(api_id, scope_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->delete_api_scope_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **api_id** | **String** | API ID |  |
| **scope_id** | **String** | Scope ID |  |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_api

> <GetApiResponse> get_api(api_id)

Get API

Retrieve API details by ID.  <div>   <code>read:apis</code> </div> 

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
api_id = '7ccd126599aa422a771abcb341596881' # String | The API's ID.

begin
  # Get API
  result = api_instance.get_api(api_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->get_api: #{e}"
end
```

#### Using the get_api_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetApiResponse>, Integer, Hash)> get_api_with_http_info(api_id)

```ruby
begin
  # Get API
  data, status_code, headers = api_instance.get_api_with_http_info(api_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetApiResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->get_api_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **api_id** | **String** | The API&#39;s ID. |  |

### Return type

[**GetApiResponse**](GetApiResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_api_scope

> <GetApiScopeResponse> get_api_scope(api_id, scope_id)

Get API scope

Retrieve API scope by API ID.  <div>   <code>read:api_scopes</code> </div> 

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
api_id = '838f208d006a482dbd8cdb79a9889f68' # String | API ID
scope_id = 'api_scope_019391daf58d87d8a7213419c016ac95' # String | Scope ID

begin
  # Get API scope
  result = api_instance.get_api_scope(api_id, scope_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->get_api_scope: #{e}"
end
```

#### Using the get_api_scope_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetApiScopeResponse>, Integer, Hash)> get_api_scope_with_http_info(api_id, scope_id)

```ruby
begin
  # Get API scope
  data, status_code, headers = api_instance.get_api_scope_with_http_info(api_id, scope_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetApiScopeResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->get_api_scope_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **api_id** | **String** | API ID |  |
| **scope_id** | **String** | Scope ID |  |

### Return type

[**GetApiScopeResponse**](GetApiScopeResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_api_scopes

> <GetApiScopesResponse> get_api_scopes(api_id)

Get API scopes

Retrieve API scopes by API ID.  <div>   <code>read:api_scopes</code> </div> 

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
api_id = '838f208d006a482dbd8cdb79a9889f68' # String | API ID

begin
  # Get API scopes
  result = api_instance.get_api_scopes(api_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->get_api_scopes: #{e}"
end
```

#### Using the get_api_scopes_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetApiScopesResponse>, Integer, Hash)> get_api_scopes_with_http_info(api_id)

```ruby
begin
  # Get API scopes
  data, status_code, headers = api_instance.get_api_scopes_with_http_info(api_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetApiScopesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->get_api_scopes_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **api_id** | **String** | API ID |  |

### Return type

[**GetApiScopesResponse**](GetApiScopesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_apis

> <GetApisResponse> get_apis(opts)

Get APIs

Returns a list of your APIs. The APIs are returned sorted by name.  <div>   <code>read:apis</code> </div> 

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
opts = {
  expand: 'scopes' # String | Specify additional data to retrieve. Use \"scopes\".
}

begin
  # Get APIs
  result = api_instance.get_apis(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->get_apis: #{e}"
end
```

#### Using the get_apis_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetApisResponse>, Integer, Hash)> get_apis_with_http_info(opts)

```ruby
begin
  # Get APIs
  data, status_code, headers = api_instance.get_apis_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetApisResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->get_apis_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **expand** | **String** | Specify additional data to retrieve. Use \&quot;scopes\&quot;. | [optional] |

### Return type

[**GetApisResponse**](GetApisResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## update_api_applications

> <AuthorizeAppApiResponse> update_api_applications(api_id, update_api_applications_request)

Authorize API applications

Authorize applications to be allowed to request access tokens for an API  <div>   <code>update:apis</code> </div> 

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
api_id = '7ccd126599aa422a771abcb341596881' # String | The API's ID.
update_api_applications_request = KindeApi::UpdateAPIApplicationsRequest.new({applications: [KindeApi::UpdateAPIApplicationsRequestApplicationsInner.new({id: 'd2db282d6214242b3b145c123f0c123'})]}) # UpdateAPIApplicationsRequest | The applications you want to authorize.

begin
  # Authorize API applications
  result = api_instance.update_api_applications(api_id, update_api_applications_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->update_api_applications: #{e}"
end
```

#### Using the update_api_applications_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<AuthorizeAppApiResponse>, Integer, Hash)> update_api_applications_with_http_info(api_id, update_api_applications_request)

```ruby
begin
  # Authorize API applications
  data, status_code, headers = api_instance.update_api_applications_with_http_info(api_id, update_api_applications_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <AuthorizeAppApiResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->update_api_applications_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **api_id** | **String** | The API&#39;s ID. |  |
| **update_api_applications_request** | [**UpdateAPIApplicationsRequest**](UpdateAPIApplicationsRequest.md) | The applications you want to authorize. |  |

### Return type

[**AuthorizeAppApiResponse**](AuthorizeAppApiResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## update_api_scope

> update_api_scope(api_id, scope_id, update_api_scope_request)

Update API scope

Update an API scope.  <div>   <code>update:api_scopes</code> </div> 

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
api_id = '838f208d006a482dbd8cdb79a9889f68' # String | API ID
scope_id = 'api_scope_019391daf58d87d8a7213419c016ac95' # String | Scope ID
update_api_scope_request = KindeApi::UpdateAPIScopeRequest.new # UpdateAPIScopeRequest | 

begin
  # Update API scope
  api_instance.update_api_scope(api_id, scope_id, update_api_scope_request)
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->update_api_scope: #{e}"
end
```

#### Using the update_api_scope_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> update_api_scope_with_http_info(api_id, scope_id, update_api_scope_request)

```ruby
begin
  # Update API scope
  data, status_code, headers = api_instance.update_api_scope_with_http_info(api_id, scope_id, update_api_scope_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue KindeApi::ApiError => e
  puts "Error when calling APIsApi->update_api_scope_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **api_id** | **String** | API ID |  |
| **scope_id** | **String** | Scope ID |  |
| **update_api_scope_request** | [**UpdateAPIScopeRequest**](UpdateAPIScopeRequest.md) |  |  |

### Return type

nil (empty response body)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

