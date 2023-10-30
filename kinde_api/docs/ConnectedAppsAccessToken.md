# KindeApi::ConnectedAppsAccessToken

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **access_token** | **String** | The access token to access a third-party provider. | [optional] |
| **access_token_expiry** | **String** | The date and time that the access token expires. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::ConnectedAppsAccessToken.new(
  access_token: null,
  access_token_expiry: null
)
```

