# KindeApi::GetCategoriesResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **categories** | [**Array&lt;Category&gt;**](Category.md) |  | [optional] |
| **has_more** | **Boolean** | Whether more records exist. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetCategoriesResponse.new(
  code: null,
  message: null,
  categories: null,
  has_more: null
)
```

