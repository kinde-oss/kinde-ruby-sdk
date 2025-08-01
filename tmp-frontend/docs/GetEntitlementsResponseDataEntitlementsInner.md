# KindeFrontendApi::GetEntitlementsResponseDataEntitlementsInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The friendly id of an entitlement | [optional] |
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

instance = KindeFrontendApi::GetEntitlementsResponseDataEntitlementsInner.new(
  id: entitlement_0195ac80a14e8d71f42b98e75d3c61ad,
  fixed_charge: 35,
  price_name: Pro gym,
  unit_amount: null,
  feature_key: base_price,
  feature_name: Pro Gym,
  entitlement_limit_max: null,
  entitlement_limit_min: null
)
```

