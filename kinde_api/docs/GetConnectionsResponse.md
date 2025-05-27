# KindeApi::GetConnectionsResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **connections** | [**Array&lt;Connection&gt;**](Connection.md) |  | [optional] |
| **has_more** | **Boolean** | Whether more records exist. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetConnectionsResponse.new(
  code: null,
  message: null,
  connections: null,
  has_more: null
)
```

