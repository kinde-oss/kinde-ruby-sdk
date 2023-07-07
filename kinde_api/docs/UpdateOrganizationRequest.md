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

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateOrganizationRequest.new(
  name: null,
  external_id: null,
  background_color: null,
  button_color: null,
  button_text_color: null,
  link_color: null
)
```

