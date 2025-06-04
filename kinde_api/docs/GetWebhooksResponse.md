# KindeApi::GetWebhooksResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **webhooks** | [**Array&lt;Webhook&gt;**](Webhook.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetWebhooksResponse.new(
  code: null,
  message: null,
  webhooks: null
)
```

