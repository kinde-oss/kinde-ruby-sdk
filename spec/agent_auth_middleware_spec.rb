require 'spec_helper'
require 'rack'
require 'action_dispatch'
require_relative 'support/agent_auth_helpers'

# Rack middleware over the AgentAuth core. Case ids M1-M18 are the ones in the
# approved plan; M19 was added in fix round 1, M20 and M21 in fix round 2,
# M22-M28 in fix round 3.
RSpec.describe KindeSdk::AgentAuth::Middleware do
  include AgentAuthHelpers

  let(:kinde) { build_agent_auth }
  let(:jwt_kinde) { build_agent_auth(verification: "jwt") }
  let(:token) { sign_token }
  let(:prm_url) { AgentAuthHelpers::PRM_URL }
  let(:prm_path) { AgentAuthHelpers::PRM_PATH }
  let(:bare_challenge) { %(Bearer resource_metadata="#{prm_url}") }
  let(:invalid_token_challenge) do
    /\ABearer error="invalid_token", error_description="[^"]+", resource_metadata="#{Regexp.escape(prm_url)}"\z/
  end

  # Every env the downstream app was called with.
  let(:seen) { [] }
  let(:downstream) do
    lambda do |env|
      seen << env
      [200, { "content-type" => "text/plain" }, ["downstream"]]
    end
  end

  def stack(agent_auth = kinde, inner = downstream, **options)
    described_class.new(inner, agent_auth, **options)
  end

  def call(method, path, app: stack, **env)
    Rack::MockRequest.new(app).request(method, path, env)
  end

  def bearer(value = token)
    { "HTTP_AUTHORIZATION" => "Bearer #{value}" }
  end

  def json(response)
    JSON.parse(response.body)
  end

  describe "metadata routes" do
    it "M1: serves the protected resource metadata at the path-suffixed route", :aggregate_failures do
      response = call("GET", prm_path)

      expect(response.status).to eq(200)
      expect(response.headers["content-type"]).to eq("application/json")
      expect(response.headers["cache-control"]).to eq("max-age=3600")
      expect(response.headers["access-control-allow-origin"]).to eq("*")
      expect(json(response)).to eq(
        "resource" => "https://api.example.com/mcp",
        "authorization_servers" => ["https://yourbiz.kinde.com/oauth2/agents/app_id"],
        "bearer_methods_supported" => ["header"],
        "scopes_supported" => ["offline"]
      )
      expect(seen).to be_empty
    end

    it "M2: serves the same document at the root well-known route", :aggregate_failures do
      response = call("GET", "/.well-known/oauth-protected-resource")

      expect(response.status).to eq(200)
      expect(json(response)).to eq(json(call("GET", prm_path)))
      expect(json(response)).to eq(kinde.protected_resource_metadata)
    end

    it "M3: answers OPTIONS on both routes with permissive CORS", :aggregate_failures do
      [prm_path, "/.well-known/oauth-protected-resource"].each do |path|
        response = call("OPTIONS", path, "HTTP_ORIGIN" => "https://inspector.example.com")

        expect(response.status).to eq(204)
        expect(response.body).to eq("")
        expect(response.headers["access-control-allow-origin"]).to eq("*")
        expect(response.headers["access-control-allow-methods"]).to eq("GET, OPTIONS")
        expect(response.headers["access-control-expose-headers"]).to eq("WWW-Authenticate")
      end
      expect(seen).to be_empty
    end

    it "M4: serves the authorization server mirror only when asked to", :aggregate_failures do
      mirror = "/.well-known/oauth-authorization-server"
      upstream = {
        "issuer" => AgentAuthHelpers::ISSUER,
        "client_id_metadata_document_supported" => true,
        "a_field_kinde_adds_later" => "kept"
      }

      default = call("GET", mirror)
      expect(default.body).to eq("downstream")
      expect(seen.size).to eq(1)

      static = call("GET", mirror, app: stack(authorization_server_metadata: :static))
      expect(static.status).to eq(200)
      expect(static.headers["cache-control"]).to eq("max-age=300")
      expect(static.headers["access-control-allow-origin"]).to eq("*")
      expect(json(static)).to eq(kinde.authorization_server_metadata(:static))
      expect(json(static)["client_id_metadata_document_supported"]).to be(true)

      stub_request(:get, AgentAuthHelpers::AS_METADATA_URL).to_return(status: 200, body: upstream.to_json)
      proxied = call("GET", mirror, app: stack(build_agent_auth, authorization_server_metadata: :proxy))
      expect(proxied.status).to eq(200)
      expect(json(proxied)).to eq(upstream)
      expect(json(proxied)["client_id_metadata_document_supported"]).to be(true)

      stub_request(:get, AgentAuthHelpers::AS_METADATA_URL).to_return(status: 500, body: "oops")
      failed = call("GET", mirror, app: stack(build_agent_auth, authorization_server_metadata: :proxy))
      expect(failed.status).to eq(503)
      expect(failed.headers["www-authenticate"]).to be_nil

      expect(seen.size).to eq(1)
      expect { stack(authorization_server_metadata: :other) }.to raise_error(ArgumentError)
    end
  end

  describe "challenges" do
    it "M5: answers a request with no Authorization header with the bare 401 challenge", :aggregate_failures do
      response = call("POST", "/mcp")

      expect(response.status).to eq(401)
      expect(response.headers["www-authenticate"]).to eq(bare_challenge)
      expect(response.headers["www-authenticate"]).not_to include("error")
      expect(response.headers["content-type"]).to eq("application/json")
      expect(json(response).keys).to contain_exactly("error", "error_description")
      expect(seen).to be_empty
    end

    it "M6: answers Authorization: Basic with 401 invalid_token", :aggregate_failures do
      response = call("POST", "/mcp", "HTTP_AUTHORIZATION" => "Basic dXNlcjpwYXNz")

      expect(response.status).to eq(401)
      expect(response.headers["www-authenticate"]).to match(invalid_token_challenge)
      expect(json(response)["error"]).to eq("invalid_token")
      expect(seen).to be_empty
    end

    it "M7: ignores a token in the query string or in a cookie", :aggregate_failures do
      # No introspection stub: a verification attempt would hit WebMock's net-connect guard.
      in_query = call("POST", "/mcp?access_token=#{token}")
      in_cookie = call("POST", "/mcp", "HTTP_COOKIE" => "access_token=#{token}; Authorization=Bearer #{token}")

      [in_query, in_cookie].each do |response|
        expect(response.status).to eq(401)
        expect(response.headers["www-authenticate"]).to eq(bare_challenge)
      end
      expect(a_request(:post, AgentAuthHelpers::INTROSPECT_URL)).not_to have_been_made
      expect(seen).to be_empty
    end
  end

  describe "token verification" do
    it "M8: calls the app with the auth context in the Rack env for a valid token", :aggregate_failures do
      stub_introspection

      response = call("POST", "/mcp", **bearer)

      expect(response.status).to eq(200)
      expect(response.body).to eq("downstream")
      expect(seen.size).to eq(1)
      auth = seen.first["kinde_sdk.agent_auth"]
      expect(auth).to be_a(KindeSdk::AgentAuth::AuthContext)
      expect(auth).to equal(seen.first[described_class::ENV_KEY])
      expect(auth.user_id).to eq("kp_user_1")
      expect(auth.permissions).to eq(["read:docs"])
      expect(auth.roles).to eq(["admin"])
      expect(auth.org_code).to eq("org_123")
      expect(auth.token).to eq(token)
    end

    it "M9: answers an inactive token, or one for another resource, with 401 invalid_token", :aggregate_failures do
      [{ "active" => false }, introspection_body("aud" => ["https://other.example.com/mcp"])].each do |verdict|
        stub_introspection(verdict)

        response = call("POST", "/mcp", **bearer)

        expect(response.status).to eq(401)
        expect(response.headers["www-authenticate"]).to match(invalid_token_challenge)
        expect(json(response)["error"]).to eq("invalid_token")
      end
      expect(seen).to be_empty
    end

    it "M10: answers a Kinde outage with 503 and no challenge, never 401", :aggregate_failures do
      outages = [
        -> { stub_introspection("oops", status: 500) },
        -> { stub_request(:post, AgentAuthHelpers::INTROSPECT_URL).to_timeout },
        -> { stub_request(:post, AgentAuthHelpers::INTROSPECT_URL).to_raise(Net::HTTPBadResponse) }
      ]

      outages.each do |arrange|
        arrange.call

        response = call("POST", "/mcp", **bearer)

        expect(response.status).to eq(503)
        expect(response.status).not_to eq(401)
        expect(response.headers["www-authenticate"]).to be_nil
        expect(response.headers["content-type"]).to eq("application/json")
        expect(json(response)["error"]).to eq("temporarily_unavailable")
      end
      expect(seen).to be_empty
    end

    it "M11: answers each local JWT failure with 401 invalid_token", :aggregate_failures do
      stub_jwks
      app = stack(jwt_kinde)
      bad_tokens = {
        "a bad signature" => sign_token(token_claims, key: AgentAuthHelpers::OTHER_RSA_KEY),
        "iss = scoped issuer" => sign_token(token_claims("iss" => AgentAuthHelpers::ISSUER)),
        "another aud" => sign_token(token_claims("aud" => ["https://other.example.com/mcp"])),
        "an expired token" => sign_token(token_claims("exp" => Time.now.to_i - 120))
      }

      bad_tokens.each do |name, bad_token|
        response = call("POST", "/mcp", app: app, **bearer(bad_token))

        expect(response.status).to eq(401), "#{name}: got #{response.status}"
        expect(response.headers["www-authenticate"]).to match(invalid_token_challenge)
      end
      expect(seen).to be_empty

      expect(call("POST", "/mcp", app: app, **bearer).status).to eq(200)
    end
  end

  describe "scope and permission guards in the app" do
    def guarded(agent_auth)
      lambda do |env|
        yield(env[described_class::ENV_KEY])
        [200, { "content-type" => "text/plain" }, ["allowed"]]
      end.then { |inner| stack(agent_auth, inner) }
    end

    it "M12: turns a missing scope into 403 insufficient_scope", :aggregate_failures do
      stub_introspection
      app = guarded(kinde) { |auth| kinde.require_scope(auth, "profile") }

      response = call("GET", "/mcp/profile", app: app, **bearer)

      expect(response.status).to eq(403)
      expect(response.headers["www-authenticate"]).to eq(
        %(Bearer error="insufficient_scope", scope="profile", resource_metadata="#{prm_url}")
      )
      expect(json(response)["error"]).to eq("insufficient_scope")

      allowed = guarded(kinde) { |auth| kinde.require_scope(auth, "offline") }
      expect(call("GET", "/mcp/profile", app: allowed, **bearer).status).to eq(200)
    end

    it "M13: turns a missing permission into a plain 403 with no challenge", :aggregate_failures do
      stub_introspection
      app = guarded(kinde) { |auth| kinde.require_permission(auth, "write:docs") }

      response = call("DELETE", "/mcp/docs/1", app: app, **bearer)

      expect(response.status).to eq(403)
      expect(response.headers).not_to have_key("www-authenticate")
      expect(response.headers["content-type"]).to eq("application/json")
      expect(json(response)).to include("error" => "forbidden")
      expect(response.body).not_to include("insufficient_scope")

      allowed = guarded(kinde) { |auth| kinde.require_permission(auth, "read:docs") }
      expect(call("GET", "/mcp/docs/1", app: allowed, **bearer).status).to eq(200)
    end

    it "M14: exposes WWW-Authenticate to browsers only when cors is on", :aggregate_failures do
      stub_introspection
      scope_guard = lambda do |env|
        kinde.require_scope(env[described_class::ENV_KEY], "profile")
        [200, {}, []]
      end

      with_cors = stack(kinde, scope_guard, cors: true)
      [call("POST", "/mcp", app: with_cors), call("POST", "/mcp", app: with_cors, **bearer)].each do |response|
        expect([401, 403]).to include(response.status)
        expect(response.headers["access-control-expose-headers"]).to eq("WWW-Authenticate")
        expect(response.headers["www-authenticate"]).to start_with("Bearer ")
      end

      without_cors = stack(kinde, scope_guard)
      [call("POST", "/mcp", app: without_cors), call("POST", "/mcp", app: without_cors, **bearer)].each do |response|
        expect([401, 403]).to include(response.status)
        expect(response.headers).not_to have_key("access-control-expose-headers")
      end
    end
  end

  describe "which paths are protected" do
    it "M15: protects the resource path and below, from SCRIPT_NAME + PATH_INFO", :aggregate_failures do
      outside = call("GET", "/health")
      expect(outside.status).to eq(200)
      expect(seen.last).not_to have_key(described_class::ENV_KEY)
      expect(call("GET", "/mcpx").status).to eq(200)

      expect(call("GET", "/mcp").status).to eq(401)
      expect(call("GET", "/mcp/messages").status).to eq(401)

      mounted = Rack::MockRequest.env_for("/messages", "SCRIPT_NAME" => "/mcp", method: "POST")
      expect(mounted["PATH_INFO"]).to eq("/messages")
      expect(stack.call(mounted).first).to eq(401)

      mounted_prm = Rack::MockRequest.env_for("/oauth-protected-resource/mcp", "SCRIPT_NAME" => "/.well-known")
      expect(stack.call(mounted_prm).first).to eq(200)

      root = build_agent_auth(resource_url: "https://api.example.com/")
      root_app = stack(root)
      expect(call("GET", "/", app: root_app).status).to eq(401)
      expect(call("GET", "/anything/at/all", app: root_app).status).to eq(401)
      expect(call("GET", "/.well-known/oauth-protected-resource", app: root_app).status).to eq(200)
      expect(call("OPTIONS", "/.well-known/oauth-protected-resource", app: root_app).status).to eq(204)
      expect(seen.size).to eq(2)
    end

    it "M19: never lets a request a Rails router sends to the resource handler through without a token", :aggregate_failures do
      handler = downstream
      routes = ActionDispatch::Routing::RouteSet.new
      routes.draw { post "/mcp", to: handler }
      app = stack(kinde, routes)
      # PATH_INFO as a server passes it on: MockRequest would read "//mcp" as a host name.
      post = lambda do |path, **env|
        Rack::MockResponse.new(*app.call(Rack::MockRequest.env_for("/", method: "POST", "PATH_INFO" => path, **env)))
      end

      # Every one of these reaches the handler of the "/mcp" route when nothing stands in front of it.
      routed = ["/mcp", "/mcp.json", "/mcp.x", "/mcp/", "/mcp.json/", "//mcp", "///mcp.json", "/mcp//"]
      routed.each do |path|
        unprotected = Rack::MockRequest.env_for("/", method: "POST", "PATH_INFO" => path)
        expect(routes.call(unprotected).first).to eq(200), "expected the router to match #{path}"
      end
      seen.clear

      routed.each do |path|
        response = post.call(path)

        expect(response.status).to eq(401), "#{path}: got #{response.status} without a token"
        expect(response.headers["www-authenticate"]).to eq(bare_challenge)
      end
      expect(seen).to be_empty

      stub_introspection
      routed.each do |path|
        expect(post.call(path, **bearer).status).to eq(200), "#{path}: a valid token was not let through"
      end
      expect(seen.size).to eq(routed.size)
      expect(seen.map { |env| env[described_class::ENV_KEY] }).to all(be_a(KindeSdk::AgentAuth::AuthContext))

      # Paths outside the resource still pass the middleware untouched (here the router has no route for them).
      ["/mcpx", "/mcp_x", "/mcp1", "/health"].each do |path|
        response = post.call(path)

        expect(response.status).to eq(404), "#{path}: got #{response.status}"
        expect(response.headers).not_to have_key("www-authenticate")
      end

      # A sibling such as /mcp-other needs a token as well: a mount at /mcp would take it (M20).
      expect(post.call("/mcp-other").status).to eq(401)
    end

    it "M20: never lets a request a Rails mount sends to the resource handler through without a token", :aggregate_failures do
      nested = build_agent_auth(resource_url: "https://api.example.com/v1/tools/mcp")

      { "/mcp" => kinde, "/v1/tools/mcp" => nested }.each do |base, agent_auth|
        handler = downstream
        routes = ActionDispatch::Routing::RouteSet.new
        routes.draw { mount handler, at: base }
        app = stack(agent_auth, routes)
        env_for = ->(path, **env) { Rack::MockRequest.env_for("/", method: "POST", "PATH_INFO" => path, **env) }
        post = ->(path, **env) { Rack::MockResponse.new(*app.call(env_for.call(path, **env))) }

        # A mount matches up to a word boundary: every one of these reaches the mounted handler
        # when nothing stands in front of it.
        tails = ["", "/", "/messages", ".json", "-other", ";x", "~", "%20", "%2Ejson", "%2Fmessages", ":x", "+", "!", "@x", "=1", "\n"]
        routed = tails.map { |tail| "#{base}#{tail}" } + ["/#{base}-other"]
        routed.each do |path|
          expect(routes.call(env_for.call(path)).first).to eq(200), "expected the router to match #{path.inspect}"
        end
        seen.clear

        routed.each do |path|
          response = post.call(path)

          expect(response.status).to eq(401), "#{path.inspect}: got #{response.status} without a token"
          expect(response.headers["www-authenticate"]).to eq(agent_auth.challenge)
        end
        expect(seen).to be_empty

        stub_introspection(introspection_body("aud" => [agent_auth.config.resource_url]))
        routed.each do |path|
          expect(post.call(path, **bearer).status).to eq(200), "#{path.inspect}: a valid token was not let through"
        end
        expect(seen.size).to eq(routed.size)
        expect(seen.map { |env| env[described_class::ENV_KEY] }).to all(be_a(KindeSdk::AgentAuth::AuthContext))
        expect(seen.map { |env| env["SCRIPT_NAME"] }).to all(eq(base))
        seen.clear

        # A letter, a digit or an underscore right after the resource path is another path: the
        # mount does not take it, and the middleware leaves it alone.
        ["#{base}x", "#{base}_x", "#{base}1", "/health"].each do |path|
          response = post.call(path)

          expect(response.status).to eq(404), "#{path}: got #{response.status}"
          expect(response.headers).not_to have_key("www-authenticate")
        end
        expect(seen).to be_empty
      end
    end

    it "M21: whatever follows the resource path, nothing a Rails router sends to the handler arrives without an auth context", :aggregate_failures do
      stub_jwks
      # Every byte that can follow the resource path, every pair from a sample of bytes, and a few longer tails.
      sample = ["/", ".", "-", ";", "~", "%", " ", "\n", "\0", "x", "Z", "_", "7", "\xC3", "\xA9"]
      tails = [""] + (0..255).map(&:chr) + sample.product(sample).map(&:join) + [".json", "%20", "%2Ejson", "%2Fx", "%78", "/.."]

      # Resource URL, the spellings of its path that Rails reads as the same path, the route, and
      # how many of the generated paths that route must at least send to the handler.
      shapes = {
        'post "/mcp"' => ["https://api.example.com/mcp", ["/mcp", "//mcp"], ->(to) { post "/mcp", to: to }, 50],
        'mount at "/mcp"' => ["https://api.example.com/mcp", ["/mcp", "//mcp"], ->(to) { mount to, at: "/mcp" }, 1000],
        'post "/v1/tools/mcp"' => [
          "https://api.example.com/v1/tools/mcp", ["/v1/tools/mcp", "/v1//tools/mcp"], ->(to) { post "/v1/tools/mcp", to: to }, 50
        ],
        'mount at "/v1/tools/mcp"' => [
          "https://api.example.com/v1/tools/mcp", ["/v1/tools/mcp", "/v1//tools/mcp"], ->(to) { mount to, at: "/v1/tools/mcp" }, 1000
        ],
        # Percent-escapes in the resource path: Rails upper-cases their hex digits before it routes.
        'post "/caf%C3%A9s"' => [
          "https://api.example.com/caf%C3%A9s", ["/caf%C3%A9s", "/caf%c3%a9s", "/caf%c3%A9s"], ->(to) { post "/caf\u00E9s", to: to }, 75
        ],
        'mount at "/caf%C3%A9s"' => [
          "https://api.example.com/caf%C3%A9s", ["/caf%C3%A9s", "/caf%c3%a9s", "/caf%c3%A9s"], ->(to) { mount to, at: "/caf\u00E9s" }, 1500
        ],
        # A resource path that ends in a character with no word boundary after it.
        'mount at "/mcp-"' => ["https://api.example.com/mcp-", ["/mcp-"], ->(to) { mount to, at: "/mcp-" }, 250]
      }

      shapes.each do |name, (resource_url, spellings, draw, at_least)|
        agent_auth = build_agent_auth(resource_url: resource_url, verification: "jwt")
        valid = bearer(sign_token(token_claims("aud" => [resource_url])))
        reached = []
        handler = lambda do |env|
          reached << env[described_class::ENV_KEY]
          [200, { "content-type" => "text/plain" }, ["handler"]]
        end
        routes = ActionDispatch::Routing::RouteSet.new
        routes.draw { instance_exec(handler, &draw) }
        # Rails raises for a path, or a format suffix, that is not valid UTF-8; here that is a 400.
        router = lambda do |env|
          routes.call(env)
        rescue ArgumentError, ActionController::BadRequest
          [400, {}, []]
        end
        app = stack(agent_auth, router)
        request = ->(target, path, **env) { target.call(Rack::MockRequest.env_for("/", method: "POST", "PATH_INFO" => path, **env)) }
        # PATH_INFO both ways a server may tag it: as UTF-8 and as binary.
        paths = spellings.product(tails, [Encoding::UTF_8, Encoding::BINARY]).map do |spelling, tail, encoding|
          (spelling.b + tail.b).force_encoding(encoding)
        end

        routed = paths.select do |path|
          reached.clear
          request.call(router, path)
          !reached.empty?
        end
        expect(routed.size).to be >= at_least,"#{name}: the router sent only #{routed.size} of #{paths.size} paths to the handler"

        # Without a token no request reaches the handler, whatever the path.
        reached.clear
        answers = paths.to_h { |path| [path, request.call(app, path).first] }
        expect(reached.size).to eq(0), "#{name}: #{reached.size} requests reached the handler without a token"
        open = routed.reject { |path| answers[path] == 401 }
        expect(open).to be_empty, "#{name}: no 401 for #{open.first(5).inspect}"

        # With a valid token each of them arrives, and with the auth context.
        routed.each { |path| request.call(app, path, **valid) }
        expect(reached.size).to eq(routed.size), "#{name}: #{reached.size} of #{routed.size} arrived with a valid token"
        expect(reached).to all(be_a(KindeSdk::AgentAuth::AuthContext))
      end
    end
  end

  describe "CORS preflight on a protected path" do
    # The whole answer: nothing in it comes from the request.
    let(:preflight_headers) do
      {
        "access-control-allow-origin" => "*",
        "access-control-allow-methods" => "GET, HEAD, POST, PUT, PATCH, DELETE, OPTIONS",
        "access-control-allow-headers" =>
          "Authorization, Content-Type, Accept, Mcp-Session-Id, Mcp-Protocol-Version, Last-Event-ID, *",
        "vary" => "Origin, Access-Control-Request-Method"
      }
    end
    let(:cors_headers) do
      %w[
        access-control-allow-origin access-control-allow-methods access-control-allow-headers
        access-control-expose-headers access-control-allow-credentials vary
      ]
    end

    # The headers a browser sends with the preflight for a request that carries a bearer token.
    def preflight(request_method = "POST", origin: "https://inspector.example.com", **env)
      {
        "HTTP_ORIGIN" => origin,
        "HTTP_ACCESS_CONTROL_REQUEST_METHOD" => request_method,
        "HTTP_ACCESS_CONTROL_REQUEST_HEADERS" => "authorization,content-type,mcp-protocol-version"
      }.merge(env)
    end

    # The Rack response as the middleware returns it, and the env it was given.
    def raw(app, method, path, env = {})
      rack_env = Rack::MockRequest.env_for("/", { method: method, "PATH_INFO" => path }.merge(env))
      [app.call(rack_env), rack_env]
    end

    it "M22: with cors on, answers a preflight on the resource path and below without a token", :aggregate_failures do
      app = stack(cors: true)

      ["/mcp", "/mcp/messages", "/mcp/a/b", "/mcp.json", "//mcp"].each do |path|
        (status, headers, body), env = raw(app, "OPTIONS", path, preflight)

        expect(status).to eq(204), "#{path}: got #{status}"
        expect(headers).to eq(preflight_headers)
        expect(body).to eq([])
        expect(env).not_to have_key(described_class::ENV_KEY)
      end

      allowed_headers = preflight_headers["access-control-allow-headers"].split(", ").map(&:downcase)
      expect(allowed_headers).to include(
        "authorization", "content-type", "accept", "mcp-session-id", "mcp-protocol-version", "last-event-id"
      )

      # Whatever method the browser asks for, and even with an Authorization header (no
      # introspection stub: a verification attempt would hit WebMock's net-connect guard).
      %w[GET HEAD POST PUT PATCH DELETE].each do |method|
        response = call("OPTIONS", "/mcp", app: app, **preflight(method), **bearer)

        expect(response.status).to eq(204)
        expect(response.body).to eq("")
        expect(response.headers["access-control-allow-methods"].split(", ")).to include(method)
        expect(response.headers["access-control-allow-origin"]).to eq("*")
        expect(response.headers).not_to have_key("access-control-allow-credentials")
        expect(response.headers).not_to have_key("www-authenticate")
      end

      expect(seen).to be_empty
      expect(WebMock).not_to have_requested(:any, /.*/)
    end

    it "M23: answers the preflight for a nested and a root Resource URL, after the metadata routes", :aggregate_failures do
      well_known = "/.well-known/oauth-protected-resource"
      mirror = "/.well-known/oauth-authorization-server"
      metadata_preflight = lambda do |app, path|
        response = call("OPTIONS", path, app: app, **preflight("GET"))

        expect(response.status).to eq(204), "#{path}: got #{response.status}"
        expect(response.headers["access-control-allow-methods"]).to eq("GET, OPTIONS"), "#{path} was not answered as a metadata route"
        expect(call("GET", path, app: app).status).to eq(200)
      end

      nested = stack(build_agent_auth(resource_url: "https://api.example.com/v1/tools/mcp"), cors: true)
      ["/v1/tools/mcp", "/v1/tools/mcp/messages"].each do |path|
        (status, headers, body), = raw(nested, "OPTIONS", path, preflight)
        expect([status, headers, body]).to eq([204, preflight_headers, []]), path
      end
      expect(seen).to be_empty
      [well_known, "#{well_known}/v1/tools/mcp"].each { |path| metadata_preflight.call(nested, path) }
      expect(call("OPTIONS", "/v1/tools", app: nested, **preflight).body).to eq("downstream")
      expect(seen.size).to eq(1)
      seen.clear

      root = stack(build_agent_auth(resource_url: "https://api.example.com/"), authorization_server_metadata: :static, cors: true)
      ["/", "/anything/at/all", "/.well-known/other"].each do |path|
        (status, headers, body), = raw(root, "OPTIONS", path, preflight)
        expect([status, headers, body]).to eq([204, preflight_headers, []]), path
      end
      [well_known, mirror].each { |path| metadata_preflight.call(root, path) }
      expect(call("GET", "/", app: root).status).to eq(401)

      expect(seen).to be_empty
      expect(WebMock).not_to have_requested(:any, /.*/)
    end

    it "M24: with cors on, a request that is not a preflight still needs a token", :aggregate_failures do
      app = stack(cors: true)
      not_preflights = {
        "no CORS header" => {},
        "no Origin" => preflight.reject { |name, _| name == "HTTP_ORIGIN" },
        "no Access-Control-Request-Method" => preflight.reject { |name, _| name == "HTTP_ACCESS_CONTROL_REQUEST_METHOD" },
        "an empty Origin" => preflight(origin: ""),
        "an empty Access-Control-Request-Method" => preflight(""),
        "only Access-Control-Request-Headers" => { "HTTP_ACCESS_CONTROL_REQUEST_HEADERS" => "authorization" }
      }

      not_preflights.each do |name, env|
        response = call("OPTIONS", "/mcp", app: app, **env)

        expect(response.status).to eq(401), "OPTIONS with #{name}: got #{response.status}"
        expect(response.headers["www-authenticate"]).to eq(bare_challenge)
        expect(response.headers).not_to have_key("access-control-allow-methods")
        expect(response.headers).not_to have_key("access-control-allow-headers")
      end

      # The preflight's headers on any other method do not make it a preflight.
      %w[GET HEAD POST PUT PATCH DELETE].each do |method|
        response = call(method, "/mcp", app: app, **preflight(method))

        expect(response.status).to eq(401), "#{method}: got #{response.status}"
        expect(response.headers).not_to have_key("access-control-allow-methods")
      end
      expect(seen).to be_empty

      stub_introspection
      not_preflights.each_value do |env|
        expect(call("OPTIONS", "/mcp", app: app, **env, **bearer).status).to eq(200)
      end
      expect(seen.size).to eq(not_preflights.size)
      expect(seen.map { |env| env[described_class::ENV_KEY] }).to all(be_a(KindeSdk::AgentAuth::AuthContext))
    end

    it "M25: with cors off, a preflight is a request without a token", :aggregate_failures do
      [stack, stack(cors: false)].each do |app|
        ["/mcp", "/mcp/messages"].each do |path|
          response = call("OPTIONS", path, app: app, **preflight)

          expect(response.status).to eq(401)
          expect(response.headers["www-authenticate"]).to eq(bare_challenge)
          cors_headers.each { |name| expect(response.headers).not_to have_key(name) }
        end
      end
      expect(seen).to be_empty
    end

    it "M26: leaves a preflight outside the resource path to the app", :aggregate_failures do
      app = stack(cors: true)
      outside = ["/health", "/mcpx", "/mcp_x", "/mcp1", "/", "/other/mcp"]

      outside.each do |path|
        (status, headers, body), env = raw(app, "OPTIONS", path, preflight)

        expect(status).to eq(200), "#{path}: got #{status}"
        expect(headers).to eq("content-type" => "text/plain")
        expect(body).to eq(["downstream"])
        expect(env).not_to have_key(described_class::ENV_KEY)
      end
      expect(seen.size).to eq(outside.size)
    end

    it "M27: puts nothing from the preflight's headers into the answer", :aggregate_failures do
      linted = Rack::Lint.new(stack(cors: true))
      hostile = [
        "x\r\nset-cookie: session=stolen",
        "x\nx-injected: 1",
        "authorization\r\n\r\n<html>",
        "https://evil.example.com\r\naccess-control-allow-credentials: true",
        "x" * 100_000,
        %(a b, (c); "d" <e> {f}),
        "*",
        "null",
        "\0",
        "café",
        "\xFF\xFE".b,
        "\xFF\xFE".dup.force_encoding(Encoding::UTF_8)
      ]

      plain = stack(cors: true)

      hostile.product(%w[HTTP_ORIGIN HTTP_ACCESS_CONTROL_REQUEST_METHOD HTTP_ACCESS_CONTROL_REQUEST_HEADERS]).each do |value, name|
        # Under Rack::Lint the value is binary, as a server passes it on (Lint refuses any other
        # env); without Lint it also goes in as given, tagged UTF-8.
        [call("OPTIONS", "/mcp", app: linted, **preflight, name => value.b),
         call("OPTIONS", "/mcp", app: plain, **preflight, name => value)].each do |response|
          expect(response.status).to eq(204), "#{name}=#{value[0, 30].inspect}: got #{response.status}"
          expect(response.headers.to_h).to eq(preflight_headers)
          expect(response.body).to eq("")
        end
      end
      expect(seen).to be_empty
      expect(WebMock).not_to have_requested(:any, /.*/)
    end

    it "M28: with cors on, a browser can read the answers the middleware writes after the preflight", :aggregate_failures do
      guard = lambda do |env|
        auth = env[described_class::ENV_KEY]
        kinde.require_scope(auth, "profile") if env["PATH_INFO"].end_with?("/scope")
        kinde.require_permission(auth, "write:docs") if env["PATH_INFO"].end_with?("/write")
        [200, { "content-type" => "text/plain" }, ["ok"]]
      end
      app = stack(kinde, guard, cors: true)
      origin = { "HTTP_ORIGIN" => "https://inspector.example.com" }

      # The preflight says "go ahead"; the request it announced still needs the token.
      expect(call("OPTIONS", "/mcp", app: app, **preflight).status).to eq(204)
      challenge = call("POST", "/mcp", app: app, **origin)
      expect(challenge.status).to eq(401)
      expect(challenge.headers["www-authenticate"]).to eq(bare_challenge)
      expect(challenge.headers["access-control-allow-origin"]).to eq("*")
      expect(challenge.headers["access-control-expose-headers"]).to eq("WWW-Authenticate")

      stub_introspection
      written = [
        [401, call("POST", "/mcp", app: app, **origin, "HTTP_AUTHORIZATION" => "Basic eA==")],
        [403, call("POST", "/mcp/scope", app: app, **origin, **bearer)],
        [403, call("POST", "/mcp/write", app: app, **origin, **bearer)]
      ]
      stub_introspection("oops", status: 500)
      written << [503, call("POST", "/mcp", app: app, **origin, **bearer)]

      written.each do |status, response|
        expect(response.status).to eq(status)
        expect(response.headers["access-control-allow-origin"]).to eq("*"), "no access-control-allow-origin on the #{status}"
        expect(response.headers["access-control-expose-headers"]).to eq("WWW-Authenticate")
        expect(response.headers).not_to have_key("access-control-allow-credentials")
      end

      # The application's own answer is the application's: the middleware adds nothing to it.
      stub_introspection
      (status, headers, body), = raw(app, "POST", "/mcp", origin.merge(bearer))
      expect([status, headers, body]).to eq([200, { "content-type" => "text/plain" }, ["ok"]])
    end
  end

  describe "Rack compliance" do
    it "M16: returns responses that pass Rack::Lint", :aggregate_failures do
      stub_introspection
      guard = lambda do |env|
        kinde.require_permission(env[described_class::ENV_KEY], "write:docs") if env["PATH_INFO"].end_with?("/write")
        [200, { "content-type" => "text/plain" }, ["ok"]]
      end
      linted = Rack::Lint.new(stack(kinde, guard))

      expect(call("GET", "/mcp", app: linted, **bearer).status).to eq(200)
      expect(call("GET", prm_path, app: linted).status).to eq(200)
      expect(call("OPTIONS", prm_path, app: linted).status).to eq(204)
      expect(call("GET", "/mcp", app: linted).status).to eq(401)
      expect(call("GET", "/mcp", app: linted, "HTTP_AUTHORIZATION" => "Basic eA==").status).to eq(401)
      expect(call("POST", "/mcp/write", app: linted, **bearer).status).to eq(403)

      stub_introspection("oops", status: 500)
      expect(call("GET", "/mcp", app: linted, **bearer).status).to eq(503)

      # With cors on: the preflight answer and the answers that carry the CORS headers.
      stub_introspection
      cors_linted = Rack::Lint.new(stack(kinde, guard, cors: true))
      preflight = { "HTTP_ORIGIN" => "https://inspector.example.com", "HTTP_ACCESS_CONTROL_REQUEST_METHOD" => "POST" }
      expect(call("OPTIONS", "/mcp", app: cors_linted, **preflight).status).to eq(204)
      expect(call("OPTIONS", "/mcp/write", app: cors_linted, **preflight).status).to eq(204)
      expect(call("OPTIONS", "/mcp", app: cors_linted).status).to eq(401)
      expect(call("POST", "/mcp", app: cors_linted).status).to eq(401)
      expect(call("POST", "/mcp/write", app: cors_linted, **bearer).status).to eq(403)
      expect(call("POST", "/mcp", app: cors_linted, **bearer).status).to eq(200)
    end
  end

  describe "README example" do
    it "M17: the Rack example from the README serves the metadata, challenges and reports a missing permission", :aggregate_failures do
      stub_readme_environment
      app = Rack::Builder.new_from_string(readme_ruby_example(/^use KindeSdk::AgentAuth::Middleware/), "README.md")

      prm = call("GET", prm_path, app: app)
      expect(prm.status).to eq(200)
      expect(json(prm)["authorization_servers"]).to eq([AgentAuthHelpers::ISSUER])
      expect(json(prm)["scopes_supported"]).to include("offline")

      challenge = call("POST", "/mcp", app: app)
      expect(challenge.status).to eq(401)
      expect(challenge.headers["www-authenticate"]).to eq(bare_challenge)

      stub_introspection
      without_permission = sign_token(token_claims("permissions" => ["other:thing"]))
      denied = call("POST", "/mcp", app: app, **bearer(without_permission))
      expect(denied.status).to eq(200)
      expect(json(denied)).to include("isError" => true)

      granted = call("POST", "/mcp", app: app, **bearer)
      expect(granted.status).to eq(200)
      expect(json(granted)).not_to have_key("isError")
    end
  end

  describe "secrets" do
    it "M18: never echoes a rejected token in the challenge or the body", :aggregate_failures do
      marker = "MARKER-do-not-echo-9f3a"
      stub_introspection({ "active" => false })
      stub_jwks

      responses = [
        call("POST", "/mcp", **bearer(marker)),
        call("POST", "/mcp", **bearer(sign_token(token_claims("sub" => marker)))),
        call("POST", "/mcp", "HTTP_AUTHORIZATION" => "Basic #{marker}"),
        call("POST", "/mcp", "HTTP_AUTHORIZATION" => "Bearer #{marker} #{marker}"),
        call("POST", "/mcp", app: stack(jwt_kinde), **bearer(marker)),
        call("POST", "/mcp", app: stack(jwt_kinde), **bearer(sign_token(token_claims("iss" => marker), kid: marker)))
      ]

      responses.each do |response|
        expect(response.status).to eq(401)
        expect(response.headers["www-authenticate"]).to match(invalid_token_challenge)
        expect(response.headers.to_s).not_to include(marker)
        expect(response.body).not_to include(marker)
        expect(response.body).not_to include("app_secret")
      end
    end
  end
end
