# KindeFrontendApi::GetEntitlementResponseDataEntitlement

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The friendly ID of an entitlement | [optional] |
| **fixed_charge** | **Integer** | The price charged if this is an entitlement for a fixed charged | [optional] |
| **price_name** | **String** | The name of the price associated with the entitlement | [optional] |
| **unit_amount** | **Integer** | The price charged for this entitlement in cents | [optional] |
| **feature_key** | **String** | The key of the feature corresponding to this entitlement | [optional] |
| **feature_name** | **String** | The name of the feature corresponding to this entitlement | [optional] |
| **entitlement_limit_max** | **Integer** | The maximum number of units of the feature the customer is entitled to | [optional] |
| **entitlement_limit_min** | **Integer** | The minimum number of units of the feature the customer is entitled to | [optional] |

## Example

```ruby
require 'kinde_frontend_api'

instance = KindeFrontendApi::GetEntitlementResponseDataEntitlement.new(
  id: entitlement_0195ac80a14e8d71f42b98e75d3c61ad,
  fixed_charge: null,
  price_name: Seats,
  unit_amount: null,
  feature_key: seats,
  feature_name: Seats,
  entitlement_limit_max: 10,
  entitlement_limit_min: null
)
```

