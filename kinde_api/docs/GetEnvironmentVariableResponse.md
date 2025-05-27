# KindeApi::GetEnvironmentVariableResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **environment_variable** | [**EnvironmentVariable**](EnvironmentVariable.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetEnvironmentVariableResponse.new(
  code: OK,
  message: Success,
  environment_variable: null
)
```

