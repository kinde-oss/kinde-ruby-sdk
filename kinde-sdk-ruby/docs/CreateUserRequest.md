# KindeSdk::CreateUserRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **profile** | [**CreateUserRequestProfile**](CreateUserRequestProfile.md) |  | [optional] |
| **identities** | [**Array&lt;CreateUserRequestIdentitiesInner&gt;**](CreateUserRequestIdentitiesInner.md) |  | [optional] |

## Example

```ruby
require 'kinde_sdk'

instance = KindeSdk::CreateUserRequest.new(
  profile: null,
  identities: null
)
```

