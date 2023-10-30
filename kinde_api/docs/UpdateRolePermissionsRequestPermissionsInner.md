# KindeApi::UpdateRolePermissionsRequestPermissionsInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The permission id. | [optional] |
| **operation** | **String** | Optional operation, set to &#39;delete&#39; to remove the permission from the role. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateRolePermissionsRequestPermissionsInner.new(
  id: null,
  operation: null
)
```

