# KindeFrontendApi::GetFeatureFlagsResponseDataFeatureFlagsInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The friendly ID of an flag | [optional] |
| **name** | **String** | The name of the flag | [optional] |
| **key** | **String** | The key of the flag | [optional] |
| **type** | **String** | The type of the flag | [optional] |
| **value** | [**GetFeatureFlagsResponseDataFeatureFlagsInnerValue**](GetFeatureFlagsResponseDataFeatureFlagsInnerValue.md) |  | [optional] |

## Example

```ruby
require 'kinde_frontend_api'

instance = KindeFrontendApi::GetFeatureFlagsResponseDataFeatureFlagsInner.new(
  id: flag_0195ac80a14e8d71f42b98e75d3c61ad,
  name: new_feature,
  key: new_feature_key,
  type: boolean,
  value: null
)
```

