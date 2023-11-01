# KindeApi::OrganizationUserPermission

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** |  | [optional] |
| **key** | **String** |  | [optional] |
| **name** | **String** |  | [optional] |
| **description** | **String** |  | [optional] |
| **roles** | [**Array&lt;OrganizationUserPermissionRolesInner&gt;**](OrganizationUserPermissionRolesInner.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::OrganizationUserPermission.new(
  id: null,
  key: null,
  name: null,
  description: null,
  roles: null
)
```

