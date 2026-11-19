# Kinde Ruby SDK

The Kinde SDK for Ruby.

You can also use the Ruby starter kit [here](https://github.com/kinde-starter-kits/ruby-starter-kit).

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://makeapullrequest.com) [![Kinde Docs](https://img.shields.io/badge/Kinde-Docs-eee?style=flat-square)](https://kinde.com/docs/developer-tools) [![Kinde Community](https://img.shields.io/badge/Kinde-Community-eee?style=flat-square)](https://thekindecommunity.slack.com)

## Documentation

For details on integrating this SDK into your project, head over to the [Kinde docs](https://kinde.com/docs/) and see the [Ruby SDK](https://kinde.com/docs/developer-tools/ruby-sdk) doc 👍🏼.

## AI agents and MCP

`KindeSdk::AgentAuth` lets your MCP server, or any HTTP API, accept the access tokens Kinde issues to AI agents such as Claude, ChatGPT, Cursor or an agent you build yourself. Kinde is the authorization server. Your server is the resource server: it publishes where agents should sign in, checks the token on every request and reads the user's permissions from it.

It is opt-in and separate from the login flow. Nothing changes for existing users of the SDK.

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

## Publishing

The core team handles publishing.

## Contributing

Please refer to Kinde’s [contributing guidelines](https://github.com/kinde-oss/.github/blob/489e2ca9c3307c2b2e098a885e22f2239116394a/CONTRIBUTING.md).

## License

By contributing to Kinde, you agree that your contributions will be licensed under its MIT License.
