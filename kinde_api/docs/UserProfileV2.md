# KindeApi::UserProfileV2

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **sub** | **String** | Unique ID of the user in Kinde. | [optional] |
| **provided_id** | **String** | Value of the user&#39;s ID in a third-party system when the user is imported into Kinde. | [optional] |
| **name** | **String** | User&#39;s first and last name separated by a space. | [optional] |
| **given_name** | **String** | User&#39;s first name. | [optional] |
| **family_name** | **String** | User&#39;s last name. | [optional] |
| **updated_at** | **Integer** | Date the user was last updated at (In Unix time). | [optional] |
| **email** | **String** | User&#39;s email address if available. | [optional] |
| **email_verified** | **Boolean** | Whether the user&#39;s email address has been verified. | [optional] |
| **picture** | **String** | URL that point&#39;s to the user&#39;s picture or avatar | [optional] |
| **preferred_username** | **String** | User&#39;s preferred username. | [optional] |
| **id** | **String** | Unique ID of the user in Kinde | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UserProfileV2.new(
  sub: kp_c3143a4b50ad43c88e541d9077681782,
  provided_id: some_external_id,
  name: John Snow,
  given_name: John,
  family_name: Snow,
  updated_at: 1612345678,
  email: john.snow@example.com,
  email_verified: true,
  picture: https://example.com/john_snow.jpg,
  preferred_username: john_snow,
  id: kp_c3143a4b50ad43c88e541d9077681782
)
```

