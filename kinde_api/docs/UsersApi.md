# KindeApi::UsersApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_user**](UsersApi.md#create_user) | **POST** /api/v1/user | Create user |
| [**create_user_identity**](UsersApi.md#create_user_identity) | **POST** /api/v1/users/{user_id}/identities | Create identity |
| [**delete_user**](UsersApi.md#delete_user) | **DELETE** /api/v1/user | Delete user |
| [**delete_user_sessions**](UsersApi.md#delete_user_sessions) | **DELETE** /api/v1/users/{user_id}/sessions | Delete user sessions |
| [**get_user_data**](UsersApi.md#get_user_data) | **GET** /api/v1/user | Get user |
| [**get_user_identities**](UsersApi.md#get_user_identities) | **GET** /api/v1/users/{user_id}/identities | Get identities |
| [**get_user_property_values**](UsersApi.md#get_user_property_values) | **GET** /api/v1/users/{user_id}/properties | Get property values |
| [**get_user_sessions**](UsersApi.md#get_user_sessions) | **GET** /api/v1/users/{user_id}/sessions | Get user sessions |
| [**get_users**](UsersApi.md#get_users) | **GET** /api/v1/users | Get users |
| [**get_users_mfa**](UsersApi.md#get_users_mfa) | **GET** /api/v1/users/{user_id}/mfa | Get user&#39;s MFA configuration |
| [**refresh_user_claims**](UsersApi.md#refresh_user_claims) | **POST** /api/v1/users/{user_id}/refresh_claims | Refresh User Claims and Invalidate Cache |
| [**reset_users_mfa**](UsersApi.md#reset_users_mfa) | **DELETE** /api/v1/users/{user_id}/mfa/{factor_id} | Reset specific environment MFA for a user |
| [**reset_users_mfa_all**](UsersApi.md#reset_users_mfa_all) | **DELETE** /api/v1/users/{user_id}/mfa | Reset all environment MFA for a user |
| [**set_user_password**](UsersApi.md#set_user_password) | **PUT** /api/v1/users/{user_id}/password | Set User password |
| [**update_user**](UsersApi.md#update_user) | **PATCH** /api/v1/user | Update user |
| [**update_user_feature_flag_override**](UsersApi.md#update_user_feature_flag_override) | **PATCH** /api/v1/users/{user_id}/feature_flags/{feature_flag_key} | Update User Feature Flag Override |
| [**update_user_properties**](UsersApi.md#update_user_properties) | **PATCH** /api/v1/users/{user_id}/properties | Update Property values |
| [**update_user_property**](UsersApi.md#update_user_property) | **PUT** /api/v1/users/{user_id}/properties/{property_key} | Update Property value |


## create_user

> <CreateUserResponse> create_user(opts)

Create user

Creates a user record and optionally zero or more identities for the user. An example identity could be the email address of the user.  <div>   <code>create:users</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
opts = {
  create_user_request: KindeApi::CreateUserRequest.new # CreateUserRequest | The details of the user to create.
}

begin
  # Create user
  result = api_instance.create_user(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->create_user: #{e}"
end
```

#### Using the create_user_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateUserResponse>, Integer, Hash)> create_user_with_http_info(opts)

```ruby
begin
  # Create user
  data, status_code, headers = api_instance.create_user_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateUserResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->create_user_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_user_request** | [**CreateUserRequest**](CreateUserRequest.md) | The details of the user to create. | [optional] |

### Return type

[**CreateUserResponse**](CreateUserResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## create_user_identity

> <CreateIdentityResponse> create_user_identity(user_id, opts)

Create identity

Creates an identity for a user.  <div>   <code>create:user_identities</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
user_id = 'user_id_example' # String | The user's ID.
opts = {
  create_user_identity_request: KindeApi::CreateUserIdentityRequest.new # CreateUserIdentityRequest | The identity details.
}

begin
  # Create identity
  result = api_instance.create_user_identity(user_id, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->create_user_identity: #{e}"
end
```

#### Using the create_user_identity_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateIdentityResponse>, Integer, Hash)> create_user_identity_with_http_info(user_id, opts)

```ruby
begin
  # Create identity
  data, status_code, headers = api_instance.create_user_identity_with_http_info(user_id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateIdentityResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->create_user_identity_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **user_id** | **String** | The user&#39;s ID. |  |
| **create_user_identity_request** | [**CreateUserIdentityRequest**](CreateUserIdentityRequest.md) | The identity details. | [optional] |

### Return type

[**CreateIdentityResponse**](CreateIdentityResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## delete_user

> <SuccessResponse> delete_user(id, opts)

Delete user

Delete a user record.  <div>   <code>delete:users</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
id = 'kp_c3143a4b50ad43c88e541d9077681782' # String | The user's id.
opts = {
  is_delete_profile: true # Boolean | Delete all data and remove the user's profile from all of Kinde, including the subscriber list
}

begin
  # Delete user
  result = api_instance.delete_user(id, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->delete_user: #{e}"
end
```

#### Using the delete_user_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_user_with_http_info(id, opts)

```ruby
begin
  # Delete user
  data, status_code, headers = api_instance.delete_user_with_http_info(id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->delete_user_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The user&#39;s id. |  |
| **is_delete_profile** | **Boolean** | Delete all data and remove the user&#39;s profile from all of Kinde, including the subscriber list | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## delete_user_sessions

> <SuccessResponse> delete_user_sessions(user_id)

Delete user sessions

Invalidate user sessions.  <div>   <code>delete:user_sessions</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
user_id = 'kp_c3143a4b50ad43c88e541d9077681782' # String | The identifier for the user

begin
  # Delete user sessions
  result = api_instance.delete_user_sessions(user_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->delete_user_sessions: #{e}"
end
```

#### Using the delete_user_sessions_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> delete_user_sessions_with_http_info(user_id)

```ruby
begin
  # Delete user sessions
  data, status_code, headers = api_instance.delete_user_sessions_with_http_info(user_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->delete_user_sessions_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **user_id** | **String** | The identifier for the user |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_user_data

> <User> get_user_data(id, opts)

Get user

Retrieve a user record.  <div>   <code>read:users</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
id = 'id_example' # String | The user's id.
opts = {
  expand: 'expand_example' # String | Specify additional data to retrieve. Use \"organizations\" and/or \"identities\".
}

begin
  # Get user
  result = api_instance.get_user_data(id, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_user_data: #{e}"
end
```

#### Using the get_user_data_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<User>, Integer, Hash)> get_user_data_with_http_info(id, opts)

```ruby
begin
  # Get user
  data, status_code, headers = api_instance.get_user_data_with_http_info(id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <User>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_user_data_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The user&#39;s id. |  |
| **expand** | **String** | Specify additional data to retrieve. Use \&quot;organizations\&quot; and/or \&quot;identities\&quot;. | [optional] |

### Return type

[**User**](User.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_user_identities

> <GetIdentitiesResponse> get_user_identities(user_id, opts)

Get identities

Gets a list of identities for an user by ID.  <div>   <code>read:user_identities</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
user_id = 'user_id_example' # String | The user's ID.
opts = {
  starting_after: 'starting_after_example', # String | The ID of the identity to start after.
  ending_before: 'ending_before_example' # String | The ID of the identity to end before.
}

begin
  # Get identities
  result = api_instance.get_user_identities(user_id, opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_user_identities: #{e}"
end
```

#### Using the get_user_identities_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetIdentitiesResponse>, Integer, Hash)> get_user_identities_with_http_info(user_id, opts)

```ruby
begin
  # Get identities
  data, status_code, headers = api_instance.get_user_identities_with_http_info(user_id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetIdentitiesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_user_identities_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **user_id** | **String** | The user&#39;s ID. |  |
| **starting_after** | **String** | The ID of the identity to start after. | [optional] |
| **ending_before** | **String** | The ID of the identity to end before. | [optional] |

### Return type

[**GetIdentitiesResponse**](GetIdentitiesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_user_property_values

> <GetPropertyValuesResponse> get_user_property_values(user_id)

Get property values

Gets properties for an user by ID.  <div>   <code>read:user_properties</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
user_id = 'user_id_example' # String | The user's ID.

begin
  # Get property values
  result = api_instance.get_user_property_values(user_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_user_property_values: #{e}"
end
```

#### Using the get_user_property_values_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetPropertyValuesResponse>, Integer, Hash)> get_user_property_values_with_http_info(user_id)

```ruby
begin
  # Get property values
  data, status_code, headers = api_instance.get_user_property_values_with_http_info(user_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetPropertyValuesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_user_property_values_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **user_id** | **String** | The user&#39;s ID. |  |

### Return type

[**GetPropertyValuesResponse**](GetPropertyValuesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## get_user_sessions

> <GetUserSessionsResponse> get_user_sessions(user_id)

Get user sessions

Retrieve the list of active sessions for a specific user.  <div>   <code>read:user_sessions</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
user_id = 'kp_c3143a4b50ad43c88e541d9077681782' # String | The identifier for the user

begin
  # Get user sessions
  result = api_instance.get_user_sessions(user_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_user_sessions: #{e}"
end
```

#### Using the get_user_sessions_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetUserSessionsResponse>, Integer, Hash)> get_user_sessions_with_http_info(user_id)

```ruby
begin
  # Get user sessions
  data, status_code, headers = api_instance.get_user_sessions_with_http_info(user_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetUserSessionsResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_user_sessions_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **user_id** | **String** | The identifier for the user |  |

### Return type

[**GetUserSessionsResponse**](GetUserSessionsResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_users

> <UsersResponse> get_users(opts)

Get users

The returned list can be sorted by full name or email address in ascending or descending order. The number of records to return at a time can also be controlled using the `page_size` query string parameter.  <div>   <code>read:users</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
opts = {
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  user_id: 'user_id_example', # String | Filter the results by User ID. The query string should be comma separated and url encoded.
  next_token: 'next_token_example', # String | A string to get the next page of results if there are more results.
  email: 'email_example', # String | Filter the results by email address. The query string should be comma separated and url encoded.
  username: 'username_example', # String | Filter the results by username. The query string should be comma separated and url encoded.
  expand: 'expand_example', # String | Specify additional data to retrieve. Use \"organizations\" and/or \"identities\".
  has_organization: true # Boolean | Filter the results by if the user has at least one organization assigned.
}

begin
  # Get users
  result = api_instance.get_users(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_users: #{e}"
end
```

#### Using the get_users_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<UsersResponse>, Integer, Hash)> get_users_with_http_info(opts)

```ruby
begin
  # Get users
  data, status_code, headers = api_instance.get_users_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <UsersResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_users_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **user_id** | **String** | Filter the results by User ID. The query string should be comma separated and url encoded. | [optional] |
| **next_token** | **String** | A string to get the next page of results if there are more results. | [optional] |
| **email** | **String** | Filter the results by email address. The query string should be comma separated and url encoded. | [optional] |
| **username** | **String** | Filter the results by username. The query string should be comma separated and url encoded. | [optional] |
| **expand** | **String** | Specify additional data to retrieve. Use \&quot;organizations\&quot; and/or \&quot;identities\&quot;. | [optional] |
| **has_organization** | **Boolean** | Filter the results by if the user has at least one organization assigned. | [optional] |

### Return type

[**UsersResponse**](UsersResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_users_mfa

> <GetUserMfaResponse> get_users_mfa(user_id)

Get user's MFA configuration

Get a user’s MFA configuration.  <div>   <code>read:user_mfa</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
user_id = 'kp_c3143a4b50ad43c88e541d9077681782' # String | The identifier for the user

begin
  # Get user's MFA configuration
  result = api_instance.get_users_mfa(user_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_users_mfa: #{e}"
end
```

#### Using the get_users_mfa_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetUserMfaResponse>, Integer, Hash)> get_users_mfa_with_http_info(user_id)

```ruby
begin
  # Get user's MFA configuration
  data, status_code, headers = api_instance.get_users_mfa_with_http_info(user_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetUserMfaResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->get_users_mfa_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **user_id** | **String** | The identifier for the user |  |

### Return type

[**GetUserMfaResponse**](GetUserMfaResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## refresh_user_claims

> <SuccessResponse> refresh_user_claims(user_id)

Refresh User Claims and Invalidate Cache

Refreshes the user's claims and invalidates the current cache.  <div>   <code>update:user_refresh_claims</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
user_id = 'user_id_example' # String | The id of the user whose claims needs to be updated.

begin
  # Refresh User Claims and Invalidate Cache
  result = api_instance.refresh_user_claims(user_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->refresh_user_claims: #{e}"
end
```

#### Using the refresh_user_claims_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> refresh_user_claims_with_http_info(user_id)

```ruby
begin
  # Refresh User Claims and Invalidate Cache
  data, status_code, headers = api_instance.refresh_user_claims_with_http_info(user_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->refresh_user_claims_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **user_id** | **String** | The id of the user whose claims needs to be updated. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8, application/json


## reset_users_mfa

> <SuccessResponse> reset_users_mfa(user_id, factor_id)

Reset specific environment MFA for a user

Reset a specific environment MFA factor for a user.  <div>   <code>delete:user_mfa</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
user_id = 'kp_c3143a4b50ad43c88e541d9077681782' # String | The identifier for the user
factor_id = 'mfa_0193278a00ac29b3f6d4e4d462d55c47' # String | The identifier for the MFA factor

begin
  # Reset specific environment MFA for a user
  result = api_instance.reset_users_mfa(user_id, factor_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->reset_users_mfa: #{e}"
end
```

#### Using the reset_users_mfa_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> reset_users_mfa_with_http_info(user_id, factor_id)

```ruby
begin
  # Reset specific environment MFA for a user
  data, status_code, headers = api_instance.reset_users_mfa_with_http_info(user_id, factor_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->reset_users_mfa_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **user_id** | **String** | The identifier for the user |  |
| **factor_id** | **String** | The identifier for the MFA factor |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## reset_users_mfa_all

> <SuccessResponse> reset_users_mfa_all(user_id)

Reset all environment MFA for a user

Reset all environment MFA factors for a user.  <div>   <code>delete:user_mfa</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
user_id = 'kp_c3143a4b50ad43c88e541d9077681782' # String | The identifier for the user

begin
  # Reset all environment MFA for a user
  result = api_instance.reset_users_mfa_all(user_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->reset_users_mfa_all: #{e}"
end
```

#### Using the reset_users_mfa_all_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> reset_users_mfa_all_with_http_info(user_id)

```ruby
begin
  # Reset all environment MFA for a user
  data, status_code, headers = api_instance.reset_users_mfa_all_with_http_info(user_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->reset_users_mfa_all_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **user_id** | **String** | The identifier for the user |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## set_user_password

> <SuccessResponse> set_user_password(user_id, set_user_password_request)

Set User password

Set user password.  <div>   <code>update:user_passwords</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
user_id = 'user_id_example' # String | The identifier for the user
set_user_password_request = KindeApi::SetUserPasswordRequest.new({hashed_password: 'hashed_password_example'}) # SetUserPasswordRequest | Password details.

begin
  # Set User password
  result = api_instance.set_user_password(user_id, set_user_password_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->set_user_password: #{e}"
end
```

#### Using the set_user_password_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> set_user_password_with_http_info(user_id, set_user_password_request)

```ruby
begin
  # Set User password
  data, status_code, headers = api_instance.set_user_password_with_http_info(user_id, set_user_password_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->set_user_password_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **user_id** | **String** | The identifier for the user |  |
| **set_user_password_request** | [**SetUserPasswordRequest**](SetUserPasswordRequest.md) | Password details. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## update_user

> <UpdateUserResponse> update_user(id, update_user_request)

Update user

Update a user record.  <div>   <code>update:users</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
id = 'id_example' # String | The user's id.
update_user_request = KindeApi::UpdateUserRequest.new # UpdateUserRequest | The user to update.

begin
  # Update user
  result = api_instance.update_user(id, update_user_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->update_user: #{e}"
end
```

#### Using the update_user_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<UpdateUserResponse>, Integer, Hash)> update_user_with_http_info(id, update_user_request)

```ruby
begin
  # Update user
  data, status_code, headers = api_instance.update_user_with_http_info(id, update_user_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <UpdateUserResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->update_user_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The user&#39;s id. |  |
| **update_user_request** | [**UpdateUserRequest**](UpdateUserRequest.md) | The user to update. |  |

### Return type

[**UpdateUserResponse**](UpdateUserResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## update_user_feature_flag_override

> <SuccessResponse> update_user_feature_flag_override(user_id, feature_flag_key, value)

Update User Feature Flag Override

Update user feature flag override.  <div>   <code>update:user_feature_flags</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
user_id = 'user_id_example' # String | The identifier for the user
feature_flag_key = 'feature_flag_key_example' # String | The identifier for the feature flag
value = 'value_example' # String | Override value

begin
  # Update User Feature Flag Override
  result = api_instance.update_user_feature_flag_override(user_id, feature_flag_key, value)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->update_user_feature_flag_override: #{e}"
end
```

#### Using the update_user_feature_flag_override_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_user_feature_flag_override_with_http_info(user_id, feature_flag_key, value)

```ruby
begin
  # Update User Feature Flag Override
  data, status_code, headers = api_instance.update_user_feature_flag_override_with_http_info(user_id, feature_flag_key, value)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->update_user_feature_flag_override_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **user_id** | **String** | The identifier for the user |  |
| **feature_flag_key** | **String** | The identifier for the feature flag |  |
| **value** | **String** | Override value |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8


## update_user_properties

> <SuccessResponse> update_user_properties(user_id, update_organization_properties_request)

Update Property values

Update property values.  <div>   <code>update:user_properties</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
user_id = 'user_id_example' # String | The identifier for the user
update_organization_properties_request = KindeApi::UpdateOrganizationPropertiesRequest.new({properties: 3.56}) # UpdateOrganizationPropertiesRequest | Properties to update.

begin
  # Update Property values
  result = api_instance.update_user_properties(user_id, update_organization_properties_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->update_user_properties: #{e}"
end
```

#### Using the update_user_properties_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_user_properties_with_http_info(user_id, update_organization_properties_request)

```ruby
begin
  # Update Property values
  data, status_code, headers = api_instance.update_user_properties_with_http_info(user_id, update_organization_properties_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->update_user_properties_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **user_id** | **String** | The identifier for the user |  |
| **update_organization_properties_request** | [**UpdateOrganizationPropertiesRequest**](UpdateOrganizationPropertiesRequest.md) | Properties to update. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## update_user_property

> <SuccessResponse> update_user_property(user_id, property_key, value)

Update Property value

Update property value.  <div>   <code>update:user_properties</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::UsersApi.new
user_id = 'user_id_example' # String | The identifier for the user
property_key = 'property_key_example' # String | The identifier for the property
value = 'value_example' # String | The new property value

begin
  # Update Property value
  result = api_instance.update_user_property(user_id, property_key, value)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->update_user_property: #{e}"
end
```

#### Using the update_user_property_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_user_property_with_http_info(user_id, property_key, value)

```ruby
begin
  # Update Property value
  data, status_code, headers = api_instance.update_user_property_with_http_info(user_id, property_key, value)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling UsersApi->update_user_property_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **user_id** | **String** | The identifier for the user |  |
| **property_key** | **String** | The identifier for the property |  |
| **value** | **String** | The new property value |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json, application/json; charset=utf-8

