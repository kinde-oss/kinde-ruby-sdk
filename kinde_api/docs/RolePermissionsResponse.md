# KindeApi::RolePermissionsResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **permissions** | [**Array&lt;Permissions&gt;**](Permissions.md) |  | [optional] |
| **next_token** | **String** | Pagination token. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::RolePermissionsResponse.new(
  code: null,
  message: null,
  permissions: null,
  next_token: null
)
```

