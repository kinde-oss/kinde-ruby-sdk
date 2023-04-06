# KindeApi::GetUsers200Response

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **users** | [**Array&lt;User&gt;**](User.md) |  | [optional] |
| **next_token** | **String** | Pagination token. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetUsers200Response.new(
  code: null,
  message: null,
  users: null,
  next_token: null
)
```

