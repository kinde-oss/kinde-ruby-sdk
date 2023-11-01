# KindeApi::UpdateRolePermissionsRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **permissions** | [**Array&lt;UpdateRolePermissionsRequestPermissionsInner&gt;**](UpdateRolePermissionsRequestPermissionsInner.md) | Permissions to add or remove from the role. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateRolePermissionsRequest.new(
  permissions: null
)
```

