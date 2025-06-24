# KindeApi::GetEntitlementsResponseDataPlansInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **key** | **String** | A unique code for the plan | [optional] |
| **subscribed_on** | **Time** | The date the user subscribed to the plan | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetEntitlementsResponseDataPlansInner.new(
  key: pro_plan,
  subscribed_on: 2025-06-01T12:00Z
)
```

