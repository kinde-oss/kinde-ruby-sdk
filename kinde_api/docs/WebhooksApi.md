# KindeApi::WebhooksApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_web_hook**](WebhooksApi.md#create_web_hook) | **POST** /api/v1/webhooks | Create a Webhook |
| [**delete_web_hook**](WebhooksApi.md#delete_web_hook) | **DELETE** /api/v1/webhooks/{webhook_id} | Delete Webhook |
| [**get_event**](WebhooksApi.md#get_event) | **GET** /api/v1/events/{event_id} | Get Event |
| [**get_event_types**](WebhooksApi.md#get_event_types) | **GET** /api/v1/event_types | List Event Types |
| [**get_web_hooks**](WebhooksApi.md#get_web_hooks) | **GET** /api/v1/webhooks | List Webhooks |
| [**update_web_hook**](WebhooksApi.md#update_web_hook) | **PATCH** /api/v1/webhooks/{webhook_id} | Update a Webhook |


## create_web_hook

> <CreateWebhookResponse> create_web_hook(create_web_hook_request)

Create a Webhook

Create a webhook  <div>   <code>create:webhooks</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::WebhooksApi.new
create_web_hook_request = KindeApi::CreateWebHookRequest.new({endpoint: 'endpoint_example', event_types: ['event_types_example'], name: 'name_example'}) # CreateWebHookRequest | Webhook request specification.

begin
  # Create a Webhook
  result = api_instance.create_web_hook(create_web_hook_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling WebhooksApi->create_web_hook: #{e}"
end
```

#### Using the create_web_hook_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateWebhookResponse>, Integer, Hash)> create_web_hook_with_http_info(create_web_hook_request)

```ruby
begin
  # Create a Webhook
  data, status_code, headers = api_instance.create_web_hook_with_http_info(create_web_hook_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateWebhookResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling WebhooksApi->create_web_hook_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_web_hook_request** | [**CreateWebHookRequest**](CreateWebHookRequest.md) | Webhook request specification. |  |

### Return type

[**CreateWebhookResponse**](CreateWebhookResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json; charset=utf-8, application/json


## delete_web_hook

> <DeleteWebhookResponse> delete_web_hook(webhook_id)

Delete Webhook

Delete webhook  <div>   <code>delete:webhooks</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::WebhooksApi.new
webhook_id = 'webhook_id_example' # String | The webhook id.

begin
  # Delete Webhook
  result = api_instance.delete_web_hook(webhook_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling WebhooksApi->delete_web_hook: #{e}"
end
```

#### Using the delete_web_hook_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<DeleteWebhookResponse>, Integer, Hash)> delete_web_hook_with_http_info(webhook_id)

```ruby
begin
  # Delete Webhook
  data, status_code, headers = api_instance.delete_web_hook_with_http_info(webhook_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <DeleteWebhookResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling WebhooksApi->delete_web_hook_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **webhook_id** | **String** | The webhook id. |  |

### Return type

[**DeleteWebhookResponse**](DeleteWebhookResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8, application/json


## get_event

> <GetEventResponse> get_event(event_id)

Get Event

Returns an event  <div>   <code>read:events</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::WebhooksApi.new
event_id = 'event_id_example' # String | The event id.

begin
  # Get Event
  result = api_instance.get_event(event_id)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling WebhooksApi->get_event: #{e}"
end
```

#### Using the get_event_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetEventResponse>, Integer, Hash)> get_event_with_http_info(event_id)

```ruby
begin
  # Get Event
  data, status_code, headers = api_instance.get_event_with_http_info(event_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetEventResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling WebhooksApi->get_event_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **event_id** | **String** | The event id. |  |

### Return type

[**GetEventResponse**](GetEventResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8, application/json


## get_event_types

> <GetEventTypesResponse> get_event_types

List Event Types

Returns a list event type definitions  <div>   <code>read:event_types</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::WebhooksApi.new

begin
  # List Event Types
  result = api_instance.get_event_types
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling WebhooksApi->get_event_types: #{e}"
end
```

#### Using the get_event_types_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetEventTypesResponse>, Integer, Hash)> get_event_types_with_http_info

```ruby
begin
  # List Event Types
  data, status_code, headers = api_instance.get_event_types_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetEventTypesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling WebhooksApi->get_event_types_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**GetEventTypesResponse**](GetEventTypesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8, application/json


## get_web_hooks

> <GetWebhooksResponse> get_web_hooks

List Webhooks

List webhooks  <div>   <code>read:webhooks</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::WebhooksApi.new

begin
  # List Webhooks
  result = api_instance.get_web_hooks
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling WebhooksApi->get_web_hooks: #{e}"
end
```

#### Using the get_web_hooks_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetWebhooksResponse>, Integer, Hash)> get_web_hooks_with_http_info

```ruby
begin
  # List Webhooks
  data, status_code, headers = api_instance.get_web_hooks_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetWebhooksResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling WebhooksApi->get_web_hooks_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**GetWebhooksResponse**](GetWebhooksResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8, application/json


## update_web_hook

> <UpdateWebhookResponse> update_web_hook(webhook_id, update_web_hook_request)

Update a Webhook

Update a webhook  <div>   <code>update:webhooks</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::WebhooksApi.new
webhook_id = 'webhook_id_example' # String | The webhook id.
update_web_hook_request = KindeApi::UpdateWebHookRequest.new # UpdateWebHookRequest | Update webhook request specification.

begin
  # Update a Webhook
  result = api_instance.update_web_hook(webhook_id, update_web_hook_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling WebhooksApi->update_web_hook: #{e}"
end
```

#### Using the update_web_hook_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<UpdateWebhookResponse>, Integer, Hash)> update_web_hook_with_http_info(webhook_id, update_web_hook_request)

```ruby
begin
  # Update a Webhook
  data, status_code, headers = api_instance.update_web_hook_with_http_info(webhook_id, update_web_hook_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <UpdateWebhookResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling WebhooksApi->update_web_hook_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **webhook_id** | **String** | The webhook id. |  |
| **update_web_hook_request** | [**UpdateWebHookRequest**](UpdateWebHookRequest.md) | Update webhook request specification. |  |

### Return type

[**UpdateWebhookResponse**](UpdateWebhookResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json; charset=utf-8, application/json

