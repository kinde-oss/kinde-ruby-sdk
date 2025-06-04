# KindeApi::GetBillingAgreementsResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **has_more** | **Boolean** | Whether more records exist. | [optional] |
| **agreements** | [**Array&lt;GetBillingAgreementsResponseAgreementsInner&gt;**](GetBillingAgreementsResponseAgreementsInner.md) | A list of billing agreements | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetBillingAgreementsResponse.new(
  code: OK,
  message: Success,
  has_more: null,
  agreements: null
)
```

