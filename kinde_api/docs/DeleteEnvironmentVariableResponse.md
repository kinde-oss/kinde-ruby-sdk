# KindeApi::DeleteEnvironmentVariableResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **message** | **String** | A Kinde generated message. | [optional] |
| **code** | **String** | A Kinde generated status code. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::DeleteEnvironmentVariableResponse.new(
  message: Environment variable deleted,
  code: ENVIRONMENT_VARIABLE_DELETED
)
```

