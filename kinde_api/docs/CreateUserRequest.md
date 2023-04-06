# KindeApi::CreateUserRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **profile** | [**CreateUserRequestProfile**](CreateUserRequestProfile.md) |  | [optional] |
| **identities** | [**Array&lt;CreateUserRequestIdentitiesInner&gt;**](CreateUserRequestIdentitiesInner.md) | Array of identities to assign to the created user | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateUserRequest.new(
  profile: null,
  identities: null
)
```

