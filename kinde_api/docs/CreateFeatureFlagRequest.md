# KindeApi::CreateFeatureFlagRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | The name of the flag. |  |
| **description** | **String** | Description of the flag purpose. | [optional] |
| **key** | **String** | The flag identifier to use in code. |  |
| **type** | **String** | The variable type. |  |
| **allow_override_level** | **String** | Allow the flag to be overridden at a different level. | [optional] |
| **default_value** | **String** | Default value for the flag used by environments and organizations. |  |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateFeatureFlagRequest.new(
  name: null,
  description: null,
  key: null,
  type: null,
  allow_override_level: null,
  default_value: null
)
```

