# KindeApi::ConnectedAppsAuthUrl

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **url** | **String** | A URL that is used to authenticate an end-user against a connected app. | [optional] |
| **session_id** | **String** | A unique identifier for the login session. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::ConnectedAppsAuthUrl.new(
  url: null,
  session_id: null
)
```

