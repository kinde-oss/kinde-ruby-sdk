# kinde_api

KindeApi - the Ruby gem for the Kinde Management API

Provides endpoints to manage your Kinde Businesses

Contains oauth2 authorization part with generatable sdk.
For more sdk information please refer to [KindeSDK README](kinde-sdk/README.md)

## Installation

Add this line into your Gemfile and run bundler:
```
gem 'kinde_api', git: 'git@github.com:kinde-oss/kinde-ruby-sdk.git'
```
or install manually through gem command.

## Usage

In a basic scenario it requires several steps to be made:
1. proper configuring of client credentials and domain
2. external service authorization
3. callback processing
4. bearer token receiving
5. Usage

### Step 1
The gem contains simple configurator which you can use whenever you want. For example, in a typical Rails-app it can be
configured through initializer file:

```ruby
# domain, client_id/secret and callback defined somewhere in your settings

KindeApi.configure do |c|
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
 # c.business_name = nil                    # default value
 c.logger = Rails.logger
end
```
Snippet above contains all the possible configuration values.
Here is detailed explanation on them:
- **Domain** refers to your organization - for example, `your-biz.kinde.com`.
- **Client id** and **secret** can be fetched from your Kinde application credentials in a setting section.
- **Callback url** refers to your callback processing controller action. Please note, that 
the url must be defined in allowed callback urls of your kinde organization's application config.
- **Logout url** will be triggered after successful logout on kinde. Same as callback url, it should be 
defined in allowed logout urls of your kinde organization's application config
- **Scope** is an oauth special parameter which is used to limit some rights. Probably, you don't need to change in.
- **PKCE enabled** is a flag that can turn off PKCE auth flow. By default it is activated to improve your security.
- **Authorize url** and **token url** are paths to special oauth2 methods in kinde. You don't need to change it.
- **Debugging** set to true start writing verbose request logs. Might be useful while developing your application.
- **Business name** is a special parameter which is used in requests building. By default it is extracted from your
**domain** endpoint. For example, if your domain is `your-biz.kinde.com`, then business name will be set to`your-biz`.
You don't need to change it in general.
- **Logger** might be set to any kind of loggers you are using. By default it is set to `Rails.logger` if gem is used in
rails application or `Logger.new(STDOUT)` if it is not a rails app.

### Step 2
The next step is to authorize you in the kinde.
For this, you need to acquire auth url by calling:
```ruby
KindeApi.auth_url
# => 
{
 url: "https://<domain>/oauth2/auth?client_id=<client_id>&code_challenge=<generated code>&code_challenge_method=S256&redirect_uri=<redirect_uri>&response_type=code&scope=openid+offline+email+profile&state=<random string>",
 code_verifier: "<challenge verifier>"
}
```
By default, gem uses PKCE verification flow - this means, that in your auth url will be added special `code challenge` 
param and the method returns verification string for the code, which should be used later in token acquiring request.
You are able to disable PKCE by setting `pkce_enabled` to false in your configuration. 
In this case, `KindeApi.auth_url` will return only url itself:
```ruby
KindeApi.auth_url
# => {url: ......}
```
If you are about to use PCKE, our recommendation to save code verifier output somewhere near your later tokens output.

You can put the link right in your web-application page or you can use it under the hood through redirection.
After visiting the link you'll be redirected to Kinde's sign in/sign up form.
And after authorizing in Kinde, you'll be redirected to callback url.

### Step 3
Next step is to extract code from the callback redirection. Typically, you can fetch it from `params["code"]`. 
Alternatively, the whole params hash can be passed in KindeApi bearer token fetcher.

### Step 4
So, the next step is to call the bearer token fetcher:
```ruby
KindeApi.fetch_tokens(code, code_verifier)
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
session[:kinde_auth] = KindeApi.fetch_tokens(code).slice(:access_token, :refresh_token, :expires_at)
# ...
client = KindeApi.client(session[:kinde_auth][:access_token]) # => #<KindeApi::Client:0x00007faf31e5ecb8> 
```

### Step 5
#### Token expiration and refreshing
For proper refreshing you'll need to use `access_token`, `refresh_token` and probably `expires_in` if you want to know is your access token still actual.
Use these two methods to work with refreshing:
```ruby
KindeApi.token_expired?(session[:kinde_auth]) # => false
KindeApi.refresh_token(session[:kinde_auth]) # => {"access_token" => "qwe...", "refresh_token" => "fqw...", .....}
```
`KindeApi#refresh_token` returns new token hash, so you need to update your storage data with it.

#### Client usage
SDK part for API usage is mounted in the `KindeApi::Client` instance, so the short usage is just simple as:
```ruby
client.oauth.get_user
client.users.create_user(args)
```
The method name will be the same as API module from sdk without `-Api` part in the end.
Alternatively, you can initialize API module itself:
```ruby
# use initialized and configured api client
api_client = KindeApi.api_client(bearer)
instance_client = KindeSdk::UsersApi.new(api_client)
instance_client.create_user(args)
```

#### Logout
For logout you need to call:
```ruby
instance_client.logout
# or
KindeApi.logout(bearer)
```
then clear your session or storage (delete your token) and redirect wherever you want to.
If you configured logout redirect url correct (e.g. added in the admin panel allowed logout redirect), you can receive 
a logout callback. Use it if it needs to perform some clean-ups or any other jobs.

