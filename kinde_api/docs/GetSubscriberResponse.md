# KindeApi::GetSubscriberResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **subscribers** | [**Array&lt;Subscriber&gt;**](Subscriber.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetSubscriberResponse.new(
  code: null,
  message: null,
  subscribers: null
)
```

