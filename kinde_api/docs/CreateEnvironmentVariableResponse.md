# KindeApi::CreateEnvironmentVariableResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **message** | **String** | A Kinde generated message. | [optional] |
| **code** | **String** | A Kinde generated status code. | [optional] |
| **environment_variable** | [**CreateEnvironmentVariableResponseEnvironmentVariable**](CreateEnvironmentVariableResponseEnvironmentVariable.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateEnvironmentVariableResponse.new(
  message: Environment variable created,
  code: VARIABLE_CREATED,
  environment_variable: null
)
```

