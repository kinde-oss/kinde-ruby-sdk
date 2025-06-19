# KindeApi::GetBusinessResponseBusiness

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | The unique ID for the business. | [optional] |
| **name** | **String** | Your business&#39;s name. | [optional] |
| **phone** | **String** | Phone number associated with business. | [optional] |
| **email** | **String** | Email address associated with business. | [optional] |
| **industry** | **String** | The industry your business is in. | [optional] |
| **timezone** | **String** | The timezone your business is in. | [optional] |
| **privacy_url** | **String** | Your Privacy policy URL. | [optional] |
| **terms_url** | **String** | Your Terms and Conditions URL. | [optional] |
| **has_clickwrap** | **Boolean** | Whether your business uses clickwrap agreements. | [optional] |
| **has_kinde_branding** | **Boolean** | Whether your business shows Kinde branding. | [optional] |
| **created_on** | **String** | Date of business creation in ISO 8601 format. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetBusinessResponseBusiness.new(
  code: bus_c69fb73b091,
  name: Tailsforce Ltd,
  phone: 555-555-5555,
  email: sally@example.com,
  industry: Healthcare &amp; Medical,
  timezone: Los Angeles (Pacific Standard Time),
  privacy_url: https://example.com/privacy,
  terms_url: https://example.com/terms,
  has_clickwrap: false,
  has_kinde_branding: true,
  created_on: 2021-01-01T00:00:00Z
)
```

