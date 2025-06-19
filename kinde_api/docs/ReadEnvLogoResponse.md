# KindeApi::ReadEnvLogoResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **logos** | [**Array&lt;ReadEnvLogoResponseLogosInner&gt;**](ReadEnvLogoResponseLogosInner.md) | A list of logos. | [optional] |
| **message** | **String** | Response message. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::ReadEnvLogoResponse.new(
  code: OK,
  logos: null,
  message: Success
)
```

