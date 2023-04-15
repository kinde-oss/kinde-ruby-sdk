# KindeApi::GetOrganizationsResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **organizations** | [**Array&lt;Organization&gt;**](Organization.md) |  | [optional] |
| **next_token** | **String** | Pagination token. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetOrganizationsResponse.new(
  code: null,
  message: null,
  organizations: null,
  next_token: null
)
```

