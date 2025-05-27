# KindeApi::Webhook

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** |  | [optional] |
| **name** | **String** |  | [optional] |
| **endpoint** | **String** |  | [optional] |
| **description** | **String** |  | [optional] |
| **event_types** | **Array&lt;String&gt;** |  | [optional] |
| **created_on** | **String** | Created on date in ISO 8601 format. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::Webhook.new(
  id: null,
  name: null,
  endpoint: null,
  description: null,
  event_types: null,
  created_on: null
)
```

