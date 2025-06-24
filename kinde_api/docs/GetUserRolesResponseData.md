# KindeApi::GetUserRolesResponseData

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization code the roles are associated with. | [optional] |
| **roles** | [**Array&lt;GetUserRolesResponseDataRolesInner&gt;**](GetUserRolesResponseDataRolesInner.md) | A list of roles | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetUserRolesResponseData.new(
  org_code: org_0195ac80a14e,
  roles: null
)
```

