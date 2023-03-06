# KindeSdk::CreateUserRequestIdentitiesInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **type** | **String** | The type of identity to create, for e.g. email | [optional] |
| **details** | [**CreateUserRequestIdentitiesInnerDetails**](CreateUserRequestIdentitiesInnerDetails.md) |  | [optional] |

## Example

```ruby
require 'kinde_sdk'

instance = KindeSdk::CreateUserRequestIdentitiesInner.new(
  type: null,
  details: null
)
```

