# KindeApi::CreateConnectionRequestOptions

## Class instance methods

### `openapi_one_of`

Returns the list of classes defined in oneOf.

#### Example

```ruby
require 'kinde_api'

KindeApi::CreateConnectionRequestOptions.openapi_one_of
# =>
# [
#   :'CreateConnectionRequestOptionsOneOf',
#   :'CreateConnectionRequestOptionsOneOf1',
#   :'CreateConnectionRequestOptionsOneOf2'
# ]
```

### build

Find the appropriate object from the `openapi_one_of` list and casts the data into it.

#### Example

```ruby
require 'kinde_api'

KindeApi::CreateConnectionRequestOptions.build(data)
# => #<CreateConnectionRequestOptionsOneOf:0x00007fdd4aab02a0>

KindeApi::CreateConnectionRequestOptions.build(data_that_doesnt_match)
# => nil
```

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| **data** | **Mixed** | data to be matched against the list of oneOf items |

#### Return type

- `CreateConnectionRequestOptionsOneOf`
- `CreateConnectionRequestOptionsOneOf1`
- `CreateConnectionRequestOptionsOneOf2`
- `nil` (if no type matches)

