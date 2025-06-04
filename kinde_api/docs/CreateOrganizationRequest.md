# KindeApi::CreateOrganizationRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | The organization&#39;s name. |  |
| **feature_flags** | **Hash&lt;String, String&gt;** | The organization&#39;s feature flag settings. | [optional] |
| **external_id** | **String** | The organization&#39;s external identifier - commonly used when migrating from or mapping to other systems. | [optional] |
| **background_color** | **String** | The organization&#39;s brand settings - background color. | [optional] |
| **button_color** | **String** | The organization&#39;s brand settings - button color. | [optional] |
| **button_text_color** | **String** | The organization&#39;s brand settings - button text color. | [optional] |
| **link_color** | **String** | The organization&#39;s brand settings - link color. | [optional] |
| **background_color_dark** | **String** | The organization&#39;s brand settings - dark mode background color. | [optional] |
| **button_color_dark** | **String** | The organization&#39;s brand settings - dark mode button color. | [optional] |
| **button_text_color_dark** | **String** | The organization&#39;s brand settings - dark mode button text color. | [optional] |
| **link_color_dark** | **String** | The organization&#39;s brand settings - dark mode link color. | [optional] |
| **theme_code** | **String** | The organization&#39;s brand settings - theme/mode &#39;light&#39; | &#39;dark&#39; | &#39;user_preference&#39;. | [optional] |
| **handle** | **String** | A unique handle for the organization - can be used for dynamic callback urls. | [optional] |
| **is_allow_registrations** | **Boolean** | If users become members of this organization when the org code is supplied during authentication. | [optional] |
| **sender_name** | **String** | The name of the organization that will be used in emails | [optional] |
| **sender_email** | **String** | The email address that will be used in emails. Requires custom SMTP to be set up. | [optional] |
| **is_create_billing_customer** | **Boolean** | If a billing customer is also created for this organization | [optional] |
| **billing_email** | **String** | The email address used for billing purposes for the organization | [optional] |
| **billing_plan_code** | **String** | The billing plan to put the customer on. If not specified, the default plan is used | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateOrganizationRequest.new(
  name: Acme Corp,
  feature_flags: null,
  external_id: some1234,
  background_color: null,
  button_color: null,
  button_text_color: null,
  link_color: null,
  background_color_dark: null,
  button_color_dark: null,
  button_text_color_dark: null,
  link_color_dark: null,
  theme_code: null,
  handle: acme_corp,
  is_allow_registrations: true,
  sender_name: Acme Corp,
  sender_email: hello@acmecorp.com,
  is_create_billing_customer: false,
  billing_email: billing@acmecorp.com,
  billing_plan_code: pro
)
```

