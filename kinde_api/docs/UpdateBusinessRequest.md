# KindeApi::UpdateBusinessRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **business_name** | **String** | The name of the business. | [optional] |
| **email** | **String** | The email address of the business. | [optional] |
| **industry_key** | **String** | The key of the industry of your business. Can be retrieved from the /industries endpoint. | [optional] |
| **is_click_wrap** | **Boolean** | Whether the business is using clickwrap agreements. | [optional] |
| **is_show_kinde_branding** | **Boolean** | Whether the business is showing Kinde branding. Requires a paid plan. | [optional] |
| **kinde_perk_code** | **String** | The Kinde perk code for the business. | [optional] |
| **phone** | **String** | The phone number of the business. | [optional] |
| **privacy_url** | **String** | The URL to the business&#39;s privacy policy. | [optional] |
| **terms_url** | **String** | The URL to the business&#39;s terms of service. | [optional] |
| **timezone_key** | **String** | The key of the timezone of your business. Can be retrieved from the /timezones endpoint. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateBusinessRequest.new(
  business_name: Tailsforce Ltd,
  email: sally@example.com,
  industry_key: construction,
  is_click_wrap: false,
  is_show_kinde_branding: true,
  kinde_perk_code: null,
  phone: 123-456-7890,
  privacy_url: https://example.com/privacy,
  terms_url: https://example.com/terms,
  timezone_key: los_angeles_pacific_standard_time
)
```

