# KindeApi::ReadLogoResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **logos** | [**Array&lt;ReadLogoResponseLogosInner&gt;**](ReadLogoResponseLogosInner.md) | A list of logos. | [optional] |
| **message** | **String** | Response message. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::ReadLogoResponse.new(
  code: OK,
  logos: null,
  message: Success
)
```

