# KindeApi::ReplaceMFARequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **policy** | **String** | Specifies whether MFA is required, optional, or not enforced. |  |
| **enabled_factors** | **Array&lt;String&gt;** | The MFA methods to enable. |  |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::ReplaceMFARequest.new(
  policy: null,
  enabled_factors: null
)
```

