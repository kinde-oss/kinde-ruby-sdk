# KindeApi::GetOrganizationsResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **organizations** | [**Array&lt;OrganizationItemSchema&gt;**](OrganizationItemSchema.md) |  | [optional] |
| **next_token** | **String** | Pagination token. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetOrganizationsResponse.new(
  code: OK,
  message: Success,
  organizations: null,
  next_token: Mjo5Om1hbWVfYZNj
)
```

