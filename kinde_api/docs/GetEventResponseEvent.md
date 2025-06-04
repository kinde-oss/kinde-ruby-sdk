# KindeApi::GetEventResponseEvent

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **type** | **String** |  | [optional] |
| **source** | **String** |  | [optional] |
| **event_id** | **String** |  | [optional] |
| **timestamp** | **Integer** | Timestamp in ISO 8601 format. | [optional] |
| **data** | **Object** | Event specific data object. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetEventResponseEvent.new(
  type: null,
  source: null,
  event_id: null,
  timestamp: null,
  data: null
)
```

