# KindeApi::GetIdentitiesResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **identities** | [**Array&lt;Identity&gt;**](Identity.md) |  | [optional] |
| **has_more** | **Boolean** | Whether more records exist. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetIdentitiesResponse.new(
  code: null,
  message: null,
  identities: null,
  has_more: null
)
```

