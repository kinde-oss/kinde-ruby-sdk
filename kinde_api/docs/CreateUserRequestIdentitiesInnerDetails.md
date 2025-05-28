# KindeApi::CreateUserRequestIdentitiesInnerDetails

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **email** | **String** | The email address of the user. | [optional] |
| **phone** | **String** | The phone number of the user. | [optional] |
| **phone_country_id** | **String** | The country code for the phone number. | [optional] |
| **username** | **String** | The username of the user. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateUserRequestIdentitiesInnerDetails.new(
  email: email@email.com,
  phone: +61426148233,
  phone_country_id: au,
  username: myusername
)
```

