# KindeApi::CreateBillingAgreementRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **customer_id** | **String** | The ID of the billing customer to create a new agreement for |  |
| **plan_code** | **String** | The code of the billing plan the new agreement will be based on |  |
| **is_invoice_now** | **Boolean** | Generate a final invoice for any un-invoiced metered usage. | [optional] |
| **is_prorate** | **Boolean** | Generate a proration invoice item that credits remaining unused features. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateBillingAgreementRequest.new(
  customer_id: customer_0195ac80a14c2ca2cec97d026d864de0,
  plan_code: pro,
  is_invoice_now: true,
  is_prorate: true
)
```

