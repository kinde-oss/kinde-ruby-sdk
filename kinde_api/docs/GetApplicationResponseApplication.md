# KindeApi::GetApplicationResponseApplication

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The application&#39;s identifier. | [optional] |
| **name** | **String** | The application&#39;s name. | [optional] |
| **type** | **String** | The application&#39;s type. | [optional] |
| **client_id** | **String** | The application&#39;s client ID. | [optional] |
| **client_secret** | **String** | The application&#39;s client secret. | [optional] |
| **login_uri** | **String** | The default login route for resolving session issues. | [optional] |
| **homepage_uri** | **String** | The homepage link to your application. | [optional] |
| **has_cancel_button** | **Boolean** | Whether the application has a cancel button to allow users to exit the auth flow [Beta]. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetApplicationResponseApplication.new(
  id: 3b0b5c6c8fcc464fab397f4969b5f482,
  name: My React app,
  type: null,
  client_id: 3b0b5c6c8fcc464fab397f4969b5f482,
  client_secret: sUJSHI3ZQEVTJkx6hOxdOSHaLsZkCBRFLzTNOI791rX8mDjgt7LC,
  login_uri: https://yourapp.com/api/auth/login,
  homepage_uri: https://yourapp.com,
  has_cancel_button: false
)
```

