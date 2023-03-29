# KindeSdk::GetOrganizations200Response

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **organizations** | [**Array&lt;Organization&gt;**](Organization.md) |  | [optional] |
| **next_token** | **String** | Pagination token. | [optional] |

## Example

```ruby
require 'kinde_sdk'

instance = KindeSdk::GetOrganizations200Response.new(
  code: null,
  message: null,
  organizations: null,
  next_token: null
)
```

