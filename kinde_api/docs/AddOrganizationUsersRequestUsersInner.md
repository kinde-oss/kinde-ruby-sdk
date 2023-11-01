# KindeApi::AddOrganizationUsersRequestUsersInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The users id. | [optional] |
| **roles** | **Array&lt;String&gt;** | Role keys to assign to the user. | [optional] |
| **permissions** | **Array&lt;String&gt;** | Permission keys to assign to the user. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::AddOrganizationUsersRequestUsersInner.new(
  id: null,
  roles: null,
  permissions: null
)
```

