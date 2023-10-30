# KindeApi::CreatePermissionRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | The permission&#39;s name. | [optional] |
| **description** | **String** | The permission&#39;s description. | [optional] |
| **key** | **String** | The permission identifier to use in code. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreatePermissionRequest.new(
  name: null,
  description: null,
  key: null
)
```

