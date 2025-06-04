# KindeApi::CreateApiScopesResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **message** | **String** | A Kinde generated message. | [optional] |
| **code** | **String** | A Kinde generated status code. | [optional] |
| **scope** | [**CreateApiScopesResponseScope**](CreateApiScopesResponseScope.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateApiScopesResponse.new(
  message: Success,
  code: OK,
  scope: null
)
```

