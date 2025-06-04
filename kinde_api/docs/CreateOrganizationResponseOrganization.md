# KindeApi::CreateOrganizationResponseOrganization

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** | The organization&#39;s unique code. | [optional] |
| **billing_customer_id** | **String** | The billing customer id if the organization was created with the is_create_billing_customer as true | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateOrganizationResponseOrganization.new(
  code: org_1ccfb819462,
  billing_customer_id: customer_1245adbc6789
)
```

