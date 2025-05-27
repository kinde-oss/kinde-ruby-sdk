# KindeApi::SearchApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**search_users**](SearchApi.md#search_users) | **GET** /api/v1/search/users | Search users |


## search_users

> <SearchUsersResponse> search_users(opts)

Search users

Search for users based on the provided query string. Set query to '*' to filter by other parameters only. The number of records to return at a time can be controlled using the `page_size` query string parameter.  <div>   <code>read:users</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::SearchApi.new
opts = {
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  query: 'query_example', # String | Search the users by email or name. Use '*' to search all.
  properties: { key: { key: ['inner_example']}}, # Hash<String, Array<String>> | 
  starting_after: 'starting_after_example', # String | The ID of the user to start after.
  ending_before: 'ending_before_example', # String | The ID of the user to end before.
  expand: 'expand_example' # String | Specify additional data to retrieve. Use \"organizations\" and/or \"identities\".
}

begin
  # Search users
  result = api_instance.search_users(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling SearchApi->search_users: #{e}"
end
```

#### Using the search_users_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SearchUsersResponse>, Integer, Hash)> search_users_with_http_info(opts)

```ruby
begin
  # Search users
  data, status_code, headers = api_instance.search_users_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SearchUsersResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling SearchApi->search_users_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **query** | **String** | Search the users by email or name. Use &#39;*&#39; to search all. | [optional] |
| **properties** | [**Hash&lt;String, Array&lt;String&gt;&gt;**](Array&lt;String&gt;.md) |  | [optional] |
| **starting_after** | **String** | The ID of the user to start after. | [optional] |
| **ending_before** | **String** | The ID of the user to end before. | [optional] |
| **expand** | **String** | Specify additional data to retrieve. Use \&quot;organizations\&quot; and/or \&quot;identities\&quot;. | [optional] |

### Return type

[**SearchUsersResponse**](SearchUsersResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

