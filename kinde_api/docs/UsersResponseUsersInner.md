# KindeApi::UsersResponseUsersInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | Unique id of the user in Kinde. | [optional] |
| **provided_id** | **String** | External id for user. | [optional] |
| **email** | **String** | Default email address of the user in Kinde. | [optional] |
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

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UsersResponseUsersInner.new(
  id: null,
  provided_id: null,
  email: null,
  last_name: null,
  first_name: null,
  is_suspended: null,
  picture: null,
  total_sign_ins: null,
  failed_sign_ins: null,
  last_signed_in: null,
  created_on: null,
  organizations: null,
  identities: null
)
```

