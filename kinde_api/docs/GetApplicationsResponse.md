# KindeApi::GetApplicationsResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **organizations** | [**Array&lt;Application&gt;**](Application.md) |  | [optional] |
| **next_token** | **String** | Pagination token. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetApplicationsResponse.new(
  code: null,
  message: null,
  organizations: null,
  next_token: null
)
```

