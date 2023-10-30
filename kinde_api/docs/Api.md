# KindeApi::Api

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The API&#39;s unique identifier. | [optional] |
| **code** | **String** | Response code. | [optional] |
| **name** | **String** | The API&#39;s name. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **audience** | **String** | The API&#39;s audience. | [optional] |
| **applications** | [**Array&lt;ApiApplicationsInner&gt;**](ApiApplicationsInner.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::Api.new(
  id: null,
  code: null,
  name: null,
  message: null,
  audience: null,
  applications: null
)
```

