# KindeApi::GetTimezonesResponseTimezonesInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **key** | **String** | The unique key for the timezone. | [optional] |
| **name** | **String** | The display name for the timezone. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetTimezonesResponseTimezonesInner.new(
  key: london_greenwich_mean_time,
  name: London (Greenwich Mean Time) [+01:00]
)
```

