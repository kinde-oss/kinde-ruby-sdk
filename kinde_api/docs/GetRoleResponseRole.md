# KindeApi::GetRoleResponseRole

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

instance = KindeApi::GetRoleResponseRole.new(
  id: 01929904-316d-bb2c-069f-99dfea4ac394,
  key: admin,
  name: Administrator,
  description: Full access to all resources.,
  is_default_role: false
)
```

