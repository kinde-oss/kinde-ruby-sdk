# KindeApi::GetApplicationsResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **applications** | [**Array&lt;Applications&gt;**](Applications.md) |  | [optional] |
| **next_token** | **String** | Pagination token. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetApplicationsResponse.new(
  code: null,
  message: null,
  applications: null,
  next_token: null
)
```

