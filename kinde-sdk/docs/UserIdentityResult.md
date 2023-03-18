# KindeSdk::UserIdentityResult

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **created** | **Boolean** | True if the user identity was successfully created. | [optional] |
| **identity_id** | **Integer** | Unique id of the user&#39;s identity in Kinde. | [optional] |

## Example

```ruby
require 'kinde_sdk'

instance = KindeSdk::UserIdentityResult.new(
  created: null,
  identity_id: null
)
```

