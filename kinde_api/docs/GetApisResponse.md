# KindeApi::GetApisResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **next_token** | **String** | Pagination token. | [optional] |
| **apis** | [**Array&lt;GetApisResponseApisInner&gt;**](GetApisResponseApisInner.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetApisResponse.new(
  code: OK,
  message: Success,
  next_token: Njo5Om1hvWVfYXNj,
  apis: null
)
```

