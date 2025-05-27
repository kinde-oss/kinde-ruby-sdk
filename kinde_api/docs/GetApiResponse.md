# KindeApi::GetApiResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **api** | [**GetApiResponseApi**](GetApiResponseApi.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetApiResponse.new(
  code: OK,
  message: success_response,
  api: null
)
```

