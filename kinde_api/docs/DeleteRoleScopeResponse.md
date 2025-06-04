# KindeApi::DeleteRoleScopeResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::DeleteRoleScopeResponse.new(
  code: SCOPE_DELETED,
  message: Scope deleted from role
)
```

