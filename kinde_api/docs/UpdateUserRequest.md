# KindeApi::UpdateUserRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **given_name** | **String** | User&#39;s first name. | [optional] |
| **family_name** | **String** | User&#39;s last name. | [optional] |
| **picture** | **String** | The user&#39;s profile picture. | [optional] |
| **is_suspended** | **Boolean** | Whether the user is currently suspended or not. | [optional] |
| **is_password_reset_requested** | **Boolean** | Prompt the user to change their password on next sign in. | [optional] |
| **provided_id** | **String** | An external id to reference the user. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateUserRequest.new(
  given_name: null,
  family_name: null,
  picture: null,
  is_suspended: null,
  is_password_reset_requested: null,
  provided_id: null
)
```

