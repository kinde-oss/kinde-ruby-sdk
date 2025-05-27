# KindeApi::AddAPIScopeRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **key** | **String** | The key reference for the scope (1-64 characters, no white space). |  |
| **description** | **String** | Description of the api scope purpose. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::AddAPIScopeRequest.new(
  key: read:logs,
  description: Scope for reading logs.
)
```

