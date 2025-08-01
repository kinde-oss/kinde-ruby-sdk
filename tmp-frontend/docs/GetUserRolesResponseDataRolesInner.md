# KindeFrontendApi::GetUserRolesResponseDataRolesInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The friendly ID of a role | [optional] |
| **name** | **String** | The name of the role | [optional] |
| **key** | **String** | The key of the role | [optional] |

## Example

```ruby
require 'kinde_frontend_api'

instance = KindeFrontendApi::GetUserRolesResponseDataRolesInner.new(
  id: role_0195ac80a14e8d71f42b98e75d3c61ad,
  name: Admin,
  key: admin
)
```

