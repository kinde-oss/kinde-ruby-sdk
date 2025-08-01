# KindeFrontendApi::GetUserPermissionsResponseDataPermissionsInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The friendly ID of a permission | [optional] |
| **name** | **String** | The name of the permission | [optional] |
| **key** | **String** | The key of the permission | [optional] |

## Example

```ruby
require 'kinde_frontend_api'

instance = KindeFrontendApi::GetUserPermissionsResponseDataPermissionsInner.new(
  id: perm_0195ac80a14e8d71f42b98e75d3c61ad,
  name: View reports,
  key: view_reports
)
```

