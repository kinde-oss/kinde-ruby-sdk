# KindeApi::AddRoleScopeResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::AddRoleScopeResponse.new(
  code: ROLE_SCOPE_ADDED,
  message: Scope added to role
)
```

