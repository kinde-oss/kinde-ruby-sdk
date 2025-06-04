# KindeApi::ReadLogoResponseLogosInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **type** | **String** | The type of logo (light or dark). | [optional] |
| **file_name** | **String** | The name of the logo file. | [optional] |
| **path** | **String** | The relative path to the logo file. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::ReadLogoResponseLogosInner.new(
  type: light,
  file_name: kinde_light.jpeg,
  path: /logo?p_org_code&#x3D;org_1767f11ce62
)
```

