# KindeApi::GetUserPropertiesResponseDataPropertiesInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The friendly ID of a property | [optional] |
| **name** | **String** | The name of the property | [optional] |
| **key** | **String** | The key of the property | [optional] |
| **value** | [**StringBooleanInteger**](StringBooleanInteger.md) | The value of the property | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetUserPropertiesResponseDataPropertiesInner.new(
  id: prop_0195ac80a14e8d71f42b98e75d3c61ad,
  name: Company name,
  key: company_name,
  value: Acme Corp
)
```

