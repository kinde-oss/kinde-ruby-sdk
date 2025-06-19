# KindeApi::GetApisResponseApisInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The unique ID for the API. | [optional] |
| **name** | **String** | The API’s name. | [optional] |
| **audience** | **String** | A unique identifier for the API - commonly the URL. This value will be used as the &#x60;audience&#x60; parameter in authorization claims. | [optional] |
| **is_management_api** | **Boolean** | Whether or not it is the Kinde management API. | [optional] |
| **scopes** | [**Array&lt;GetApisResponseApisInnerScopesInner&gt;**](GetApisResponseApisInnerScopesInner.md) |  | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetApisResponseApisInner.new(
  id: 7ccd126599aa422a771abcb341596881,
  name: Example API,
  audience: https://api.example.com,
  is_management_api: false,
  scopes: null
)
```

