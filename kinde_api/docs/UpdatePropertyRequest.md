# KindeApi::UpdatePropertyRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | The name of the property. |  |
| **description** | **String** | Description of the property purpose. | [optional] |
| **is_private** | **Boolean** | Whether the property can be included in id and access tokens. |  |
| **category_id** | **String** | Which category the property belongs to. |  |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdatePropertyRequest.new(
  name: null,
  description: null,
  is_private: null,
  category_id: null
)
```

