# KindeApi::CreateConnectionRequestOptionsOneOf

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **client_id** | **String** | OAuth client ID. | [optional] |
| **client_secret** | **String** | OAuth client secret. | [optional] |
| **is_use_custom_domain** | **Boolean** | Use custom domain callback URL. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateConnectionRequestOptionsOneOf.new(
  client_id: hji7db2146af332akfldfded22,
  client_secret: 19fkjdalg521l23fassf3039d4ae18b,
  is_use_custom_domain: true
)
```

