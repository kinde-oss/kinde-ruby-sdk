# KindeApi::UserProfileV2

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | Unique id of the user in Kinde (deprecated). | [optional] |
| **sub** | **String** | Unique id of the user in Kinde. | [optional] |
| **provided_id** | **String** | Value of the user&#39;s id in a third-party system when the user is imported into Kinde. | [optional] |
| **name** | **String** | Users&#39;s first and last name separated by a space. | [optional] |
| **given_name** | **String** | User&#39;s first name. | [optional] |
| **family_name** | **String** | User&#39;s last name. | [optional] |
| **updated_at** | **Integer** | Date the user was last updated at (In Unix time). | [optional] |
| **email** | **String** | User&#39;s email address if available. | [optional] |
| **picture** | **String** | URL that point&#39;s to the user&#39;s picture or avatar | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UserProfileV2.new(
  id: null,
  sub: null,
  provided_id: null,
  name: null,
  given_name: null,
  family_name: null,
  updated_at: null,
  email: null,
  picture: null
)
```

