# KindeApi::CreateApisResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **message** | **String** | A Kinde generated message. | [optional] |
| **code** | **String** | A Kinde generated status code. | [optional] |
| **api** | [**CreateApisResponseApi**](CreateApisResponseApi.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateApisResponse.new(
  message: Success,
  code: OK,
  api: null
)
```

