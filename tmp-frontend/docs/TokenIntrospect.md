# KindeFrontendApi::TokenIntrospect

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **active** | **Boolean** | Indicates the status of the token. | [optional] |
| **aud** | **Array&lt;String&gt;** | Array of intended token recipients. | [optional] |
| **client_id** | **String** | Identifier for the requesting client. | [optional] |
| **exp** | **Integer** | Token expiration timestamp. | [optional] |
| **iat** | **Integer** | Token issuance timestamp. | [optional] |

## Example

```ruby
require 'kinde_frontend_api'

instance = KindeFrontendApi::TokenIntrospect.new(
  active: null,
  aud: null,
  client_id: 3b0b5c6c8fcc464fab397f4969b5f482,
  exp: 1612345678,
  iat: 1612345678
)
```

