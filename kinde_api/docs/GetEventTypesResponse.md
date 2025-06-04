# KindeApi::GetEventTypesResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **event_types** | [**Array&lt;EventType&gt;**](EventType.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetEventTypesResponse.new(
  code: null,
  message: null,
  event_types: null
)
```

