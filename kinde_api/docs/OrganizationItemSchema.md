# KindeApi::OrganizationItemSchema

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | The unique identifier for the organization. | [optional] |
| **name** | **String** | The organization&#39;s name. | [optional] |
| **handle** | **String** | A unique handle for the organization - can be used for dynamic callback urls. | [optional] |
| **is_default** | **Boolean** | Whether the organization is the default organization. | [optional] |
| **external_id** | **String** | The organization&#39;s external identifier - commonly used when migrating from or mapping to other systems. | [optional] |
| **is_auto_membership_enabled** | **Boolean** | If users become members of this organization when the org code is supplied during authentication. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::OrganizationItemSchema.new(
  code: org_1ccfb819462,
  name: Acme Corp,
  handle: acme_corp,
  is_default: false,
  external_id: some1234,
  is_auto_membership_enabled: true
)
```

