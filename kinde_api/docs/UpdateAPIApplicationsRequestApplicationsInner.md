# KindeApi::UpdateAPIApplicationsRequestApplicationsInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The application&#39;s Client ID. |  |
| **operation** | **String** | Optional operation, set to &#39;delete&#39; to revoke authorization for the application. If not set, the application will be authorized. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateAPIApplicationsRequestApplicationsInner.new(
  id: d2db282d6214242b3b145c123f0c123,
  operation: delete
)
```

