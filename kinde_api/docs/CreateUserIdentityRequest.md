# KindeApi::CreateUserIdentityRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **value** | **String** | The email address, social identity, or username of the user. | [optional] |
| **type** | **String** | The identity type | [optional] |
| **phone_country_id** | **String** | The country code for the phone number, only required when identity type is &#39;phone&#39;. | [optional] |
| **connection_id** | **String** | The social or enterprise connection ID, only required when identity type is &#39;social&#39; or &#39;enterprise&#39;. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateUserIdentityRequest.new(
  value: sally@example.com,
  type: email,
  phone_country_id: au,
  connection_id: conn_019289347f1193da6c0e4d49b97b4bd2
)
```

