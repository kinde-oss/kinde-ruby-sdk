# KindeApi::CreateOrganizationRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | The organization&#39;s name. | [optional] |
| **feature_flags** | **Hash&lt;String, String&gt;** | The organization&#39;s feature flag settings. | [optional] |
| **external_id** | **String** | The organization&#39;s ID. | [optional] |
| **background_color** | **String** | The organization&#39;s brand settings - background color. | [optional] |
| **button_color** | **String** | The organization&#39;s brand settings - button color. | [optional] |
| **button_text_color** | **String** | The organization&#39;s brand settings - button text color. | [optional] |
| **link_color** | **String** | The organization&#39;s brand settings - link color. | [optional] |
| **handle** | **String** | The organization&#39;s handle. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateOrganizationRequest.new(
  name: null,
  feature_flags: null,
  external_id: null,
  background_color: null,
  button_color: null,
  button_text_color: null,
  link_color: null,
  handle: null
)
```

