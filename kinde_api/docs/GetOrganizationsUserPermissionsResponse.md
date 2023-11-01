# KindeApi::GetOrganizationsUserPermissionsResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **permissions** | [**Array&lt;OrganizationUserPermission&gt;**](OrganizationUserPermission.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetOrganizationsUserPermissionsResponse.new(
  code: null,
  message: null,
  permissions: null
)
```

