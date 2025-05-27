# KindeApi::GetApiScopeResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **scope** | [**GetApiScopesResponseScopesInner**](GetApiScopesResponseScopesInner.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetApiScopeResponse.new(
  code: OK,
  message: success_response,
  scope: null
)
```

