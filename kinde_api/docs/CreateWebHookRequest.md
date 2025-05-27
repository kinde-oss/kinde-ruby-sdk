# KindeApi::CreateWebHookRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **endpoint** | **String** | The webhook endpoint url |  |
| **event_types** | **Array&lt;String&gt;** | Array of event type keys |  |
| **name** | **String** | The webhook name |  |
| **description** | **String** | The webhook description | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateWebHookRequest.new(
  endpoint: null,
  event_types: null,
  name: null,
  description: null
)
```

