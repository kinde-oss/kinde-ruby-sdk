# KindeApi::Apis

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | Unique id of the API. | [optional] |
| **name** | **String** | The API&#39;s name. | [optional] |
| **audience** | **String** | The logical identifier for the API. | [optional] |
| **is_management_api** | **Boolean** | Whether it is the management API or not. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::Apis.new(
  id: null,
  name: null,
  audience: null,
  is_management_api: null
)
```

