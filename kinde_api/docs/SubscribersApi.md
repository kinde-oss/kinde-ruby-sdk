# KindeApi::SubscribersApi

All URIs are relative to *https://app.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_subscriber**](SubscribersApi.md#create_subscriber) | **POST** /api/v1/subscribers | Create a new subscriber |
| [**get_subscriber**](SubscribersApi.md#get_subscriber) | **GET** /api/v1/subscribers/{subscriber_id} | Get Subscriber |
| [**get_subscribers**](SubscribersApi.md#get_subscribers) | **GET** /api/v1/subscribers | List Subscribers |


## create_subscriber

> <CreateSubscriberSuccessResponse> create_subscriber(first_name, last_name, email)

Create a new subscriber

Create subscriber.

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::SubscribersApi.new
first_name = 'first_name_example' # String | Subscriber's first name.
last_name = 'last_name_example' # String | Subscriber's last name.
email = 'email_example' # String | The email address of the subscriber.

begin
  # Create a new subscriber
  result = api_instance.create_subscriber(first_name, last_name, email)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling SubscribersApi->create_subscriber: #{e}"
end
```

#### Using the create_subscriber_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateSubscriberSuccessResponse>, Integer, Hash)> create_subscriber_with_http_info(first_name, last_name, email)

```ruby
begin
  # Create a new subscriber
  data, status_code, headers = api_instance.create_subscriber_with_http_info(first_name, last_name, email)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateSubscriberSuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling SubscribersApi->create_subscriber_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **first_name** | **String** | Subscriber&#39;s first name. |  |
| **last_name** | **String** | Subscriber&#39;s last name. |  |
| **email** | **String** | The email address of the subscriber. |  |

### Return type

[**CreateSubscriberSuccessResponse**](CreateSubscriberSuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8


## get_subscriber

> <SuccessResponse> get_subscriber(subscriber_id)

Get Subscriber

Retrieve a subscriber record. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::SubscribersApi.new
subscriber_id = 'subscriber_id_example' # String | The subscriber's id.

begin
  # Get Subscriber
  result = api_instance.get_subscriber(subscriber_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling SubscribersApi->get_subscriber: #{e}"
end
```

#### Using the get_subscriber_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> get_subscriber_with_http_info(subscriber_id)

```ruby
begin
  # Get Subscriber
  data, status_code, headers = api_instance.get_subscriber_with_http_info(subscriber_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling SubscribersApi->get_subscriber_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **subscriber_id** | **String** | The subscriber&#39;s id. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8


## get_subscribers

> <SuccessResponse> get_subscribers(opts)

List Subscribers

The returned list can be sorted by full name or email address in ascending or descending order. The number of records to return at a time can also be controlled using the `page_size` query string parameter. 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::SubscribersApi.new
opts = {
  sort: 'name_asc', # String | Field and order to sort the result by.
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  subscriber_id: 56, # Integer | ID of the subscriber to filter by.
  next_token: 'next_token_example' # String | A string to get the next page of results if there are more results.
}

begin
  # List Subscribers
  result = api_instance.get_subscribers(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling SubscribersApi->get_subscribers: #{e}"
end
```

#### Using the get_subscribers_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> get_subscribers_with_http_info(opts)

```ruby
begin
  # List Subscribers
  data, status_code, headers = api_instance.get_subscribers_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling SubscribersApi->get_subscribers_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **sort** | **String** | Field and order to sort the result by. | [optional] |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **subscriber_id** | **Integer** | ID of the subscriber to filter by. | [optional] |
| **next_token** | **String** | A string to get the next page of results if there are more results. | [optional] |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8

