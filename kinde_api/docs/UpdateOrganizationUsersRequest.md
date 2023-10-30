# KindeApi::UpdateOrganizationUsersRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **users** | [**Array&lt;UpdateOrganizationUsersRequestUsersInner&gt;**](UpdateOrganizationUsersRequestUsersInner.md) | Users to add, update or remove from the organization. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateOrganizationUsersRequest.new(
  users: null
)
```

