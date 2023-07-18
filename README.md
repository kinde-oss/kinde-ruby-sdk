# Kinde Ruby SDK 

The Kinde Ruby SDK gem allows developers to integrate Kinde API into any ruby-based applications, Rails or non-Rails.
The gem contains all the related oauth2 authorization, so you need only to integrate it properly.
The gem contains 3 pre-built OAuth flows: **client credentials**, **authorization code** and **authorization code with PKCE code verifier**.

## Register for Kinde

If you haven’t already got a Kinde account, register for free [here](http://app.kinde.com/register) (no credit card required).

You need a Kinde domain to get started, e.g. yourapp.kinde.com.

## Installation

Add this line into your Gemfile and run bundler:
```
gem 'kinde_sdk', git: 'https://github.com/kinde-oss/kinde-ruby-sdk.git', branch: 'main'
```
or install manually through gem command.

## Getting started

### Kinde configuration

On the Kinde web app navigate to `Settings` in the left menu, then select `App keys` and find the `Callbacks` input field.

Here you want to put in the callback URLs for your application, which should look something like this:

- **Allowed callback URLs** - `http://localhost:3000/api/auth/kinde_callback`
- **Allowed logout redirect URLs** - `http://localhost:3000`

Make sure you press the Save button at the bottom of the page!

_Note_: The `http://localhost:3000` is used as an example of local address, don't forget to add all the required addresses that you are going to use in any environments.

### Environments

If you would like to use our Environments feature as part of your development process. You will need to create them first within your Kinde account, see the guide here. 
In this case you would use the Environment subdomain in the code block above.

### Configuring your app

In a basic scenario it requires several steps to be made:
1. proper configuring of client credentials and domain
2. external service authorization
3. callback processing
4. bearer token receiving
5. Usage

#### Integration
The gem contains simple configurator which you can use whenever you want. For example, in a typical Rails-app it can be
configured through initializer file:

```ruby
# domain, client_id/secret and callback defined somewhere in your settings

KindeSdk.configure do |c|
 c.domain = domain
 c.client_id = client_id
 c.client_secret = client_secret
 c.callback_url = callback_url
 c.logout_url = logout_url
 # c.scope = 'openid offline email profile' # default value
 # c.pkce_enabled = true                    # default value
 # c.authorize_url = '/oauth2/auth'         # default value
 # c.token_url = '/oauth2/token'            # default value
 # c.debugging = false                      # default value
 # c.auto_refresh_tokens = true             # default value
 c.logger = Rails.logger
end
```
Snippet above contains all the possible configuration values.
Here is detailed explanation on them:

- `Domain` refers to your organization - for example, `your-biz.kinde.com`.
- `Client id` and `Client secret` can be fetched from your Kinde application credentials in a setting section.
- `Callback url` refers to your callback processing controller action. Remember that 
the url must be defined in allowed callback urls of your kinde organization's [application config](#Kinde-configuration).
Callback url is an optional parameter, you can set the desired url in runtime, see examples below.
- `Logout url` will be triggered after successful logout on kinde. Same as callback url, it should be 
defined in allowed logout urls of your kinde organization's application config
- `Scope` is an oauth special parameter which is used to limit some rights. Probably, you don't need to change in.
- `PKCE enabled` is a flag that can turn off PKCE auth flow. By default it is activated to improve your security.
- `Authorize url` and `Token url` are paths to oauth2 methods in kinde. You don't need to change it.
- `Debugging` set to true start writing verbose request logs. Might be useful while developing your application.
- `Logger` might be set to any kind of loggers you are using. By default it is set to `Rails.logger` if gem is used in
rails application or `Logger.new(STDOUT)` if it is not a rails app.
- `auto_refresh_tokens` defines default behaviour on api instance method calls. If the config set to false, there will not be any auto refreshes during method calling,
otherwise each time client will try to refresh expired tokens if `expires_at` are present (see [token expiration and refreshing](#token-expiration-and-refreshing) section).

These variables can be handled with any system you want: .env files, settings.yml or any type of config files.
For example, .env file (you can name variables by yourself):
```
KINDE_DOMAIN=https://example.kinde.com
KINDE_CLIENT_ID=qwe
KINDE_CLIENT_SECRET=wert
KINDE_CALLBACK_URL=http://localhost:3000/callback
KINDE_LOGOUT_URL=http://localhost:3000/logout_callback
```

can be used as:
```ruby
KindeSdk.configure do |c|
 c.domain = ENV['KINDE_DOMAIN']
 c.client_id = ENV['KINDE_CLIENT_ID']
 # ....
end
```

#### Login / Register
The next step is to authorize you in the Kinde.
For this, you need to acquire auth url by calling:
```ruby
KindeSdk.auth_url
# => 
{
 url: "https://<domain>/oauth2/auth?client_id=<client_id>&code_challenge=<generated code>&code_challenge_method=S256&redirect_uri=<redirect_uri>&response_type=code&scope=openid+offline+email+profile&state=<random string>",
 code_verifier: "<challenge verifier>"
}
```
By default, gem uses PKCE verification flow - this means that in your auth url will be added special `code challenge` 
param and the method returns verification string for the code, which should be used later in token acquiring request.
You are free to disable PKCE by setting `pkce_enabled` to false in your configuration. 
In this case, `KindeSdk.auth_url` will return only url itself:
```ruby
KindeSdk.auth_url
# => {url: ......}
```
If you are about to use PCKE, our recommendation to save code verifier output somewhere near your later tokens output.

The `#auth_url` method can have another redirect url just in runtime. Use it with the argument:
```ruby
KindeSdk.auth_url(redirect_uri: "your-another-desired-callback")
```

You can put the link right in your web-application page or you can use it under the hood through redirection.
After visiting the link you'll be redirected to Kinde's sign in/sign up form.
And after authorizing in Kinde, you'll be redirected to callback url.

#### Handle redirect
Next step is to extract code from the callback redirection. Your callback endpoint should contain logic to call exchange method.
Callback will be triggered with body, where will be code present. You are free to use the whole `params` object or to extract code from `params["code"]`.

Next, it needs to be exchanged for the access and refresh tokens.
`code` is the parameter which received in the callback endpoint, `code_verifier` (if PKCE enabled) should be used from previous step:  
```ruby
KindeSdk.fetch_tokens(code, code_verifier: code_verifier)
# => 
{"access_token"=>"eyJhbGciOiJSUzI1NiIsIm...",                                
 "expires_in"=>86399,                             
 "id_token"=>"eyJhbGciOiJSUz",
 "refresh_token"=>"eyJhbGciOiJSUz",
 "scope"=>"openid offline email profile",                               
 "token_type"=>"bearer"}
```

This is your tokens - save the whole hash in your session, redis or any other storage and use it to build your client:
```ruby
# In case of preventing cookie overflow, you need to limit what exactly your are saving.
# Here is the required minimum of params. But in general you are able save it wherever you want to. 
# For example, in database, without any limiting.
session[:kinde_auth] = KindeSdk.fetch_tokens(code).slice(:access_token, :id_token, :refresh_token, :expires_at)
# ...
client = KindeSdk.client(session[:kinde_auth]) # => #<KindeSdk::Client:0x00007faf31e5ecb8> 
```

The `#fetch_tokens` method can have another callback url (just lake the `#auth_url` method), just use it in a same way:
```ruby
KindeSdk.fetch_tokens(code, redirect_uri: "your-another-desired-callback")
```

#### Token expiration and refreshing
For proper refreshing you'll need to use `access_token`, `refresh_token` and probably `expires_in` if you want to know is your access token still actual.
Use these two methods to work with refreshing:
```ruby
KindeSdk.token_expired?(session[:kinde_auth]) # => false
KindeSdk.refresh_token(session[:kinde_auth]) # => {"access_token" => "qwe...", "refresh_token" => "fqw...", "expires_at"=>1685474405}
```
or from your client instance:
```ruby
client.token_expired? # => false
client.refresh_token # => {"access_token" => "qwe...", ...., "expires_at"=>1685474405}
```
If you are calling `#refresh_token` on a client instance, the instance token data will be automatically updated.
If you are calling `KindeSdk#refresh_token`, you'll need to store new token data in your configured storage (redis/session/etc).

**Warning!**
Each instance_api method checking tokens for expiration if expires_at present in a hash.
So, if in your backend code you are using some storage, be sure you are saving `client.tokens_hash` after each instance
method calling, otherwise you will keep in your storage (session/redis/etc.) old data and unable to fetch new tokens.

If you don't want auto refreshing behavior, set `auto_refresh_tokens` config to false.

#### Audience
An `audience` is the intended recipient of an access token - for example the API for your application.
The audience argument can be passed to the Kinde `#auth_url` method to request an audience be added to the provided token:
```ruby
KindeSdk.auth_url(audience: "https://your-app.kinde.com/api")
```
For details on how to connect, see [Register an API](https://kinde.com/docs/developer-tools/register-an-api/)

#### Overriding scope
By default `KindeSdk` requests the following scopes:

- profile
- email
- offline
- openid

You are able to change it - by configuring as mentioned at [Integration](#integration) or by direct param passing into `auth_url` method:
```ruby
KindeSdk.auth_url(scope: "openid offline")
```

#### Getting claims
We have provided a helper to grab any claim from your id or access tokens. The helper defaults to access tokens:
```ruby
client = KindeSdk.client(session[:kinde_auth])
client.get_claim("aud") #=> {name: "aud", value: ['api.yourapp.com']}
client.get_claim("scp") #=> {name: "scp", value: ["openid", "offline"]}
```
By default claim data fetched from access_token, but you can also do it with id_token as well:
```ruby
client.get_claim("some-claim", :id_token) # => {name: "some-claim", value: "some-data"}
```

#### User permissions
After a user signs in and they are verified, the token return includes permissions for that user. 
[User permissions](https://kinde.com/docs/user-management/user-permissions) are set in Kinde, 
but you must also configure your application to unlock these functions.
```
permissions" => [
    "create:todos",
    "update:todos",
    "read:todos",
    "delete:todos",
    "create:tasks",
    "update:tasks",
    "read:tasks",
    "delete:tasks",
]
```
We provide helper functions to more easily access permissions:
```ruby
client = KindeSdk.client(session[:kinde_auth])
client.get_permission("create:todos") # => {org_code: "org_1234", is_granted: true}
client.permission_granted?("create:todos") # => true
client.permission_granted?("create:orders") # => false
```

#### Feature flags
Kinde itself provides feature flag functionality - more [here](https://kinde.com/feature-flags/).
So, the SDK provides methods to work with them.
For example, you have data like below:
```json
{
  "asd": { "t": "b", "v": true },
  "eeeeee": { "t": "i", "v": 111 },
  "qqq": { "t": "s", "v": "aa" }
}
```
where `t` refers to type (`b` - boolean, `i` - integer, `s` - string) and `v` refers to value.
You can fetch these flags with methods below:
```ruby
client.get_flag("asd") # => { code: "asd", is_default: false, type: "boolean", value: true }
client.get_flag("eeeeee") # => { code: "eeeeee", is_default: false, type: "integer", value: 111 }
client.get_flag("qqq") # => { code: "qqq", is_default: false, type: "string", value: "aa" }
```
Note that trying to call undefined flag leads to exception.

In addition to fetch existing flags, you can use fallbacks. For example:
```ruby
client.get_flag("undefined", { default_value: true }) # => { code: "undefined", is_default: true, value: true }
```

and with setting the type explicitly (output omitted except value):
```ruby
client.get_flag("undefined_bool", { default_value: true }, "b") # => value = true
client.get_flag("undefined_string", { default_value: "true" }, "s") # => value = "true"
client.get_flag("undefined_int", { default_value: 111 }, "i") # => value = 111
```
In the example above if you try to set default_value of different type (for example: `get_flag("flag", {default_value: 1}, "s")`), you'll get an exception.

Also you have wrapper methods, for example:
```ruby
client.get_boolean_flag("eeeeee") # => leads to exception "Flag eeeeee value type is different from requested type"
client.get_boolean_flag("asd") # => true
client.get_boolean_flag("undefined", false) # => false

client.get_integer_flag("asd") # => exception "Flag asd value type is different from requested type"
client.get_integer_flag("undefined", "true") # => exception "Flag undefined value type is different from requested type"
client.get_integer_flag("eeeeee") # => 111
client.get_integer_flag("undefined", 123) # => 123

client.get_string_flag("qqq") # => "aa"
client.get_string_flag("undefined", "111") # => "111"
```

#### Client usage
API part is mounted in the `KindeSdk::Client` instance, so the short usage is just simple as:
```ruby
client.oauth.get_user
client.users.create_user(args)
client.organizations.get_organizations
```
The method name will be the same as API module from sdk without `-Api` part in the end.
Alternatively, you can initialize each API module by yourself:
```ruby
# use initialized and configured api client
api_client = KindeSdk.api_client(access_token)
instance_client = KindeApi::UsersApi.new(api_client)
instance_client.create_user(args)
```

#### Logout
For logout you need to call (in case of rails app) in your controller:
```ruby
redirect_to KindeSdk.logout_url, allow_other_host: true
```
Your app should handle logout callback url (which was configured separately).
After calling redirect to logout_url (if set), Kinde redirect it back to logout callback path, where you need to clear your session:
```ruby
  # .......
  def logout_callback
    Rails.logger.info("logout callback successfully received")
    reset_session
    redirect_to root_path
  end
  # ......
```
If you configured logout redirect url correct (e.g. added in the admin panel allowed logout redirect), you can receive 
a logout callback. Otherwise Kinde logout message will be shown.

### Organizations
#### Create an organization
To have a new organization created within your application, you will need to run something like:
```ruby
client.organizations.create_organization(create_organization_request: {name: "new_org"})
# or `client.organizations.create_organization` without name
```

### Sign up and sign in to organizations
Kinde has a unique code for every organization. 
If you want a user to sign into a particular organization, call the `#auth_url` method with `org_code` param passing:
```ruby
KindeSdk.auth_url(org_code: "org_1234", start_page: "registration") # to enforce new user creation form
KindeSdk.auth_url(org_code: "org_1234") # to login by default
```

Following authentication, Kinde provides a json web token (jwt) to your application. 
Along with the standard information we also include the `org_code` and the permissions for that organization (this is important as a user can belong to multiple organizations and have different permissions for each).

Example of a returned token:
```ruby
[
  {
    "aud" => [],
    "exp" => 1658475930,
    "iat" => 1658472329,
    "iss" => "https://your_subdomain.kinde.com",
    "jti" => "123457890",
    "org_code" => "org_1234",
    "permissions" => ["read:todos", "create:todos"],
    "scp" => [
      "openid",
      "profile",
      "email",
      "offline"
    ],
    "sub" => "kp:123457890",
    "feature_flags" => {
      "asd" => { "t" => "b", "v" => true },
      "eeeeee" => { "t" => "i", "v" => 111 },
      "qqq" => { "t" => "s", "v" => "aa" }
    }
  }
]
```
The `id_token` will also contain an array of organizations that a user belongs to - this is useful if you wanted to build out an organization switcher for example:
```ruby
client.get_claim("org_codes", :id_token) # => {name: "org_codes", value: ["org_1234", "org_5462"]}
```

### API reference
Detailed API reference described in [KindeSDK README](kinde-sdk/README.md) and underlying description docs.
Here are some selected examples of usage.

#### Getting user info

```ruby
KindeSdk.client(session[:kinde_auth]).oauth.get_user
# => {id: ..., preferred_email: ..., provided_id: ..., last_name: ..., first_name: ...}
```

#### Management API
These sections below are part of management API. It should be configured first at your Kinde account
[Here is detailed note about it](https://kinde.notion.site/Management-API-via-client_credentials-240e6fa548c144828d4981ddbaa0f6b2),
you need to add `Machine to Machine` (M2M) application and use another grant type for authorization:
```ruby
result = KindeSdk.client_credentials_access(
  client_id: ENV["KINDE_MANAGEMENT_CLIENT_ID"],
  client_secret: ENV["KINDE_MANAGEMENT_CLIENT_SECRET"]
)
# as an example of usage redis to save access token:
$redis.set("kinde_m2m_token", result["access_token"], ex: result["expires_in"].to_i)
```

##### Organizations handling
```ruby
client = KindeSdk.client({"access_token" => $redis.get("kinde_m2m_token")})
# get organizations list:
client.organizations.get_organizations
# => {"code": "OK", "message": "Success", "next_token": "qweqweqwe", "organizations": [{"code": "org_casda123c", "name": "Default Organization", "is_default": true}]}

# create new organization:
client.organizations.create_organization(create_organization_request: {name: "new_org"})
# this variant for more strict input params validation:
# client.organizations.create_organization(create_organization_request: KindeApi::CreateOrganizationRequest.new(name: new_org_name))
```

#### Create new user
```ruby
client.users.create_user(
  create_user_request: {
    profile: {given_name: "AAAname", family_name: "AAAsurname"}, 
    identities: [{type: "email", details: {email: "aaexample@asd.com"}}]
  }
)
```
Alternatively, using model instances:
```ruby
request = KindeApi::CreateUserRequest.new(
  profile: KindeApi::CreateUserRequestProfile.new(given_name: "AAAfirstname1", family_name: "AAAlastname1"), 
  identities: [
    KindeApi::CreateUserRequestIdentitiesInner.new(type: "email", details: KindeApi::CreateUserRequestIdentitiesInnerDetails.new(email: "aaaaexample@example.com"))
  ]
)
client.users.create_user(create_user_request: request)
```

#### Add organization users

```ruby
client.organizations.add_organization_users(code: "org_1111", users: ["kp:12311...."])
```
