# KindeApi::CreateApplicationResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **application** | [**CreateApplicationResponseApplication**](CreateApplicationResponseApplication.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateApplicationResponse.new(
  code: null,
  message: null,
  application: null
)
```

