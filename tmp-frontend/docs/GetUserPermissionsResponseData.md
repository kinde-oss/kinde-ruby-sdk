# KindeFrontendApi::GetUserPermissionsResponseData

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization code the roles are associated with. | [optional] |
| **permissions** | [**Array&lt;GetUserPermissionsResponseDataPermissionsInner&gt;**](GetUserPermissionsResponseDataPermissionsInner.md) | A list of permissions | [optional] |

## Example

```ruby
require 'kinde_frontend_api'

instance = KindeFrontendApi::GetUserPermissionsResponseData.new(
  org_code: org_0195ac80a14e,
  permissions: null
)
```

