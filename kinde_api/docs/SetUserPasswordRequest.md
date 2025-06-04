# KindeApi::SetUserPasswordRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **hashed_password** | **String** | The hashed password. |  |
| **hashing_method** | **String** | The hashing method or algorithm used to encrypt the user’s password. Default is bcrypt. | [optional] |
| **salt** | **String** | Extra characters added to passwords to make them stronger. Not required for bcrypt. | [optional] |
| **salt_position** | **String** | Position of salt in password string. Not required for bcrypt. | [optional] |
| **is_temporary_password** | **Boolean** | The user will be prompted to set a new password after entering this one. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::SetUserPasswordRequest.new(
  hashed_password: null,
  hashing_method: null,
  salt: null,
  salt_position: null,
  is_temporary_password: null
)
```

