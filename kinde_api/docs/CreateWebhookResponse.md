# KindeApi::CreateWebhookResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **webhook** | [**CreateWebhookResponseWebhook**](CreateWebhookResponseWebhook.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateWebhookResponse.new(
  code: null,
  message: null,
  webhook: null
)
```

