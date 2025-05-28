# KindeApi::GetTimezonesResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **timezones** | [**Array&lt;GetTimezonesResponseTimezonesInner&gt;**](GetTimezonesResponseTimezonesInner.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetTimezonesResponse.new(
  code: OK,
  message: Success,
  timezones: null
)
```

