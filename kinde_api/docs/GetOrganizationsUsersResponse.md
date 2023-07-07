# KindeApi::GetOrganizationsUsersResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **organization_users** | [**Array&lt;OrganizationUser&gt;**](OrganizationUser.md) |  | [optional] |
| **next_token** | **String** | Pagination token. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetOrganizationsUsersResponse.new(
  code: null,
  message: null,
  organization_users: null,
  next_token: null
)
```

