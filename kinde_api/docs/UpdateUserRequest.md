# KindeApi::UpdateUserRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **given_name** | **String** | User&#39;s first name. | [optional] |
| **family_name** | **String** | User&#39;s last name. | [optional] |
| **is_suspended** | **Boolean** | Whether the user is currently suspended or not. | [optional] |
| **is_password_reset_requested** | **Boolean** | Prompt the user to change their password on next sign in. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateUserRequest.new(
  given_name: null,
  family_name: null,
  is_suspended: null,
  is_password_reset_requested: null
)
```

