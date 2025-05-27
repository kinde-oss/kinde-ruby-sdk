# KindeApi::GetIndustriesResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **industries** | [**Array&lt;GetIndustriesResponseIndustriesInner&gt;**](GetIndustriesResponseIndustriesInner.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetIndustriesResponse.new(
  code: OK,
  message: Success,
  industries: null
)
```

