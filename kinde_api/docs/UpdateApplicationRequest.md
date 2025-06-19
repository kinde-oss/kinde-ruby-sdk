# KindeApi::UpdateApplicationRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | The application&#39;s name. | [optional] |
| **language_key** | **String** | The application&#39;s language key. | [optional] |
| **logout_uris** | **Array&lt;String&gt;** | The application&#39;s logout uris. | [optional] |
| **redirect_uris** | **Array&lt;String&gt;** | The application&#39;s redirect uris. | [optional] |
| **login_uri** | **String** | The default login route for resolving session issues. | [optional] |
| **homepage_uri** | **String** | The homepage link to your application. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateApplicationRequest.new(
  name: null,
  language_key: null,
  logout_uris: null,
  redirect_uris: null,
  login_uri: null,
  homepage_uri: null
)
```

