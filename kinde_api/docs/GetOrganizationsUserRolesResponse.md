# KindeApi::GetOrganizationsUserRolesResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **roles** | [**Array&lt;OrganizationUserRole&gt;**](OrganizationUserRole.md) |  | [optional] |
| **next_token** | **String** | Pagination token. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetOrganizationsUserRolesResponse.new(
  code: null,
  message: null,
  roles: null,
  next_token: null
)
```

