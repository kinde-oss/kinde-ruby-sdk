# KindeApi::GetApiResponseApiApplicationsInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The Client ID of the application. | [optional] |
| **name** | **String** | The application&#39;s name. | [optional] |
| **type** | **String** | The application&#39;s type. | [optional] |
| **is_active** | **Boolean** | Whether or not the application is authorized to access the API | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetApiResponseApiApplicationsInner.new(
  id: 3b0b5c6c8fcc464fab397f4969b5f482,
  name: My M2M app,
  type: Machine to machine (M2M),
  is_active: true
)
```

