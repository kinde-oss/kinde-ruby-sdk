# KindeApi::CreateUserRequestIdentitiesInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **type** | **String** | The type of identity to create, for e.g. email. | [optional] |
| **details** | [**CreateUserRequestIdentitiesInnerDetails**](CreateUserRequestIdentitiesInnerDetails.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateUserRequestIdentitiesInner.new(
  type: null,
  details: null
)
```

