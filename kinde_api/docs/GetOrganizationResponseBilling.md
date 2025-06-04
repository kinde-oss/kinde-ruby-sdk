# KindeApi::GetOrganizationResponseBilling

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **billing_customer_id** | **String** |  | [optional] |
| **agreements** | [**Array&lt;GetOrganizationResponseBillingAgreementsInner&gt;**](GetOrganizationResponseBillingAgreementsInner.md) | The billing agreements the billing customer is currently subscribed to | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetOrganizationResponseBilling.new(
  billing_customer_id: null,
  agreements: null
)
```

