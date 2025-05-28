# KindeApi::CreateConnectionRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **name** | **String** | The internal name of the connection. | [optional] |
| **display_name** | **String** | The public facing name of the connection. | [optional] |
| **strategy** | **String** | The identity provider identifier for the connection. | [optional] |
| **enabled_applications** | **Array&lt;String&gt;** | Client IDs of applications in which this connection is to be enabled. | [optional] |
| **organization_code** | **String** | Enterprise connections only - the code for organization that manages this connection. | [optional] |
| **options** | [**CreateConnectionRequestOptions**](CreateConnectionRequestOptions.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateConnectionRequest.new(
  name: null,
  display_name: null,
  strategy: null,
  enabled_applications: null,
  organization_code: org_80581732fbe,
  options: null
)
```

