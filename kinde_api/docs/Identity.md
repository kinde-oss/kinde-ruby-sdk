# KindeApi::Identity

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The unique ID for the identity | [optional] |
| **type** | **String** | The type of identity | [optional] |
| **is_confirmed** | **Boolean** | Whether the identity is confirmed | [optional] |
| **created_on** | **String** | Date of user creation in ISO 8601 format | [optional] |
| **last_login_on** | **String** | Date of last login in ISO 8601 format | [optional] |
| **total_logins** | **Integer** |  | [optional] |
| **name** | **String** | The value of the identity | [optional] |
| **email** | **String** | The associated email of the identity | [optional] |
| **is_primary** | **Boolean** | Whether the identity is the primary identity for the user | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::Identity.new(
  id: identity_019617f0cd72460a42192cf37b41084f,
  type: email,
  is_confirmed: true,
  created_on: 2025-01-01T00:00:00Z,
  last_login_on: 2025-01-05T00:00:00Z,
  total_logins: 20,
  name: sally@example.com,
  email: sally@example.com,
  is_primary: true
)
```

