# KindeApi::GetOrganizationResponseBillingAgreementsInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **plan_code** | **String** | The code of the plan from which this agreement is taken from | [optional] |
| **agreement_id** | **String** | The id of the billing agreement in Kinde | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetOrganizationResponseBillingAgreementsInner.new(
  plan_code: pro,
  agreement_id: agreement_a1234b
)
```

