# KindeApi::AuthorizeAppApiResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **message** | **String** |  | [optional] |
| **code** | **String** |  | [optional] |
| **applications_disconnected** | **Array&lt;String&gt;** |  | [optional] |
| **applications_connected** | **Array&lt;String&gt;** |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::AuthorizeAppApiResponse.new(
  message: API applications updated,
  code: API_APPLICATIONS_UPDATED,
  applications_disconnected: null,
  applications_connected: null
)
```

