# KindeApi::LogoutRedirectUrls

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **logout_urls** | **Array&lt;String&gt;** | An application&#39;s logout URLs. | [optional] |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::LogoutRedirectUrls.new(
  logout_urls: null,
  code: OK,
  message: Success
)
```

