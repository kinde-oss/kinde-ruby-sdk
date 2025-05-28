# KindeApi::SearchUsersResponseResultsInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | Unique ID of the user in Kinde. | [optional] |
| **provided_id** | **String** | External ID for user. | [optional] |
| **email** | **String** | Default email address of the user in Kinde. | [optional] |
| **username** | **String** | Primary username of the user in Kinde. | [optional] |
| **last_name** | **String** | User&#39;s last name. | [optional] |
| **first_name** | **String** | User&#39;s first name. | [optional] |
| **is_suspended** | **Boolean** | Whether the user is currently suspended or not. | [optional] |
| **picture** | **String** | User&#39;s profile picture URL. | [optional] |
| **total_sign_ins** | **Integer** | Total number of user sign ins. | [optional] |
| **failed_sign_ins** | **Integer** | Number of consecutive failed user sign ins. | [optional] |
| **last_signed_in** | **String** | Last sign in date in ISO 8601 format. | [optional] |
| **created_on** | **String** | Date of user creation in ISO 8601 format. | [optional] |
| **organizations** | **Array&lt;String&gt;** | Array of organizations a user belongs to. | [optional] |
| **identities** | [**Array&lt;UserIdentitiesInner&gt;**](UserIdentitiesInner.md) | Array of identities belonging to the user. | [optional] |
| **properties** | **Hash&lt;String, String&gt;** | The user properties. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::SearchUsersResponseResultsInner.new(
  id: kp_0ba7c433e5d648cf992621ce99d42817,
  provided_id: U123456,
  email: user@domain.com,
  username: john.snow,
  last_name: Snow,
  first_name: John,
  is_suspended: true,
  picture: https://example.com/john_snow.jpg,
  total_sign_ins: 1,
  failed_sign_ins: 0,
  last_signed_in: 2025-02-12T18:02:23.614638+00:00,
  created_on: 2025-02-12T18:02:23.614638+00:00,
  organizations: null,
  identities: null,
  properties: null
)
```

