# KindeApi::CreateUserRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **profile** | [**CreateUserRequestProfile**](CreateUserRequestProfile.md) |  | [optional] |
| **organization_code** | **String** | The unique code associated with the organization you want the user to join. | [optional] |
| **provided_id** | **String** | An external id to reference the user. | [optional] |
| **identities** | [**Array&lt;CreateUserRequestIdentitiesInner&gt;**](CreateUserRequestIdentitiesInner.md) | Array of identities to assign to the created user | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateUserRequest.new(
  profile: null,
  organization_code: null,
  provided_id: null,
  identities: [{&quot;type&quot;:&quot;email&quot;,&quot;is_verified&quot;:true,&quot;details&quot;:{&quot;email&quot;:&quot;email@email.com&quot;}},{&quot;type&quot;:&quot;phone&quot;,&quot;is_verified&quot;:false,&quot;details&quot;:{&quot;phone&quot;:&quot;+61426148233&quot;,&quot;phone_country_id&quot;:&quot;au&quot;}},{&quot;type&quot;:&quot;username&quot;,&quot;details&quot;:{&quot;username&quot;:&quot;myusername&quot;}}]
)
```

