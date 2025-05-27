# KindeApi::GetBillingAgreementsResponseAgreementsInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The friendly id of an agreement | [optional] |
| **plan_code** | **String** | The plan code the billing customer is subscribed to | [optional] |
| **expires_on** | **Time** | The date the agreement expired (and was no longer active) | [optional] |
| **billing_group_id** | **String** | The friendly id of the billing group this agreement&#39;s plan is part of | [optional] |
| **entitlements** | [**Array&lt;GetBillingAgreementsResponseAgreementsInnerEntitlementsInner&gt;**](GetBillingAgreementsResponseAgreementsInnerEntitlementsInner.md) | A list of billing entitlements that is part of this agreement | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetBillingAgreementsResponseAgreementsInner.new(
  id: agreement_0195ac80a14c2ca2cec97d026d864de0,
  plan_code: null,
  expires_on: 2024-11-18T13:32:03+11:00,
  billing_group_id: sbg_0195abf6773fdae18d5da72281a3fde2,
  entitlements: null
)
```

