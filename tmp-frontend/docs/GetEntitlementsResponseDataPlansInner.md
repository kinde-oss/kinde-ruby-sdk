# KindeFrontendApi::GetEntitlementsResponseDataPlansInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **key** | **String** | A unique code for the plan | [optional] |
| **name** | **String** | Name of the plan | [optional] |
| **subscribed_on** | **Time** | The date the user subscribed to the plan | [optional] |

## Example

```ruby
require 'kinde_frontend_api'

instance = KindeFrontendApi::GetEntitlementsResponseDataPlansInner.new(
  key: pro_plan,
  name: Pro,
  subscribed_on: 2025-06-01T12:00Z
)
```

