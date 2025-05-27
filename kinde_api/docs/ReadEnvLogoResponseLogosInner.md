# KindeApi::ReadEnvLogoResponseLogosInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **type** | **String** | The type of logo (light or dark). | [optional] |
| **file_name** | **String** | The name of the logo file. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::ReadEnvLogoResponseLogosInner.new(
  type: light,
  file_name: kinde_light.jpeg
)
```

