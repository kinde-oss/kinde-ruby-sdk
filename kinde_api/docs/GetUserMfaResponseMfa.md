# KindeApi::GetUserMfaResponseMfa

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The MFA&#39;s identifier. | [optional] |
| **type** | **String** | The type of MFA (e.g. email, SMS, authenticator app). | [optional] |
| **created_on** | **Time** | The timestamp when the MFA was created. | [optional] |
| **name** | **String** | The identifier used for MFA (e.g. email address, phone number). | [optional] |
| **is_verified** | **Boolean** | Whether the MFA is verified or not. | [optional] |
| **usage_count** | **Integer** | The number of times MFA has been used. | [optional] |
| **last_used_on** | **Time** | The timestamp when the MFA was last used. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetUserMfaResponseMfa.new(
  id: mfa_01933d1ca1f093e7fad48ebcdb65a871,
  type: email,
  created_on: 2024-11-18T13:31:46.795085+11:00,
  name: sally@gmail.com,
  is_verified: true,
  usage_count: 2,
  last_used_on: 2024-11-18T13:32:07.225380+11:00
)
```

