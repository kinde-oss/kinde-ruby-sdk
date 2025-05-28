# KindeApi::GetApiScopesResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **scopes** | [**Array&lt;GetApiScopesResponseScopesInner&gt;**](GetApiScopesResponseScopesInner.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetApiScopesResponse.new(
  code: OK,
  message: success_response,
  scopes: null
)
```

