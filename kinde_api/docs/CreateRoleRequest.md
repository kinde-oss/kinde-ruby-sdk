# KindeApi::CreateRoleRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | The role&#39;s name. | [optional] |
| **description** | **String** | The role&#39;s description. | [optional] |
| **key** | **String** | The role identifier to use in code. | [optional] |
| **is_default_role** | **Boolean** | Set role as default for new users. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateRoleRequest.new(
  name: null,
  description: null,
  key: null,
  is_default_role: null
)
```

