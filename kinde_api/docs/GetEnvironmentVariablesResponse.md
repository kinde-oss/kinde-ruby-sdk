# KindeApi::GetEnvironmentVariablesResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **has_more** | **Boolean** | Whether more records exist. | [optional] |
| **environment_variables** | [**Array&lt;EnvironmentVariable&gt;**](EnvironmentVariable.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetEnvironmentVariablesResponse.new(
  code: OK,
  message: Success,
  has_more: null,
  environment_variables: null
)
```

