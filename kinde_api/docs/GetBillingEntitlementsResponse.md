# KindeApi::GetBillingEntitlementsResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **has_more** | **Boolean** | Whether more records exist. | [optional] |
| **entitlements** | [**Array&lt;GetBillingEntitlementsResponseEntitlementsInner&gt;**](GetBillingEntitlementsResponseEntitlementsInner.md) | A list of entitlements | [optional] |
| **plans** | [**Array&lt;GetBillingEntitlementsResponsePlansInner&gt;**](GetBillingEntitlementsResponsePlansInner.md) | A list of plans. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetBillingEntitlementsResponse.new(
  code: OK,
  message: Success,
  has_more: null,
  entitlements: null,
  plans: null
)
```

