# KindeSdk::OAuthApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_user**](OAuthApi.md#get_user) | **GET** /oauth2/user_profile | Returns the details of the currently logged in user |
| [**get_user_profile_v2**](OAuthApi.md#get_user_profile_v2) | **GET** /oauth2/v2/user_profile | Returns the details of the currently logged in user |


## get_user

> <UserProfile> get_user

Returns the details of the currently logged in user

Contains the id, names and email of the currently logged in user. 

### Examples

```ruby
require 'time'
require 'kinde_sdk'
# setup authorization
KindeSdk.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeSdk::OAuthApi.new

begin
  # Returns the details of the currently logged in user
  result = api_instance.get_user
  p result
rescue KindeSdk::ApiError => e
  puts "Error when calling OAuthApi->get_user: #{e}"
end
```

#### Using the get_user_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<UserProfile>, Integer, Hash)> get_user_with_http_info

```ruby
begin
  # Returns the details of the currently logged in user
  data, status_code, headers = api_instance.get_user_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <UserProfile>
rescue KindeSdk::ApiError => e
  puts "Error when calling OAuthApi->get_user_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**UserProfile**](UserProfile.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_user_profile_v2

> <UserProfileV2> get_user_profile_v2

Returns the details of the currently logged in user

Contains the id, names, profile picture URL and email of the currently logged in user. 

### Examples

```ruby
require 'time'
require 'kinde_sdk'
# setup authorization
KindeSdk.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeSdk::OAuthApi.new

begin
  # Returns the details of the currently logged in user
  result = api_instance.get_user_profile_v2
  p result
rescue KindeSdk::ApiError => e
  puts "Error when calling OAuthApi->get_user_profile_v2: #{e}"
end
```

#### Using the get_user_profile_v2_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<UserProfileV2>, Integer, Hash)> get_user_profile_v2_with_http_info

```ruby
begin
  # Returns the details of the currently logged in user
  data, status_code, headers = api_instance.get_user_profile_v2_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <UserProfileV2>
rescue KindeSdk::ApiError => e
  puts "Error when calling OAuthApi->get_user_profile_v2_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**UserProfileV2**](UserProfileV2.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

