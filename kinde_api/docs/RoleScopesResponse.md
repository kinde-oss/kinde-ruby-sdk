# KindeApi::RoleScopesResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **scopes** | [**Array&lt;Scopes&gt;**](Scopes.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::RoleScopesResponse.new(
  code: OK,
  message: Success,
  scopes: null
)
```

