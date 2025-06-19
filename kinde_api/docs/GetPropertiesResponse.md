# KindeApi::GetPropertiesResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **properties** | [**Array&lt;Property&gt;**](Property.md) |  | [optional] |
| **has_more** | **Boolean** | Whether more records exist. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetPropertiesResponse.new(
  code: null,
  message: null,
  properties: null,
  has_more: null
)
```

