# KindeApi::UpdateEnvironmentVariableResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **message** | **String** | A Kinde generated message. | [optional] |
| **code** | **String** | A Kinde generated status code. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateEnvironmentVariableResponse.new(
  message: Environment variable updated,
  code: ENVIRONMENT_VARIABLE_UPDATED
)
```

