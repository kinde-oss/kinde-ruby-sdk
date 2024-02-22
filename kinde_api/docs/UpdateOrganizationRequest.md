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
| **theme_code** | **String** | The organization&#39;s brand settings - theme/mode &#39;light&#39; | &#39;dark&#39; | &#39;user_preference&#39;. | [optional] |
| **handle** | **String** | The organization&#39;s handle. | [optional] |
| **is_allow_registrations** | **Boolean** | Users can sign up to this organization. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateOrganizationRequest.new(
  name: null,
  external_id: null,
  background_color: null,
  button_color: null,
  button_text_color: null,
  link_color: null,
  background_color_dark: null,
  button_color_dark: null,
  button_text_color_dark: null,
  link_color_dark: null,
  theme_code: null,
  handle: null,
  is_allow_registrations: null
)
```

