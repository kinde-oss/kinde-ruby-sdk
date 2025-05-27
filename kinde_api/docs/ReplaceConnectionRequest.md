# KindeApi::ReplaceConnectionRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | The internal name of the connection. | [optional] |
| **display_name** | **String** | The public-facing name of the connection. | [optional] |
| **enabled_applications** | **Array&lt;String&gt;** | Client IDs of applications in which this connection is to be enabled. | [optional] |
| **options** | [**ReplaceConnectionRequestOptions**](ReplaceConnectionRequestOptions.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::ReplaceConnectionRequest.new(
  name: ConnectionA,
  display_name: Connection,
  enabled_applications: [&quot;c647dbe20f5944e28af97c9184fded22&quot;,&quot;20bbffaa4c5e492a962273039d4ae18b&quot;],
  options: null
)
```

