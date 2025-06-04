# KindeApi::CreateOrganizationResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **message** | **String** | Response message. | [optional] |
| **code** | **String** | Response code. | [optional] |
| **organization** | [**CreateOrganizationResponseOrganization**](CreateOrganizationResponseOrganization.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateOrganizationResponse.new(
  message: Success,
  code: OK,
  organization: null
)
```

