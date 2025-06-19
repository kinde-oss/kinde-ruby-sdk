# KindeApi::CreateMeterUsageRecordRequest

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **customer_agreement_id** | **String** | The billing agreement against which to record usage |  |
| **billing_feature_code** | **String** | The code of the feature within the agreement against which to record usage |  |
| **meter_value** | **String** | The value of usage to record |  |
| **meter_usage_timestamp** | **Time** | The date and time the usage needs to be recorded for (defaults to current date/time) | [optional] |
| **meter_type_code** | **String** | Absolutes overrides the current usage | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::CreateMeterUsageRecordRequest.new(
  customer_agreement_id: agreement_0195ac80a14c2ca2cec97d026d864de0,
  billing_feature_code: pro_gym,
  meter_value: pro_gym,
  meter_usage_timestamp: 2024-11-18T13:32:03+11:00,
  meter_type_code: null
)
```

