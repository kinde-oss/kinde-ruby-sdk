# KindeApi::UpdateApplicationTokensRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **access_token_lifetime** | **Integer** | The lifetime of an access token in seconds. | [optional] |
| **refresh_token_lifetime** | **Integer** | The lifetime of a refresh token in seconds. | [optional] |
| **id_token_lifetime** | **Integer** | The lifetime of an ID token in seconds. | [optional] |
| **authenticated_session_lifetime** | **Integer** | The lifetime of an authenticated session in seconds. | [optional] |
| **is_hasura_mapping_enabled** | **Boolean** | Enable or disable Hasura mapping. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateApplicationTokensRequest.new(
  access_token_lifetime: 3600,
  refresh_token_lifetime: 86400,
  id_token_lifetime: 3600,
  authenticated_session_lifetime: 86400,
  is_hasura_mapping_enabled: true
)
```

