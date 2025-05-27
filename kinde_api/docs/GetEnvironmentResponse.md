# KindeApi::GetEnvironmentResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **environment** | [**GetEnvironmentResponseEnvironment**](GetEnvironmentResponseEnvironment.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetEnvironmentResponse.new(
  code: OK,
  message: success_response,
  environment: null
)
```

