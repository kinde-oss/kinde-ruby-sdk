# KindeApi::CreateEnvironmentVariableRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **key** | **String** | The name of the environment variable (max 128 characters). |  |
| **value** | **String** | The value of the new environment variable (max 2048 characters). |  |
| **is_secret** | **Boolean** | Whether the environment variable is sensitive. Secrets are not-readable by you or your team after creation. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateEnvironmentVariableRequest.new(
  key: MY_API_KEY,
  value: some-secret-value,
  is_secret: false
)
```

