# KindeApi::UpdateUserResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | Unique ID of the user in Kinde. | [optional] |
| **given_name** | **String** | User&#39;s first name. | [optional] |
| **family_name** | **String** | User&#39;s last name. | [optional] |
| **email** | **String** | User&#39;s preferred email. | [optional] |
| **is_suspended** | **Boolean** | Whether the user is currently suspended or not. | [optional] |
| **is_password_reset_requested** | **Boolean** | Whether a password reset has been requested. | [optional] |
| **picture** | **String** | User&#39;s profile picture URL. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateUserResponse.new(
  id: null,
  given_name: null,
  family_name: null,
  email: null,
  is_suspended: null,
  is_password_reset_requested: null,
  picture: null
)
```

