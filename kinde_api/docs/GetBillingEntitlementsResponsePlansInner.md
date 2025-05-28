# KindeApi::GetBillingEntitlementsResponsePlansInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | The plan code the billing customer is subscribed to | [optional] |
| **subscribed_on** | **Time** |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetBillingEntitlementsResponsePlansInner.new(
  code: null,
  subscribed_on: 2024-11-18T13:32:03+11:00
)
```

