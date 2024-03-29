# KindeApi::UserProfile

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | Unique id of the user in Kinde. | [optional] |
| **preferred_email** | **String** | Default email address of the user in Kinde. | [optional] |
| **provided_id** | **String** | Value of the user&#39;s id in a third-party system when the user is imported into Kinde. | [optional] |
| **last_name** | **String** | User&#39;s last name. | [optional] |
| **first_name** | **String** | User&#39;s first name. | [optional] |
| **picture** | **String** | URL that point&#39;s to the user&#39;s picture or avatar | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UserProfile.new(
  id: null,
  preferred_email: null,
  provided_id: null,
  last_name: null,
  first_name: null,
  picture: null
)
```

