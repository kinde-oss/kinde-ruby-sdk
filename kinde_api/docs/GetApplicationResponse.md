# KindeApi::GetApplicationResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **application** | [**GetApplicationResponseApplication**](GetApplicationResponseApplication.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetApplicationResponse.new(
  code: null,
  message: null,
  application: null
)
```

