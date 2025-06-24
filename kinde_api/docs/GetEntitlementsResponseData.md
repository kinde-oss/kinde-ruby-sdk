# KindeApi::GetEntitlementsResponseData

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **org_code** | **String** | The organization code the entitlements are associated with. | [optional] |
| **plans** | [**Array&lt;GetEntitlementsResponseDataPlansInner&gt;**](GetEntitlementsResponseDataPlansInner.md) | A list of plans the user is subscribed to | [optional] |
| **entitlements** | [**Array&lt;GetEntitlementsResponseDataEntitlementsInner&gt;**](GetEntitlementsResponseDataEntitlementsInner.md) | A list of entitlements | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetEntitlementsResponseData.new(
  org_code: org_0195ac80a14e,
  plans: null,
  entitlements: null
)
```

