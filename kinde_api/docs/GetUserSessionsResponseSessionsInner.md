# KindeApi::GetUserSessionsResponseSessionsInner

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **user_id** | **String** | The unique identifier of the user associated with the session. | [optional] |
| **org_code** | **String** | The organization code associated with the session, if applicable. | [optional] |
| **client_id** | **String** | The client ID used to initiate the session. | [optional] |
| **expires_on** | **Time** | The timestamp indicating when the session will expire. | [optional] |
| **session_id** | **String** | The unique identifier of the session. | [optional] |
| **started_on** | **Time** | The timestamp when the session was initiated. | [optional] |
| **updated_on** | **Time** | The timestamp of the last update to the session. | [optional] |
| **connection_id** | **String** | The identifier of the connection through which the session was established. | [optional] |
| **last_ip_address** | **String** | The last known IP address of the user during this session. | [optional] |
| **last_user_agent** | **String** | The last known user agent (browser or app) used during this session. | [optional] |
| **initial_ip_address** | **String** | The IP address from which the session was initially started. | [optional] |
| **initial_user_agent** | **String** | The user agent (browser or app) used when the session was first created. | [optional] |

## Example

```ruby
require 'kinde_api'

instance = KindeApi::GetUserSessionsResponseSessionsInner.new(
  user_id: kp_5fc30d0547734f30aca617450202169f,
  org_code: org_1ccfb819462,
  client_id: 3b0b5c6c8fcc464fab397f4969b5f482,
  expires_on: 2025-04-02T13:04:20.315701+11:00,
  session_id: session_0xc75ec12fe8434ffc9d527794f00692e5,
  started_on: 2025-04-01T13:04:20.315701+11:00,
  updated_on: 2025-04-01T13:04:20+11:00,
  connection_id: conn_75ab8ec0faae4f73bae9fc64daf120c9,
  last_ip_address: 192.168.65.1,
  last_user_agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36,
  initial_ip_address: 192.168.65.1,
  initial_user_agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36
)
```

