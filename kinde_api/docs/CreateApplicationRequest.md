# KindeApi::CreateApplicationRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | The application&#39;s name. |  |
| **type** | **String** | The application&#39;s type. Use &#x60;reg&#x60; for regular server rendered applications, &#x60;spa&#x60; for single-page applications, and &#x60;m2m&#x60; for machine-to-machine applications. |  |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateApplicationRequest.new(
  name: React Native app,
  type: null
)
```

