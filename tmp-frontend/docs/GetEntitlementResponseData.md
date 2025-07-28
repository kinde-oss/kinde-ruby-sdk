# KindeFrontendApi::GetEntitlementResponseData

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization code the entitlements are associated with. | [optional] |
| **entitlement** | [**GetEntitlementResponseDataEntitlement**](GetEntitlementResponseDataEntitlement.md) |  | [optional] |

## Example

```ruby
require 'kinde_frontend_api'

instance = KindeFrontendApi::GetEntitlementResponseData.new(
  org_code: org_0195ac80a14e,
  entitlement: null
)
```

