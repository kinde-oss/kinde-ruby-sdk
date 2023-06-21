# KindeApi::GetEnvironmentFeatureFlagsResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | Response code. | [optional] |
| **message** | **String** | Response message. | [optional] |
| **feature_flags** | [**Hash&lt;String, GetOrganizationFeatureFlagsResponseFeatureFlagsValue&gt;**](GetOrganizationFeatureFlagsResponseFeatureFlagsValue.md) | The environment&#39;s feature flag settings. | [optional] |
| **next_token** | **String** | Pagination token. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetEnvironmentFeatureFlagsResponse.new(
  code: null,
  message: null,
  feature_flags: null,
  next_token: null
)
```

