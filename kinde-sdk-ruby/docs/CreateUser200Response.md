# KindeSdk::CreateUser200Response

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | Unique id of the user in Kinde | [optional] |
| **created** | **Boolean** | True if the user was successfully created | [optional] |
| **identities** | [**Array&lt;UserIdentity&gt;**](UserIdentity.md) |  | [optional] |

## Example

```ruby
require 'kinde_sdk'

instance = KindeSdk::CreateUser200Response.new(
  id: null,
  created: null,
  identities: null
)
```

