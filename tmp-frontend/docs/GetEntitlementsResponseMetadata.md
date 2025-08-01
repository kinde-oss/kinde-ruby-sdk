# KindeFrontendApi::GetEntitlementsResponseMetadata

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **has_more** | **Boolean** | Whether more records exist. | [optional] |
| **next_page_starting_after** | **String** | The ID of the last record on the current page. | [optional] |

## Example

```ruby
require 'kinde_frontend_api'

instance = KindeFrontendApi::GetEntitlementsResponseMetadata.new(
  has_more: false,
  next_page_starting_after: entitlement_0195ac80a14e8d71f42b98e75d3c61ad
)
```

