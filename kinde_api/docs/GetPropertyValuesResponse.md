# KindeApi::GetPropertyValuesResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **properties** | [**Array&lt;PropertyValue&gt;**](PropertyValue.md) |  | [optional] |
| **next_token** | **String** | Pagination token. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetPropertyValuesResponse.new(
  code: null,
  message: null,
  properties: null,
  next_token: null
)
```

