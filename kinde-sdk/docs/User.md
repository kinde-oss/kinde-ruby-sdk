# KindeSdk::User

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | Unique id of the user in Kinde. | [optional] |
| **email** | **String** | Default email address of the user in Kinde. | [optional] |
| **last_name** | **String** | User&#39;s last name. | [optional] |
| **first_name** | **String** | User&#39;s first name. | [optional] |
| **is_suspended** | **Boolean** | Whether the user is currently suspended or not. | [optional] |
| **picture** | **String** | User&#39;s profile picture URL. | [optional] |

## Example

```ruby
require 'kinde_sdk'

instance = KindeSdk::User.new(
  id: null,
  email: null,
  last_name: null,
  first_name: null,
  is_suspended: null,
  picture: null
)
```

