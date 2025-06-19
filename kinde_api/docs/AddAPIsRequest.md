# KindeApi::AddAPIsRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | The name of the API. (1-64 characters). |  |
| **audience** | **String** | A unique identifier for the API - commonly the URL. This value will be used as the &#x60;audience&#x60; parameter in authorization claims. (1-64 characters) |  |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::AddAPIsRequest.new(
  name: Example API,
  audience: https://api.example.com
)
```

