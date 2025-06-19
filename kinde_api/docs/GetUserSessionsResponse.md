# KindeApi::GetUserSessionsResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** |  | [optional] |
| **message** | **String** |  | [optional] |
| **has_more** | **Boolean** |  | [optional] |
| **sessions** | [**Array&lt;GetUserSessionsResponseSessionsInner&gt;**](GetUserSessionsResponseSessionsInner.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetUserSessionsResponse.new(
  code: OK,
  message: Success,
  has_more: false,
  sessions: null
)
```

