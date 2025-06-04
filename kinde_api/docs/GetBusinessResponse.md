# KindeApi::GetBusinessResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **business** | [**GetBusinessResponseBusiness**](GetBusinessResponseBusiness.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetBusinessResponse.new(
  code: OK,
  message: Success,
  business: null
)
```

