# KindeApi::User

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | Unique id of the user in Kinde. | [optional] |
| **provided_id** | **String** | External id for user. | [optional] |
| **email** | **String** | Default email address of the user in Kinde. | [optional] |
| **last_name** | **String** | User&#39;s last name. | [optional] |
| **first_name** | **String** | User&#39;s first name. | [optional] |
| **full_name** | **String** | User&#39;s full name. | [optional] |
| **is_suspended** | **Boolean** | Whether the user is currently suspended or not. | [optional] |
| **picture** | **String** | User&#39;s profile picture URL. | [optional] |
| **total_sign_ins** | **Integer** | Total number of user sign ins. | [optional] |
| **failed_sign_ins** | **Integer** | Number of consecutive failed user sign ins. | [optional] |
| **last_signed_in** | **String** | Last sign in date in ISO 8601 format. | [optional] |
| **created_on** | **String** | Date of user creation in ISO 8601 format. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::User.new(
  id: null,
  provided_id: null,
  email: null,
  last_name: null,
  first_name: null,
  full_name: null,
  is_suspended: null,
  picture: null,
  total_sign_ins: null,
  failed_sign_ins: null,
  last_signed_in: null,
  created_on: null
)
```

