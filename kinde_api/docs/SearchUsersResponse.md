# KindeApi::SearchUsersResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **results** | [**Array&lt;SearchUsersResponseResultsInner&gt;**](SearchUsersResponseResultsInner.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::SearchUsersResponse.new(
  code: null,
  message: null,
  results: null
)
```

