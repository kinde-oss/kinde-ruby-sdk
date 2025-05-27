# KindeApi::ReplaceConnectionRequestOptionsOneOf

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **client_id** | **String** | Client ID. | [optional] |
| **client_secret** | **String** | Client secret. | [optional] |
| **home_realm_domains** | **Array&lt;String&gt;** | List of domains to limit authentication. | [optional] |
| **entra_id_domain** | **String** | Domain for Entra ID. | [optional] |
| **is_use_common_endpoint** | **Boolean** | Use https://login.windows.net/common instead of a default endpoint. | [optional] |
| **is_sync_user_profile_on_login** | **Boolean** | Sync user profile data with IDP. | [optional] |
| **is_retrieve_provider_user_groups** | **Boolean** | Include user group info from MS Entra ID. | [optional] |
| **is_extended_attributes_required** | **Boolean** | Include additional user profile information. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::ReplaceConnectionRequestOptionsOneOf.new(
  client_id: hji7db2146af332akfldfded22,
  client_secret: 19fkjdalg521l23fassf3039d4ae18b,
  home_realm_domains: [&quot;@kinde.com&quot;,&quot;@kinde.io&quot;],
  entra_id_domain: kinde.com,
  is_use_common_endpoint: true,
  is_sync_user_profile_on_login: true,
  is_retrieve_provider_user_groups: true,
  is_extended_attributes_required: true
)
```

