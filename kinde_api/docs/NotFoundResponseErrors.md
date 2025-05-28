# KindeApi::NotFoundResponseErrors

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **code** | **String** |  | [optional] |
| **message** | **String** |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::NotFoundResponseErrors.new(
  code: ROUTE_NOT_FOUND,
  message: The requested API route does not exist
)
```

