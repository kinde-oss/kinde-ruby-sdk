# KindeApi::CreatePropertyRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | The name of the property. |  |
| **description** | **String** | Description of the property purpose. | [optional] |
| **key** | **String** | The property identifier to use in code. |  |
| **type** | **String** | The property type. |  |
| **context** | **String** | The context that the property applies to. |  |
| **is_private** | **Boolean** | Whether the property can be included in id and access tokens. |  |
| **category_id** | **String** | Which category the property belongs to. |  |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreatePropertyRequest.new(
  name: null,
  description: null,
  key: null,
  type: null,
  context: null,
  is_private: null,
  category_id: null
)
```

