# KindeApi::CreateUserRequestProfile

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **given_name** | **String** | User&#39;s first name. | [optional] |
| **family_name** | **String** | User&#39;s last name. | [optional] |
| **picture** | **String** | The user&#39;s profile picture. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateUserRequestProfile.new(
  given_name: null,
  family_name: null,
  picture: null
)
```

