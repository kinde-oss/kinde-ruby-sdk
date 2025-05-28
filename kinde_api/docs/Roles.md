# KindeApi::Roles

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The role&#39;s ID. | [optional] |
| **key** | **String** | The role identifier to use in code. | [optional] |
| **name** | **String** | The role&#39;s name. | [optional] |
| **description** | **String** | The role&#39;s description. | [optional] |
| **is_default_role** | **Boolean** | Whether the role is the default role. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::Roles.new(
  id: null,
  key: null,
  name: null,
  description: null,
  is_default_role: null
)
```

