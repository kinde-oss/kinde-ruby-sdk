# KindeApi::TokenIntrospect

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **active** | **Boolean** | Indicates the status of the token. | [optional] |
| **aud** | **Array&lt;String&gt;** | Array of intended token recipients. | [optional] |
| **client_id** | **String** | Identifier for the requesting client. | [optional] |
| **exp** | **String** | Token expiration timestamp. | [optional] |
| **iat** | **String** | Token issuance timestamp. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::TokenIntrospect.new(
  active: null,
  aud: null,
  client_id: null,
  exp: null,
  iat: null
)
```

