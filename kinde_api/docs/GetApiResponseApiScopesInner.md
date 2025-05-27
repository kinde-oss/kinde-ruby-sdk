# KindeApi::GetApiResponseApiScopesInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The ID of the scope. | [optional] |
| **key** | **String** | The reference key for the scope. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetApiResponseApiScopesInner.new(
  id: api_scope_01939222ef24200668b9f5829af001ce,
  key: read:logs
)
```

