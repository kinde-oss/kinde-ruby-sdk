# KindeApi::UpdateOrganizationRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | The organization&#39;s name. | [optional] |
| **external_id** | **String** | The organization&#39;s ID. | [optional] |
| **background_color** | **String** | The organization&#39;s brand settings - background color. | [optional] |
| **button_color** | **String** | The organization&#39;s brand settings - button color. | [optional] |
| **button_text_color** | **String** | The organization&#39;s brand settings - button text color. | [optional] |
| **link_color** | **String** | The organization&#39;s brand settings - link color. | [optional] |
| **background_color_dark** | **String** | The organization&#39;s brand settings - dark mode background color. | [optional] |
| **button_color_dark** | **String** | The organization&#39;s brand settings - dark mode button color. | [optional] |
| **button_text_color_dark** | **String** | The organization&#39;s brand settings - dark mode button text color. | [optional] |
| **link_color_dark** | **String** | The organization&#39;s brand settings - dark mode link color. | [optional] |
| **theme_code** | **String** | The organization&#39;s brand settings - theme/mode. | [optional] |
| **handle** | **String** | The organization&#39;s handle. | [optional] |
| **is_allow_registrations** | **Boolean** | Deprecated - Use &#39;is_auto_membership_enabled&#39; instead. | [optional] |
| **is_auto_join_domain_list** | **Boolean** | Users can sign up to this organization. | [optional] |
| **allowed_domains** | **Array&lt;String&gt;** | Domains allowed for self-sign up to this environment. | [optional] |
| **is_enable_advanced_orgs** | **Boolean** | Activate advanced organization features. | [optional] |
| **is_enforce_mfa** | **Boolean** | Enforce MFA for all users in this organization. | [optional] |
| **sender_name** | **String** | The name of the organization that will be used in emails | [optional] |
| **sender_email** | **String** | The email address that will be used in emails. Requires custom SMTP to be set up. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateOrganizationRequest.new(
  name: Acme Corp,
  external_id: some1234,
  background_color: #fff,
  button_color: #fff,
  button_text_color: #fff,
  link_color: #fff,
  background_color_dark: #000,
  button_color_dark: #000,
  button_text_color_dark: #000,
  link_color_dark: #000,
  theme_code: light,
  handle: acme_corp,
  is_allow_registrations: null,
  is_auto_join_domain_list: true,
  allowed_domains: [&quot;https://acme.kinde.com&quot;,&quot;https://acme.com&quot;],
  is_enable_advanced_orgs: true,
  is_enforce_mfa: true,
  sender_name: Acme Corp,
  sender_email: hello@acmecorp.com
)
```

