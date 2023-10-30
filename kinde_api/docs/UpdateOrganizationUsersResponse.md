# KindeApi::UpdateOrganizationUsersResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **message** | **String** |  | [optional] |
| **users_added** | **Array&lt;String&gt;** |  | [optional] |
| **users_updated** | **Array&lt;String&gt;** |  | [optional] |
| **users_removed** | **Array&lt;String&gt;** |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateOrganizationUsersResponse.new(
  message: null,
  users_added: null,
  users_updated: null,
  users_removed: null
)
```

