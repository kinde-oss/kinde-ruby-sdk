# KindeApi::GetSubscribersResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **subscribers** | [**Array&lt;SubscribersSubscriber&gt;**](SubscribersSubscriber.md) |  | [optional] |
| **next_token** | **String** | Pagination token. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetSubscribersResponse.new(
  code: null,
  message: null,
  subscribers: null,
  next_token: null
)
```

