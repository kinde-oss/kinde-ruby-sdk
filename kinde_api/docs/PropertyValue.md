# KindeApi::PropertyValue

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** |  | [optional] |
| **name** | **String** |  | [optional] |
| **description** | **String** |  | [optional] |
| **key** | **String** |  | [optional] |
| **value** | **String** |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::PropertyValue.new(
  id: prop_0192b7e8b4f8ca08110d2b22059662a8,
  name: Town,
  description: Where the entity is located,
  key: kp_town,
  value: West-side Staines massive
)
```

