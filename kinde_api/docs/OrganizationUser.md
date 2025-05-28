# KindeApi::OrganizationUser

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The unique ID for the user. | [optional] |
| **email** | **String** | The user&#39;s email address. | [optional] |
| **full_name** | **String** | The user&#39;s full name. | [optional] |
| **last_name** | **String** | The user&#39;s last name. | [optional] |
| **first_name** | **String** | The user&#39;s first name. | [optional] |
| **picture** | **String** | The user&#39;s profile picture URL. | [optional] |
| **joined_on** | **String** | The date the user joined the organization. | [optional] |
| **last_accessed_on** | **String** | The date the user last accessed the organization. | [optional] |
| **roles** | **Array&lt;String&gt;** | The roles the user has in the organization. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::OrganizationUser.new(
  id: kp:97c2ba24217d48e3b96a799b76cf2c74,
  email: john.snow@example.com,
  full_name: John Snow,
  last_name: Snow,
  first_name: John,
  picture: https://example.com/john_snow.jpg,
  joined_on: 2021-01-01T00:00:00Z,
  last_accessed_on: 2022-01-01T00:00:00Z,
  roles: null
)
```

