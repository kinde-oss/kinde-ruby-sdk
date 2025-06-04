# KindeApi::UpdateOrganizationUsersRequestUsersInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The users id. | [optional] |
| **operation** | **String** | Optional operation, set to &#39;delete&#39; to remove the user from the organization. | [optional] |
| **roles** | **Array&lt;String&gt;** | Role keys to assign to the user. | [optional] |
| **permissions** | **Array&lt;String&gt;** | Permission keys to assign to the user. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateOrganizationUsersRequestUsersInner.new(
  id: kp_057ee6debc624c70947b6ba512908c35,
  operation: delete,
  roles: null,
  permissions: null
)
```

