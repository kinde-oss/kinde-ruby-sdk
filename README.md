# Kinde Ruby SDK

The Kinde SDK for Ruby.

You can also use the Ruby starter kit [here](https://github.com/kinde-starter-kits/ruby-starter-kit).

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://makeapullrequest.com) [![Kinde Docs](https://img.shields.io/badge/Kinde-Docs-eee?style=flat-square)](https://kinde.com/docs/developer-tools) [![Kinde Community](https://img.shields.io/badge/Kinde-Community-eee?style=flat-square)](https://thekindecommunity.slack.com)

## Documentation

For details on integrating this SDK into your project, head over to the [Kinde docs](https://kinde.com/docs/) and see the [Ruby SDK](https://kinde.com/docs/developer-tools/ruby-sdk) doc 👍🏼.

## AI agents and MCP

`KindeSdk::AgentAuth` lets your MCP server, or any HTTP API, accept the access tokens Kinde issues to AI agents such as Claude, ChatGPT, Cursor or an agent you build yourself. Kinde is the authorization server. Your server is the resource server: it publishes where agents should sign in, checks the token on every request and reads the user's permissions from it.

`KindeSdk::AgentClient` is the agent side: it lets an app you build sign a user in to such a server and call it (sections 9 to 12).

Both are opt-in and separate from the login flow. Nothing changes for existing users of the SDK.

### 1. Create the application in Kinde

1. In Kinde, add an application of type **AI agents and MCP**. The application type is behind the `dcr_application` feature flag, so ask Kinde to turn it on for your business if you cannot see it.
2. Set its **Resource URL** to the URL agents connect to, for example `https://api.example.com/mcp`.
3. Copy the application's client ID and client secret.

The `resource_url` you give the SDK must equal the Resource URL in Kinde byte for byte. Kinde compares it exactly, so a trailing slash or a different case is a different resource.

Do not reuse the client ID of your login application. A project that has both a web app and an MCP server has two Kinde applications and two sets of credentials.

### 2. Trusted agent hosts

Well-known agents (Claude, ChatGPT and others) work without any setup. **Trusted agent hosts** is only for agents you run yourself: list the domain that serves your agent's client ID metadata document. Enter bare domains (`agents.example.com`, no scheme and no path), up to 10.

### 3. No callback URLs

An AI agents and MCP application has no callback URLs, and that is on purpose. Each agent brings its own redirect URI, and Kinde checks it against the agent's host. There is nothing to configure.

### 4. Protect an MCP server built on the `mcp` gem

If your server uses the official Ruby MCP SDK (the [`mcp`](https://rubygems.org/gems/mcp) gem), use the MCP adapter, `KindeSdk::AgentAuth::KindeTokenVerifier`. The gem reads the `Bearer` header, serves the metadata document and sends the `401` challenge. The adapter tells it whether a token is valid.

The adapter is optional, and `kinde_sdk` does not install the gems it needs. Add them yourself:

```ruby
# Gemfile
gem "kinde_sdk"
gem "mcp", ">= 1.10.0"
gem "rack"
```

```ruby
# config.ru
require "kinde_sdk"
require "kinde_sdk/agent_auth/mcp"

kinde = KindeSdk::AgentAuth.new(
  domain: ENV.fetch("KINDE_DOMAIN"),
  client_id: ENV.fetch("KINDE_AGENTS_CLIENT_ID"),
  client_secret: ENV.fetch("KINDE_AGENTS_CLIENT_SECRET"),
  resource_url: ENV.fetch("KINDE_AGENTS_RESOURCE_URL")
)
verifier = KindeSdk::AgentAuth::KindeTokenVerifier.new(kinde)
resource = URI.parse(kinde.config.resource_url)

class ReadDocs < MCP::Tool
  description "Returns the docs the signed-in user may read"

  def self.call(server_context:)
    auth = KindeSdk::AgentAuth::KindeTokenVerifier.auth_context(server_context)
    unless KindeSdk::AgentAuth.has_permission?(auth, "read:docs")
      return MCP::Tool::Response.new([{ type: "text", text: "You don't have permission to read docs." }], error: true)
    end

    MCP::Tool::Response.new([{ type: "text", text: "Here are the docs." }])
  end
end

server = MCP::Server.new(name: "docs", tools: [ReadDocs])
transport = MCP::Server::Transports::StreamableHTTPTransport.new(
  server,
  stateless: true,
  token_verifier: verifier,
  resource_metadata: verifier.resource_metadata,
  allowed_hosts: [resource.host]
)

use MCP::Server::OAuth::ProtectedResourceMetadataMiddleware, verifier.resource_metadata
map(resource.path) { run transport }
```

`verifier.resource_metadata` carries the Resource URL, the application's issuer (`https://<your domain>/oauth2/agents/<client id>`) and the `offline` scope to the gem, so you never type them twice.

- `stateless: true` is the gem's simplest mode: every `POST` is self-contained, so it also works with several server processes. Remove it to get sessions.
- `allowed_hosts` is needed because the gem's transport rejects any `Host` that is not loopback unless you list it. Behind a proxy that rewrites `Host`, list the host the transport actually sees.
- Do not also mount `KindeSdk::AgentAuth::Middleware` on this path. Every token would be checked twice.
- In this setup the HTTP answers are the gem's. If Kinde cannot be reached the answer is a `500` with `{"error":"server_error"}`, and only the path-suffixed metadata document (`/.well-known/oauth-protected-resource/mcp`) is served. If a client needs the root form or the authorization server metadata mirror, build them from `kinde.metadata_response`.

### 5. Protect any other Rack app

For a server that is not built on the `mcp` gem, use the Rack middleware. It serves the metadata routes (`/.well-known/oauth-protected-resource`, with and without the resource path), requires a valid token on the path of the Resource URL and everything below it, and leaves other paths alone.

Which paths need a token is decided on the safe side, so that no path your router sends to the same handler gets through without one. For `https://api.example.com/mcp` a token is required for `/mcp`, for `/mcp/...`, and for every path where `/mcp` is followed by anything other than a letter, a digit or an underscore: `/mcp.json` (a Rails route for `/mcp` matches it too), `/mcp-docs`, `/mcp;x` (a Rails `mount` at `/mcp` takes both). This means a sibling path such as `/mcp-docs` also needs a token. If a path next to the resource must stay public, give it a name that continues with a letter, a digit or an underscore (`/mcpdocs`, `/mcp_docs`) or a different one (`/docs`). Percent-encoded spellings such as `/%6Dcp` count as the path they decode to.

```ruby
# config.ru
require "json"
require "kinde_sdk"

kinde = KindeSdk::AgentAuth.new(
  domain: ENV.fetch("KINDE_DOMAIN"),
  client_id: ENV.fetch("KINDE_AGENTS_CLIENT_ID"),
  client_secret: ENV.fetch("KINDE_AGENTS_CLIENT_SECRET"),
  resource_url: ENV.fetch("KINDE_AGENTS_RESOURCE_URL")
)

use KindeSdk::AgentAuth::Middleware, kinde

run lambda { |env|
  auth = env[KindeSdk::AgentAuth::Middleware::ENV_KEY]
  result =
    if KindeSdk::AgentAuth.has_permission?(auth, "read:docs")
      { content: [{ type: "text", text: "Here are the docs." }] }
    else
      { isError: true, content: [{ type: "text", text: "You don't have permission to read docs." }] }
    end

  [200, { "content-type" => "application/json" }, [JSON.generate(result)]]
}
```

In Rails, add it to the middleware stack instead:

```ruby
# config/application.rb
config.middleware.use KindeSdk::AgentAuth::Middleware, kinde
```

The verified token is in `env["kinde_sdk.agent_auth"]` as a `KindeSdk::AgentAuth::AuthContext`, with `user_id`, `email`, `org_code`, `permissions`, `roles`, `scopes`, `client_id` (which agent), `expires_at` and `claims`.

The middleware protects by path, and your router may send more paths to a handler than the middleware protects. So a handler must treat a missing `env["kinde_sdk.agent_auth"]` (`nil`) as a request that is not authenticated, never as one that was already checked. `has_permission?` returns `false` for `nil`, as in the example above, and `require_permission` and `require_scope` raise the error that becomes a `401`.

Option: `authorization_server_metadata: :proxy` (or `:static`) also serves `/.well-known/oauth-authorization-server` for older MCP clients.

#### Browser-based clients (CORS)

An MCP client that runs in a browser on another origin needs CORS. The metadata routes always allow any origin. For the protected paths there are two ways.

**Let the middleware do it**, with `use KindeSdk::AgentAuth::Middleware, kinde, cors: true`. Then the middleware:

- Answers the CORS preflight on the protected paths itself. A preflight is the `OPTIONS` request with an `Origin` and an `Access-Control-Request-Method` header that a browser sends before the real request, and without the token. It gets a `204` with `Access-Control-Allow-Origin: *`, `Access-Control-Allow-Methods: GET, HEAD, POST, PUT, PATCH, DELETE, OPTIONS` and an `Access-Control-Allow-Headers` list that names `Authorization`, `Content-Type`, `Accept`, `Mcp-Session-Id`, `Mcp-Protocol-Version` and `Last-Event-ID` and ends with `*` for any other header. No token is needed for it, your app is not called, and nothing is authenticated. The real request that follows still needs its token, and so does any other `OPTIONS` request.
- Adds `Access-Control-Allow-Origin: *` and `Access-Control-Expose-Headers: WWW-Authenticate` to the `401`, `403` and `503` answers it writes, so the browser client can read the status and the challenge.

`cors: true` does not touch the responses of your own application. A browser client can only read those if your application sets `Access-Control-Allow-Origin` on them (and `Access-Control-Expose-Headers` for a response header the client must read, such as `Mcp-Session-Id`). It also allows every origin and no cookies. To allow only some origins, use the second way.

**Use a CORS middleware of your own**, and leave `cors` at its default, `false`. The CORS middleware must run before `KindeSdk::AgentAuth::Middleware`. With `cors: false` a preflight is a request without a token and gets the `401`, so a browser never sends the real request unless something in front answers the preflight first. Configure that middleware to allow the `Authorization` request header and to expose the `WWW-Authenticate` response header.

### 6. Check a permission inside a tool

Give users access through the permissions and roles you manage in Kinde, and check them with `has_permission?` inside each tool. When the permission is missing, return a tool error (`isError: true`), which the agent shows to the user:

```ruby
auth = KindeSdk::AgentAuth::KindeTokenVerifier.auth_context(server_context)
unless KindeSdk::AgentAuth.has_permission?(auth, "read:docs")
  return MCP::Tool::Response.new([{ type: "text", text: "You don't have permission to read docs." }], error: true)
end
```

With the Rack middleware, `auth` is `env["kinde_sdk.agent_auth"]`.

Do not answer a missing permission with `403 insufficient_scope`. An MCP client reads that as "sign in again and ask for more scope". A permission is not a scope and signing in again cannot grant one, so the user would be sent through login in a loop.

For a plain REST route, `require_permission` raises an error that the middleware turns into a plain `403` with a JSON body and no challenge:

```ruby
kinde.require_permission(env["kinde_sdk.agent_auth"], "write:docs")
```

`require_scope` does the same for the OAuth scopes (`offline`, `profile`, `email`) and answers `403 insufficient_scope`. It is rarely needed.

### 7. How tokens are verified

| `verification:` | What happens | Revoked tokens |
|---|---|---|
| `"introspection"` (default) | Every token is checked with Kinde, using the application's client ID and secret. | Rejected at once. |
| `"jwt"` | The signature is checked locally against Kinde's public keys, then issuer, audience and expiry. No call to Kinde per request, and the check itself does not use the client secret. | Stay valid until they expire (24 hours by default). |
| `"jwt+introspection"` | Both checks. The token is rejected if either fails. | Rejected at once. |

Choose `"jwt"` only if you can accept that trade-off: it is faster, but a token you revoke keeps working until its `exp`.

If Kinde cannot be reached, the Rack middleware answers `503` and the `mcp` gem answers `500`. Neither is a `401`, so agents do not send the user back to sign in.

### 8. Revoke a token

```ruby
kinde.revoke_token(token)                    # an access token or a refresh token
kinde.revoke_token(token, "refresh_token")   # with a hint
```

Revoking either token of a pair revokes both, the access token and the refresh token. It only works for tokens that were issued for this application's Resource URL.

### 9. Build an agent that signs in

`KindeSdk::AgentClient` is for the other direction: your app is the agent, and it calls an MCP server or API that is protected by Kinde (or by any OAuth server that follows the MCP authorization spec). One client serves one resource and one user.

The client finds the authorization server from the resource, identifies itself, sends the user to sign in, and then calls the resource with the access token. It refreshes the token when it is about to expire or when the resource answers `401`.

Sign-in is a redirect in the user's browser. The client never opens a browser and never waits: when the user has to sign in, `fetch` raises `AuthorizationRequiredError` with the URL to redirect to, and your callback route finishes the sign-in.

```ruby
# app/controllers/agent_controller.rb
class AgentController < ApplicationController
  def show
    response = agent.fetch("/documents")
    render plain: response.body, status: response.status
  rescue KindeSdk::AgentClient::AuthorizationRequiredError => e
    redirect_to e.authorization_url, allow_other_host: true
  end

  # The route of redirect_uri.
  def callback
    agent.handle_callback(request.query_parameters)
    redirect_to agent_path
  rescue KindeSdk::AgentClient::AuthorizationRequiredError => e
    redirect_to e.authorization_url, allow_other_host: true
  rescue KindeSdk::AgentClient::CallbackError, KindeSdk::AgentClient::OAuthError => e
    render plain: "Sign-in failed: #{e.message}", status: :bad_request
  end

  def disconnect
    agent.disconnect
    redirect_to root_path
  end

  private

  def agent
    @agent ||= KindeSdk::AgentClient.new(
      resource_url: ENV.fetch("AGENT_RESOURCE_URL"),
      redirect_uri: agent_callback_url,
      storage: KindeSdk::AgentClient::SessionStore.new(session)
    )
  end
end
```

- `fetch(path, method:, headers:, body:)` returns a response with `status`, `headers` and `body`. The path is added to `resource_url` (before its query, if it has one); the token is only ever sent to that resource. The whole response is read into memory, so for a streaming MCP session use the `mcp` gem's client (section 11).
- `handle_callback` checks `state`, which can be used once, and the `iss` parameter when the server sends it. A callback it refuses raises `CallbackError` and is not retried.
- `disconnect` revokes the refresh token at the authorization server and deletes the stored tokens. `disconnect(forget: true)` also deletes the stored registration, signed in or not; with no tokens stored it first asks the resource which authorization server it uses.
- `connect` does the same as `fetch` without calling the resource, `authorization_url` starts a sign-in for a "Connect" button, and `token_info` returns the granted scopes, the expiry and the client ID, never a token.
- `scopes:` defaults to `["offline"]`, which is what gives the agent a refresh token. The client never asks for `openid` at a server that does not list it, and Kinde does not: an AI agents and MCP application refuses `openid` and issues no ID token. The login scopes set with `KindeSdk.configure` are not used.
- Every URL must be `https`. Plain `http` is accepted only for the hosts `localhost`, `127.0.0.1` and `[::1]`, for local development. For the URLs a server supplies (the metadata URL in a challenge, the authorization server and its endpoints) that exception applies only when `resource_url` is itself on one of those hosts, so a remote server cannot make the agent call a service on the machine the agent runs on.
- `account:` names the user when one store holds several users. With a store per user, such as the session, leave it out.

How the agent identifies itself is decided in this order: a client ID metadata document when you set `client_metadata_url:` and the server supports it (section 10), then `client_id:` (with `client_secret:` and `issuer:` for a confidential client) when you have registered the agent by hand, then dynamic client registration. Without any of the three options set, the agent registers itself, and that works for redirect URIs on a host in the application's **Trusted agent hosts** and on loopback hosts. A registration within a day of its expiry is replaced at the next sign-in; tokens issued to the old one are still refreshed and revoked with it until it expires.

A client you registered by hand belongs to one authorization server. Name that server with `issuer:`, and the client ID and the secret are used there and nowhere else:

```ruby
KindeSdk::AgentClient.new(
  resource_url: "https://api.example.com/mcp",
  redirect_uri: "https://agent.example.com/oauth/callback",
  client_id: ENV.fetch("AGENT_CLIENT_ID"),
  client_secret: ENV.fetch("AGENT_CLIENT_SECRET"),
  issuer: "https://yourbiz.kinde.com/oauth2/agents/app_id"
)
```

- `issuer:` is required with `client_secret:`; without it the client raises an `ArgumentError`. With a `client_id:` alone it is optional, and without it the client ID is used at whatever authorization server the resource names.
- The resource decides which authorization server the agent talks to, so without this setting a resource could have the secret sent to a server of its choosing. With `issuer:` set, a resource that names any other authorization server never receives the client ID's secret, at sign-in, refresh or revocation. The agent goes on as if no client ID was set: with the client ID metadata document or dynamic registration when that server supports one, and with an error otherwise.
- The value must be exactly the issuer in the resource's metadata, character for character (a trailing slash counts). For Kinde it is the `issuer` in the application's `/.well-known/oauth-authorization-server` document. The URL rule is the same as for every other URL: `https`, or `http` on a loopback host, which only works when `resource_url` is on a loopback host too.

### 10. Publish your agent's client ID metadata document

A client ID metadata document is a small JSON file on your agent's own website. Its URL is the agent's `client_id`, so the agent needs no registration and no secret. This is the preferred way to identify an agent.

Build the document with `KindeSdk::AgentClient.build_client_metadata_document`, or serve it with the Rack app:

```ruby
# config.ru
require "kinde_sdk"

map "/oauth/client-metadata.json" do
  run KindeSdk::AgentClient.client_metadata_app(
    client_id: "https://agent.example.com/oauth/client-metadata.json",
    client_name: "Example Agent",
    redirect_uris: ["https://agent.example.com/oauth/callback"]
  )
end
```

In Rails, mount it instead:

```ruby
# config/routes.rb
mount KindeSdk::AgentClient.client_metadata_app(
  client_id: "https://agent.example.com/oauth/client-metadata.json",
  client_name: "Example Agent",
  redirect_uris: ["https://agent.example.com/oauth/callback"]
), at: "/oauth/client-metadata.json"
```

Then pass the same URL to the client as `client_metadata_url: "https://agent.example.com/oauth/client-metadata.json"`.

- Mount the app at exactly the path of `client_id`. Kinde compares the `client_id` in the document with the URL it fetched, and the app does not check this for you.
- Add the document's host (`agent.example.com`) to the application's **Trusted agent hosts** in Kinde. Well-known vendor agents such as Claude and ChatGPT are trusted already. Nothing else is, so without this step sign-in fails with `invalid_client`.
- The document must be reachable from the public internet over `https`. Kinde fetches it and refuses private addresses, so a document on `localhost` cannot work. For local testing use a tunnel with a real domain.
- Redirect URIs must be `https` on the same host as the document, or `http` on `localhost`, `127.0.0.1` or `[::1]` with any port. Kinde drops everything else, including other hosts and custom schemes such as `myapp://`, so the builder raises an `ArgumentError` for them.
- The app answers `GET` and `HEAD` with `Cache-Control: public, max-age=3600` and never redirects.

### 11. Use the `mcp` gem's client

If your agent talks to the MCP server through the official Ruby MCP SDK, let the gem run the OAuth flow and give it `KindeSdk::AgentClient::KindeOAuthProvider`. The provider hands the gem your settings and your store, and keeps `openid` out of the request. Like the server adapter, it is optional: add `gem "mcp", ">= 1.10.0"` to your Gemfile.

```ruby
require "kinde_sdk"
require "kinde_sdk/agent_client/mcp"

agent = KindeSdk::AgentClient.new(
  resource_url: "https://api.example.com/mcp",
  redirect_uri: "https://agent.example.com/oauth/callback",
  client_metadata_url: "https://agent.example.com/oauth/client-metadata.json",
  storage: KindeSdk::AgentClient::SessionStore.new(session)
)
provider = KindeSdk::AgentClient::KindeOAuthProvider.new(agent)
mcp_client = MCP::Client.new(transport: MCP::Client::HTTP.new(url: agent.config.resource_url, oauth: provider))
```

When the user has to sign in, the gem raises an error that carries the URL. Redirect to it, and finish in your callback route:

```ruby
begin
  tools = mcp_client.tools
rescue MCP::Client::OAuth::Flow::AuthorizationPendingError => e
  redirect_to e.authorization_url, allow_other_host: true
end

# In the route of redirect_uri:
provider.finish!(request.query_parameters)
```

With the adapter, the flow is the gem's, and these parts differ from `KindeSdk::AgentClient#fetch`:

- The gem asks for the scopes the MCP server advertises. If the server's metadata does not list `offline`, the agent gets no refresh token. A server protected with `KindeSdk::AgentAuth` always lists it. A server that demands `openid` in its challenge is refused with `AuthorizationRefusedError`.
- Set either `client_metadata_url:` or `client_id:`, not both: the provider raises an `ArgumentError` for both.
- `issuer:` holds here too: the gem gets the configured `client_id:` and `client_secret:` bound to that issuer and does not use them at any other authorization server; there it registers a client of its own. The gem sends a configured secret in an HTTP Basic header. With `issuer:` set, a `client_id:` that is an `https` URL with a path raises an `ArgumentError`, because the gem treats such a client ID as valid at every server.
- `pending_authorization_max_age:` can be 600 seconds at most (the default), because the stores drop sign-in attempts older than ten minutes. A higher value raises an `ArgumentError`.
- When the stored registration is rejected with `invalid_client`, the gem does not register again; it raises `Flow::AuthorizationError`. A registration that is about to expire is still replaced.
- A failed registration is reported with its status code only, without the server's description.
- The gem does not revoke tokens, and `agent.disconnect` does not touch the tokens the gem stored.
- The gem keeps its tokens apart from the ones `fetch` uses, so sign in through one of the two, not both.
- With a `client_id:` and no `issuer:`, a resource that changes its authorization server between two sign-ins makes the first sign-in after the change fail: the gem registers a client of its own at the new server, and `finish!` then raises `Flow::AuthorizationError` ("The client registration changed after the authorization began"). Starting the sign-in again works and uses the configured client ID. Set `issuer:` to avoid it.
- The gem makes the discovery requests itself and applies its own rule to the URLs a server names: the metadata URL in a challenge must be on the MCP server's origin, and an authorization server or an authorization, token or registration endpoint on `localhost` or on a loopback, private or link-local address is refused, in `http` and in `https`, unless the MCP server is itself on such an address. That is stricter than `fetch`, which accepts `https` on any address and refuses only plain `http` (allowed on a loopback host when `resource_url` is on one too).

### 12. Where tokens are stored

The client keeps the tokens, the dynamic registration and, for up to ten minutes, the unfinished sign-in attempts in a store. Two stores ship with the SDK:

| Store | Keeps things | Use it for |
|---|---|---|
| `KindeSdk::AgentClient::MemoryStore` (default) | In the memory of one process. Lost on restart, not shared between processes. | Tests, scripts and single-process tools. Pass `account:` per user. |
| `KindeSdk::AgentClient::SessionStore.new(session)` | Under one key of the session, or of any Hash-like object. | Web apps: each user's tokens live in that user's session. |

The store holds a refresh token, a client secret when the agent registered itself and, during sign-in, a PKCE verifier. So the session must be kept on the server (a database, Redis or cache session store) or be encrypted. Never keep it in a plain, unencrypted cookie. A cookie session also has a size limit of about 4 KB, which these records can exceed, so a server-side session store is the safe choice.

To keep tokens somewhere else, pass any object with these three methods as `storage:`:

```ruby
class RedisAgentStore
  def initialize(redis)
    @redis = redis
  end

  def read(namespace, key)
    value = @redis.get(name(namespace, key))
    value && JSON.parse(value)
  end

  def write(namespace, key, value)
    @redis.set(name(namespace, key), JSON.generate(value))
    value
  end

  # Must remove the value and return it in one atomic step.
  def delete(namespace, key)
    value = @redis.getdel(name(namespace, key))
    value && JSON.parse(value)
  end

  private

  def name(namespace, key)
    "kinde_agent:#{namespace}:#{JSON.generate(key)}"
  end
end
```

`namespace` is a String and `key` an Array of Strings: `tokens` with `[issuer, resource_url, account]`, `registrations` with `[issuer, redirect_uri]`, `pending` with `[state]`, and `issuers` with `[resource_url, account]`. Values are Hashes, Arrays and Strings that survive a round trip through JSON. `delete` must be atomic, because it is what makes a sign-in callback usable only once. Expire `pending` entries after ten minutes (the two built-in stores drop them when they are older than that), and encrypt the values at rest if the storage is shared.

Refreshes are serialised inside one Ruby process. Two processes that share a store can still refresh the same token at the same moment.

## Publishing

The core team handles publishing.

## Contributing

Please refer to Kinde’s [contributing guidelines](https://github.com/kinde-oss/.github/blob/489e2ca9c3307c2b2e098a885e22f2239116394a/CONTRIBUTING.md).

## License

By contributing to Kinde, you agree that your contributions will be licensed under its MIT License.
