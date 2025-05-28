# KindeApi::CreateUserRequestIdentitiesInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **type** | **String** | The type of identity to create, e.g. email, username, or phone. | [optional] |
| **is_verified** | **Boolean** | Set whether an email or phone identity is verified or not. | [optional] |
| **details** | [**CreateUserRequestIdentitiesInnerDetails**](CreateUserRequestIdentitiesInnerDetails.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateUserRequestIdentitiesInner.new(
  type: null,
  is_verified: true,
  details: null
)
```

