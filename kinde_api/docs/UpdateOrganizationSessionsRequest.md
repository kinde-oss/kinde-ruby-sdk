# KindeApi::UpdateOrganizationSessionsRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **is_use_org_sso_session_policy** | **Boolean** | Whether to use the organization&#39;s SSO session policy override. | [optional] |
| **sso_session_persistence_mode** | **String** | Determines if the session should be persistent or not. | [optional] |
| **is_use_org_authenticated_session_lifetime** | **Boolean** | Whether to apply the organization&#39;s authenticated session lifetime override. | [optional] |
| **authenticated_session_lifetime** | **Integer** | Authenticated session lifetime in seconds. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::UpdateOrganizationSessionsRequest.new(
  is_use_org_sso_session_policy: null,
  sso_session_persistence_mode: null,
  is_use_org_authenticated_session_lifetime: null,
  authenticated_session_lifetime: 86400
)
```

