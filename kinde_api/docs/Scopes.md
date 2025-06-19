# KindeApi::Scopes

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | Scope ID. | [optional] |
| **key** | **String** | Scope key. | [optional] |
| **description** | **String** | Description of scope. | [optional] |
| **api_id** | **String** | API ID. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::Scopes.new(
  id: api_scope_019541f3fa0c874fc47b3ae73585b21c,
  key: create:users,
  description: Create users,
  api_id: 3635b4431f174de6b789c67481bd0c7a
)
```

