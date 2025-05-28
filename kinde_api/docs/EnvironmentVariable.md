# KindeApi::EnvironmentVariable

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The unique ID for the environment variable. | [optional] |
| **key** | **String** | The name of the environment variable. | [optional] |
| **value** | **String** | The value of the environment variable. | [optional] |
| **is_secret** | **Boolean** | Whether the environment variable is sensitive. | [optional] |
| **created_on** | **String** | The date the environment variable was created. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::EnvironmentVariable.new(
  id: env_var_0192b1941f125645fa15bf28a662a0b3,
  key: MY_API_KEY,
  value: some-secret,
  is_secret: false,
  created_on: 2021-01-01T00:00:00Z
)
```

