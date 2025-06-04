# KindeApi::GetApiScopesResponseScopesInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | Unique ID of the API scope. | [optional] |
| **key** | **String** | The scope&#39;s reference key. | [optional] |
| **description** | **String** | Explanation of the scope purpose. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetApiScopesResponseScopesInner.new(
  id: api_scope_01939128c3d7193ae87c4755213c07c6,
  key: read:logs,
  description: Read logs scope
)
```

