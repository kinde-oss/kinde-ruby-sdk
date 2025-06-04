# KindeApi::UpdateEnvironmentVariableRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **key** | **String** | The key to update. | [optional] |
| **value** | **String** | The new value for the environment variable. | [optional] |
| **is_secret** | **Boolean** | Whether the environment variable is sensitive. Secret variables are not-readable by you or your team after creation. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateEnvironmentVariableRequest.new(
  key: MY_API_KEY,
  value: new-secret-value,
  is_secret: null
)
```

