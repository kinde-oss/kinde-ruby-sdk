# KindeApi::UsersResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **users** | [**Array&lt;UsersResponseUsersInner&gt;**](UsersResponseUsersInner.md) |  | [optional] |
| **next_token** | **String** | Pagination token. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UsersResponse.new(
  code: null,
  message: null,
  users: null,
  next_token: null
)
```

