# KindeApi::GetUserMfaResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **message** | **String** |  | [optional] |
| **code** | **String** |  | [optional] |
| **mfa** | [**GetUserMfaResponseMfa**](GetUserMfaResponseMfa.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetUserMfaResponse.new(
  message: null,
  code: null,
  mfa: null
)
```

