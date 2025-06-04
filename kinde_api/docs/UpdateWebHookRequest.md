# KindeApi::UpdateWebHookRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **event_types** | **Array&lt;String&gt;** | Array of event type keys | [optional] |
| **name** | **String** | The webhook name | [optional] |
| **description** | **String** | The webhook description | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateWebHookRequest.new(
  event_types: null,
  name: null,
  description: null
)
```

