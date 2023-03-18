# KindeSdk::CreateOrganizationRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | The organization&#39;s name. | [optional] |
| **feature_flags** | **Hash&lt;String, String&gt;** | The organization&#39;s feature flag settings. | [optional] |

## Example

```ruby
require 'kinde_sdk'

instance = KindeSdk::CreateOrganizationRequest.new(
  name: null,
  feature_flags: null
)
```

