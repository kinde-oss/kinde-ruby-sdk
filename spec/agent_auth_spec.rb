require 'spec_helper'
require 'base64'
require_relative 'support/agent_auth_helpers'

# Core of the resource-server helpers for "AI agents and MCP" applications.
# Case ids C1-C60 are the ones in the approved plan; C61-C65 were added in
# fix round 1, C66 and C67 in fix round 2, C68 in fix round 3, C69-C75 after
# the review of the pull request.
RSpec.describe KindeSdk::AgentAuth do
  include AgentAuthHelpers

  let(:kinde) { build_agent_auth }
  let(:jwt_kinde) { build_agent_auth(verification: "jwt") }
  let(:token) { sign_token }

  let(:missing_token_error) { KindeSdk::AgentAuth::MissingTokenError }
  let(:invalid_token_error) { KindeSdk::AgentAuth::InvalidTokenError }
  let(:insufficient_scope_error) { KindeSdk::AgentAuth::InsufficientScopeError }
  let(:permission_denied_error) { KindeSdk::AgentAuth::PermissionDeniedError }
  let(:unavailable_error) { KindeSdk::AgentAuth::UnavailableError }

  describe "configuration" do
    it "C1: raises ArgumentError when a required value is missing or blank", :aggregate_failures do
      %i[client_id client_secret resource_url domain].each do |name|
        [nil, "", "   "].each do |blank|
          expect { build_agent_auth(name => blank) }
            .to raise_error(ArgumentError, /#{name}/), "expected #{name}=#{blank.inspect} to be refused"
        end
      end
    end

    it "C2: defaults domain to the SDK's configured domain but never uses the login client id", :aggregate_failures do
      login_config = KindeSdk::Configuration.new do |c|
        c.domain = "https://login.kinde.com"
        c.client_id = "login_client_id"
        c.client_secret = "login_client_secret"
      end
      allow(KindeSdk).to receive(:config).and_return(login_config)

      agent_auth = described_class.new(client_id: "app_id", client_secret: "app_secret", resource_url: AgentAuthHelpers::RESOURCE_URL)
      expect(agent_auth.config.domain).to eq("https://login.kinde.com")
      expect(agent_auth.config.client_id).to eq("app_id")
      expect(agent_auth.config.issuer).not_to include("login_client_id")

      expect { described_class.new(client_secret: "app_secret", resource_url: AgentAuthHelpers::RESOURCE_URL) }
        .to raise_error(ArgumentError, /client_id/)
    end

    it "C3: uses the documented defaults", :aggregate_failures do
      config = kinde.config

      expect(config.verification).to eq("introspection")
      expect(config.scopes_supported).to eq(["offline"])
      expect(config.clock_tolerance_seconds).to eq(30)
      expect(config.resource_name).to be_nil
    end

    it "C4: normalises the domain to https://host and refuses other schemes", :aggregate_failures do
      ["yourbiz.kinde.com", "https://yourbiz.kinde.com/", "https://yourbiz.kinde.com/x", "  https://yourbiz.kinde.com  "].each do |domain|
        expect(build_agent_auth(domain: domain).config.domain).to eq("https://yourbiz.kinde.com")
      end
      expect(build_agent_auth(domain: "https://auth.example.com:8443/").config.domain).to eq("https://auth.example.com:8443")

      # Host names are case-insensitive and Kinde's iss is lower case; the Resource URL is never touched.
      mixed_case = build_agent_auth(domain: "https://YourBiz.Kinde.com", resource_url: "https://API.Example.com/MCP").config
      expect(mixed_case.domain).to eq("https://yourbiz.kinde.com")
      expect(mixed_case.issuer).to eq("https://yourbiz.kinde.com/oauth2/agents/app_id")
      expect(mixed_case.resource_url).to eq("https://API.Example.com/MCP")
      expect(build_agent_auth(domain: "YOURBIZ.KINDE.COM/").config.domain).to eq("https://yourbiz.kinde.com")

      expect { build_agent_auth(domain: "http://yourbiz.kinde.com") }.to raise_error(ArgumentError, /https/)
      expect { build_agent_auth(domain: "ftp://yourbiz.kinde.com") }.to raise_error(ArgumentError, /https/)
    end

    it "C5: accepts the three verification modes (also as symbols) and refuses anything else", :aggregate_failures do
      expect(build_agent_auth(verification: :jwt).config.verification).to eq("jwt")
      expect(build_agent_auth(verification: "jwt+introspection").config.verification).to eq("jwt+introspection")
      expect(build_agent_auth(verification: :introspection).config.verification).to eq("introspection")

      expect { build_agent_auth(verification: "local") }.to raise_error(ArgumentError, /verification/)
      expect { build_agent_auth(clock_tolerance_seconds: -1) }.to raise_error(ArgumentError, /clock_tolerance_seconds/)
    end

    it "C65: refuses a client_id that cannot be one segment of a URL path", :aggregate_failures do
      ["abc123\n", "app id", " abc123", "abc\t123", "abc/123", "abc?x", "abc#x", "abc%20", "abc\u00e9"].each do |client_id|
        expect { build_agent_auth(client_id: client_id) }
          .to raise_error(ArgumentError, /client_id/), "expected client_id=#{client_id.inspect} to be refused"
      end

      expect(build_agent_auth(client_id: "app:id+1").config.client_id).to eq("app:id+1")
      expect(build_agent_auth(client_id: "0a1B2c-3d_4e.5f~").config.issuer)
        .to eq("https://yourbiz.kinde.com/oauth2/agents/0a1B2c-3d_4e.5f~")
    end

    it "C6: derives every URL from the domain, the client id and the Resource URL", :aggregate_failures do
      config = build_agent_auth(resource_url: "https://api.example.com/mcp").config

      expect(config.issuer).to eq("https://yourbiz.kinde.com/oauth2/agents/app_id")
      expect(config.as_metadata_url).to eq("https://yourbiz.kinde.com/.well-known/oauth-authorization-server/oauth2/agents/app_id")
      expect(config.jwks_url).to eq("https://yourbiz.kinde.com/.well-known/jwks")
      expect(config.introspect_url).to eq("https://yourbiz.kinde.com/oauth2/agents/app_id/introspect")
      expect(config.revoke_url).to eq("https://yourbiz.kinde.com/oauth2/agents/app_id/revoke")
      expect(config.prm_path).to eq("/.well-known/oauth-protected-resource/mcp")
      expect(config.prm_url).to eq("https://api.example.com/.well-known/oauth-protected-resource/mcp")
      expect(config.resource_url).to eq("https://api.example.com/mcp")
    end

    it "C7: builds the metadata path for a root resource, a port and a nested path", :aggregate_failures do
      root = build_agent_auth(resource_url: "https://api.example.com/").config
      expect(root.prm_path).to eq("/.well-known/oauth-protected-resource")
      expect(root.prm_url).to eq("https://api.example.com/.well-known/oauth-protected-resource")

      bare = build_agent_auth(resource_url: "https://api.example.com").config
      expect(bare.prm_path).to eq("/.well-known/oauth-protected-resource")
      expect(bare.resource_url).to eq("https://api.example.com")

      port = build_agent_auth(resource_url: "http://localhost:3001/mcp").config
      expect(port.prm_url).to eq("http://localhost:3001/.well-known/oauth-protected-resource/mcp")

      nested = build_agent_auth(resource_url: "https://api.example.com/v1/tools/mcp").config
      expect(nested.prm_path).to eq("/.well-known/oauth-protected-resource/v1/tools/mcp")
      expect(nested.prm_url).to eq("https://api.example.com/.well-known/oauth-protected-resource/v1/tools/mcp")
    end

    it "C72: keeps the query of the Resource URL in the metadata URL and matches requests by path", :aggregate_failures do
      with_query = build_agent_auth(resource_url: "https://api.example.com/mcp?tenant=docs")
      config = with_query.config
      url = "https://api.example.com/.well-known/oauth-protected-resource/mcp?tenant=docs"

      expect(config.prm_url).to eq(url)
      expect(config.prm_path).to eq("/.well-known/oauth-protected-resource/mcp")
      expect(config.resource_path).to eq("/mcp")
      expect(with_query.challenge).to eq(%(Bearer resource_metadata="#{url}"))

      status, _headers, body = with_query.metadata_response("GET", config.prm_path)
      expect(status).to eq(200)
      expect(JSON.parse(body)["resource"]).to eq("https://api.example.com/mcp?tenant=docs")

      root = build_agent_auth(resource_url: "https://api.example.com/?tenant=docs").config
      expect(root.prm_path).to eq("/.well-known/oauth-protected-resource")
      expect(root.prm_url).to eq("https://api.example.com/.well-known/oauth-protected-resource?tenant=docs")
    end

    it "C71: copies the strings it is given instead of freezing the caller's", :aggregate_failures do
      mode = +"jwt"
      scopes = [+"offline", +"profile"]
      name = +"Docs"
      config = build_agent_auth(verification: mode, scopes_supported: scopes, resource_name: name).config

      expect([mode, scopes, scopes[0], scopes[1], name]).to all(satisfy { |value| !value.frozen? })
      mode << "+introspection"
      scopes[1] << "x"
      scopes << "email"
      name << "!"

      expect(config.verification).to eq("jwt")
      expect(config.scopes_supported).to eq(%w[offline profile])
      expect(config.resource_name).to eq("Docs")
      expect(config.verification).to be_frozen
      expect(config.scopes_supported).to be_frozen.and all(be_frozen)
    end

    it "C8: always advertises the offline scope", :aggregate_failures do
      expect(build_agent_auth(scopes_supported: %w[profile email]).config.scopes_supported).to eq(%w[profile email offline])
      expect(build_agent_auth(scopes_supported: %w[offline profile]).config.scopes_supported).to eq(%w[offline profile])
      expect(build_agent_auth(scopes_supported: []).config.scopes_supported).to eq(["offline"])
    end

    it "C9: keeps the client secret out of inspect", :aggregate_failures do
      agent_auth = build_agent_auth(client_secret: "super-secret-value")

      expect(agent_auth.config.inspect).not_to include("super-secret-value")
      expect(agent_auth.inspect).not_to include("super-secret-value")
      expect(agent_auth.to_s).not_to include("super-secret-value")
      expect(agent_auth.config.inspect).to include("[REDACTED]")
    end
  end

  describe "metadata" do
    it "C10: builds the protected resource metadata with the scoped issuer and offline", :aggregate_failures do
      document = build_agent_auth(resource_name: "Docs MCP").protected_resource_metadata

      expect(document).to eq(
        "resource" => "https://api.example.com/mcp",
        "authorization_servers" => ["https://yourbiz.kinde.com/oauth2/agents/app_id"],
        "bearer_methods_supported" => ["header"],
        "scopes_supported" => ["offline"],
        "resource_name" => "Docs MCP"
      )
      expect(document["authorization_servers"]).not_to include(AgentAuthHelpers::DOMAIN)
      expect(document["scopes_supported"]).to include("offline")
    end

    it "C11: leaves resource_name out when it is not configured" do
      expect(kinde.protected_resource_metadata).not_to have_key("resource_name")
    end

    it "C12: builds the static authorization server mirror from the derived URLs", :aggregate_failures do
      document = kinde.authorization_server_metadata(:static)
      issuer = AgentAuthHelpers::ISSUER

      expect(document).to eq(
        "issuer" => issuer,
        "authorization_endpoint" => "#{issuer}/authorize",
        "token_endpoint" => "#{issuer}/token",
        "registration_endpoint" => "#{issuer}/register",
        "introspection_endpoint" => "#{issuer}/introspect",
        "revocation_endpoint" => "#{issuer}/revoke",
        "jwks_uri" => "https://yourbiz.kinde.com/.well-known/jwks",
        "response_types_supported" => ["code"],
        "grant_types_supported" => %w[authorization_code refresh_token],
        "token_endpoint_auth_methods_supported" => %w[client_secret_post none],
        "code_challenge_methods_supported" => ["S256"],
        "scopes_supported" => %w[offline profile email],
        "subject_types_supported" => ["public"],
        "resource_indicators_supported" => true,
        "client_id_metadata_document_supported" => true
      )
      expect { kinde.authorization_server_metadata(:other) }.to raise_error(ArgumentError)
    end

    it "C13: proxies Kinde's document unchanged, caches it for 5 minutes and reports an outage", :aggregate_failures do
      upstream = {
        "issuer" => AgentAuthHelpers::ISSUER,
        "token_endpoint" => "#{AgentAuthHelpers::ISSUER}/token",
        "client_id_metadata_document_supported" => true,
        "a_field_kinde_adds_later" => { "nested" => [1, 2] }
      }
      stub_request(:get, AgentAuthHelpers::AS_METADATA_URL).to_return(status: 200, body: upstream.to_json)

      expect(kinde.authorization_server_metadata(:proxy)).to eq(upstream)
      expect(kinde.authorization_server_metadata).to eq(upstream)
      expect(kinde.authorization_server_metadata["client_id_metadata_document_supported"]).to be(true)
      expect(a_request(:get, AgentAuthHelpers::AS_METADATA_URL)).to have_been_made.once

      clock = AgentAuthHelpers::FakeClock.new
      metadata = KindeSdk::AgentAuth::Metadata.new(kinde.config, clock: clock)
      metadata.authorization_server_metadata(:proxy)
      clock.advance(299)
      metadata.authorization_server_metadata(:proxy)
      expect(a_request(:get, AgentAuthHelpers::AS_METADATA_URL)).to have_been_made.times(2)
      clock.advance(2) # 301 seconds after the fetch
      expect(metadata.authorization_server_metadata(:proxy)).to eq(upstream)
      expect(a_request(:get, AgentAuthHelpers::AS_METADATA_URL)).to have_been_made.times(3)

      stub_request(:get, AgentAuthHelpers::AS_METADATA_URL).to_return(status: 500, body: "oops")
      expect { build_agent_auth.authorization_server_metadata(:proxy) }.to raise_error(unavailable_error)
      stub_request(:get, AgentAuthHelpers::AS_METADATA_URL).to_timeout
      expect { build_agent_auth.authorization_server_metadata(:proxy) }.to raise_error(unavailable_error)
    end
  end

  describe "the proxied document" do
    it "C70: is frozen at every level, so no caller can change what the next one is served", :aggregate_failures do
      upstream = {
        "issuer" => AgentAuthHelpers::ISSUER,
        "token_endpoint" => "#{AgentAuthHelpers::ISSUER}/token",
        "grant_types_supported" => %w[authorization_code refresh_token],
        "a_field_kinde_adds_later" => { "nested" => [1, 2] }
      }
      stub_request(:get, AgentAuthHelpers::AS_METADATA_URL).to_return(status: 200, body: upstream.to_json)
      document = kinde.authorization_server_metadata(:proxy)

      expect { document["token_endpoint"] = "https://elsewhere.example/token" }.to raise_error(FrozenError)
      expect { document["token_endpoint"] << "/x" }.to raise_error(FrozenError)
      expect { document["grant_types_supported"] << "password" }.to raise_error(FrozenError)
      expect { document["a_field_kinde_adds_later"]["nested"] << 3 }.to raise_error(FrozenError)

      expect(kinde.authorization_server_metadata(:proxy)).to eq(upstream)
      _status, _headers, body = kinde.metadata_response(
        "GET", "/.well-known/oauth-authorization-server", authorization_server_metadata: :proxy
      )
      expect(JSON.parse(body)).to eq(upstream)
      expect(a_request(:get, AgentAuthHelpers::AS_METADATA_URL)).to have_been_made.once

      # The static document is built for each call, so an edit to one copy stays in that copy.
      kinde.authorization_server_metadata(:static)["grant_types_supported"] << "password"
      expect(kinde.authorization_server_metadata(:static)["grant_types_supported"]).to eq(%w[authorization_code refresh_token])
    end
  end

  describe "#protects?" do
    it "C61: also covers the paths a router maps onto the resource path, and nothing else", :aggregate_failures do
      protected_paths = %w[/mcp /mcp/ /mcp/messages /mcp.json /mcp.x /mcp.json/ //mcp /mcp//messages ///mcp.json mcp]
      # What a Rails mount at /mcp also sends to its handler: anything but a letter, digit or underscore next.
      protected_paths += %w[/mcp-other /mcp-docs /mcp~ /mcp;x /mcp:x /mcp+ /mcp! /mcp@x /mcp=1 /mcp%20 /mcp%2Ejson]
      protected_paths.each { |path| expect(kinde.protects?(path)).to be(true), "expected #{path} to be protected" }

      # Only a letter, a digit or an underscore right after the resource path makes it another path.
      open_paths = %w[/mcpx /mcp_x /mcp1 /mcpx/mcp /MCP /mc /health / /v1/mcp /.well-known/oauth-protected-resource/mcp]
      open_paths.each { |path| expect(kinde.protects?(path)).to be(false), "expected #{path} to pass through" }

      # A request path is not always valid UTF-8; that must not raise.
      expect(kinde.protects?("/mcp.\xFF")).to be(true)
      expect(kinde.protects?("/mcp\xFF")).to be(true)
      expect(kinde.protects?("/mcp\xFF".b)).to be(true)
      expect(kinde.protects?("/mcpx\xFF")).to be(false)
      expect(kinde.protects?("/mcp\n")).to be(true)
      expect(kinde.protects?("/mcp\0")).to be(true)
      expect(kinde.protects?(nil)).to be(false)

      nested = build_agent_auth(resource_url: "https://api.example.com/v1/tools/mcp")
      expect(nested.protects?("/v1/tools/mcp.json")).to be(true)
      expect(nested.protects?("/v1//tools/mcp")).to be(true)
      expect(nested.protects?("/v1/tools/mcp-other")).to be(true)
      expect(nested.protects?("/v1/tools/mcp;x")).to be(true)
      expect(nested.protects?("/v1/tools/mcpx")).to be(false)
      expect(nested.protects?("/v1/tools/mcp_x")).to be(false)
      expect(nested.protects?("/v1/tools")).to be(false)
      expect(nested.protects?("/mcp")).to be(false)

      trailing = build_agent_auth(resource_url: "https://api.example.com/mcp/")
      expect(trailing.protects?("/mcp.json")).to be(true)
      expect(trailing.protects?("/mcp-other")).to be(true)
      expect(trailing.protects?("/mcpx")).to be(false)

      root = build_agent_auth(resource_url: "https://api.example.com/")
      expect(root.protects?("/")).to be(true)
      expect(root.protects?("/anything.json")).to be(true)
    end

    it "C66: checks a path as sent and with its percent-escapes decoded, whatever the resource path ends with", :aggregate_failures do
      # Spellings a router that decodes before it matches reads as /mcp or as a path below it.
      decoded_onto_resource = %w[/%6Dcp /%6dcp /mc%70 /%6D%63%70 /%6Dcp.json /%6Dcp-other /mcp%2Fmessages /mcp%2f /%2Fmcp]
      decoded_onto_resource.each { |path| expect(kinde.protects?(path)).to be(true), "expected #{path} to be protected" }

      # As sent, "%" follows the resource path, so these are protected although %78 and %5F decode to "x" and "_".
      %w[/mcp%78 /mcp%5Fx /mcp% /mcp%zz].each do |path|
        expect(kinde.protects?(path)).to be(true), "expected #{path} to be protected"
      end

      %w[/%6Dcpx /mc%2Fp /%256Dcp /%zzmcp /mcpx%2F /mcp_%2E].each do |path|
        expect(kinde.protects?(path)).to be(false), "expected #{path} to pass through"
      end

      # Rails upper-cases the hex digits of an escape before it routes, so their case must not matter.
      escaped = build_agent_auth(resource_url: "https://api.example.com/caf%C3%A9")
      %w[/caf%C3%A9 /caf%c3%a9 /caf%c3%A9.json /caf%c3%a9/x /caf%C3%a9-x].each do |path|
        expect(escaped.protects?(path)).to be(true), "expected #{path} to be protected"
      end
      expect(escaped.protects?("/caf%C3%A8")).to be(false)
      expect(escaped.protects?("/caf")).to be(false)
      lower_case = build_agent_auth(resource_url: "https://api.example.com/caf%c3%a9")
      expect(lower_case.protects?("/caf%C3%A9")).to be(true)
      expect(lower_case.protects?("/caf%C3%A9.json")).to be(true)
      plural = build_agent_auth(resource_url: "https://api.example.com/caf%C3%A9s")
      expect(plural.protects?("/caf%c3%a9s")).to be(true)
      expect(plural.protects?("/caf%c3%a9s%78")).to be(true)
      expect(plural.protects?("/caf%c3%a9sx")).to be(false)

      # A resource path that ends in another character has no word boundary after it: a Rails
      # mount there also takes /mcp-x, so everything that starts with it is protected.
      dashed = build_agent_auth(resource_url: "https://api.example.com/mcp-")
      %w[/mcp- /mcp-x /mcp-_ /mcp-1 /mcp-/x /mcp--].each do |path|
        expect(dashed.protects?(path)).to be(true), "expected #{path} to be protected"
      end
      expect(dashed.protects?("/mcp")).to be(false)
      expect(dashed.protects?("/mcpx")).to be(false)
    end
  end

  describe ".extract_bearer_token" do
    it "C14: accepts the Bearer scheme in any case", :aggregate_failures do
      expect(described_class.extract_bearer_token("Bearer abc")).to eq("abc")
      expect(described_class.extract_bearer_token("bearer abc")).to eq("abc")
      expect(described_class.extract_bearer_token("BEARER abc")).to eq("abc")
    end

    it "C14: accepts one or more spaces after the scheme, as RFC 6750 allows", :aggregate_failures do
      expect(described_class.extract_bearer_token("Bearer  abc")).to eq("abc")
      expect(described_class.extract_bearer_token("bearer     a.b.c")).to eq("a.b.c")
    end

    it "C15: raises MissingTokenError when there is no header", :aggregate_failures do
      expect { described_class.extract_bearer_token(nil) }.to raise_error(missing_token_error)
      expect { described_class.extract_bearer_token("") }.to raise_error(missing_token_error)
    end

    it "C16: raises InvalidTokenError for any other header shape", :aggregate_failures do
      ["Basic xyz", "Bearer", "Bearer ", "Bearer   ", "Bearer a b", "Bearer  a b", "Bearer\tabc", "Bearer \tabc", "Bearer abc ", "abc"].each do |header|
        expect { described_class.extract_bearer_token(header) }
          .to raise_error(invalid_token_error), "expected #{header.inspect} to be refused"
      end
    end
  end

  describe "challenge and error responses" do
    let(:prm) { AgentAuthHelpers::PRM_URL }

    it "C17: builds the three WWW-Authenticate shapes with every value quoted", :aggregate_failures do
      expect(kinde.challenge).to eq(%(Bearer resource_metadata="#{prm}"))
      expect(kinde.challenge(missing_token_error.new)).to eq(%(Bearer resource_metadata="#{prm}"))

      expect(kinde.challenge(invalid_token_error.new("The access token is not active"))).to eq(
        %(Bearer error="invalid_token", error_description="The access token is not active", resource_metadata="#{prm}")
      )

      expect(kinde.challenge(insufficient_scope_error.new(scopes: %w[profile email]))).to eq(
        %(Bearer error="insufficient_scope", scope="profile email", resource_metadata="#{prm}")
      )

      expect(kinde.challenge(permission_denied_error.new)).to be_nil
      expect(kinde.challenge(unavailable_error.new)).to be_nil
    end

    it "C18: escapes double quotes and backslashes inside a value" do
      header = KindeSdk::AgentAuth::Challenge.build(
        prm_url: 'https://api.example.com/a"b',
        error: "invalid_token",
        description: 'say "hi" \\ bye'
      )

      expect(header).to eq(
        'Bearer error="invalid_token", error_description="say \\"hi\\" \\\\ bye", ' \
        'resource_metadata="https://api.example.com/a\\"b"'
      )
    end

    it "C19: maps each error class to its status, JSON body and headers", :aggregate_failures do
      expectations = {
        missing_token_error.new => [401, "unauthorized", true],
        invalid_token_error.new("The access token is not active") => [401, "invalid_token", true],
        insufficient_scope_error.new(scopes: ["profile"]) => [403, "insufficient_scope", true],
        permission_denied_error.new(permissions: ["write:docs"]) => [403, "forbidden", false],
        unavailable_error.new => [503, "temporarily_unavailable", false]
      }

      expectations.each do |error, (status, code, challenged)|
        response_status, headers, body = kinde.error_response(error)
        expect(response_status).to eq(status)
        expect(headers["content-type"]).to eq("application/json")
        expect(JSON.parse(body)).to eq("error" => code, "error_description" => error.message)
        expect(headers.key?("www-authenticate")).to be(challenged), "www-authenticate for #{error.class}"
        expect(headers).not_to have_key("access-control-expose-headers")
        expect(headers.keys).to all(match(/\A[a-z-]+\z/))

        _, cors_headers, = kinde.error_response(error, cors: true)
        expect(cors_headers["access-control-expose-headers"]).to eq("WWW-Authenticate")
        expect(cors_headers["access-control-allow-origin"]).to eq("*")
        expect(cors_headers.key?("www-authenticate")).to be(challenged)
      end

      expect { kinde.error_response(StandardError.new("boom")) }.to raise_error(ArgumentError)
    end

    it "C68: builds the answer to a CORS preflight on a protected path, and nothing for any other request", :aggregate_failures do
      origin = "https://inspector.example.com"
      answer = kinde.preflight_response("OPTIONS", "/mcp", origin: origin, access_control_request_method: "POST")

      expect(answer).to eq(
        [
          204,
          {
            "access-control-allow-origin" => "*",
            "access-control-allow-methods" => "GET, HEAD, POST, PUT, PATCH, DELETE, OPTIONS",
            "access-control-allow-headers" =>
              "Authorization, Content-Type, Accept, Mcp-Session-Id, Mcp-Protocol-Version, Last-Event-ID, *",
            "vary" => "Origin, Access-Control-Request-Method"
          },
          ""
        ]
      )
      expect(answer[1].keys).to all(match(/\A[a-z-]+\z/))
      # Authorization is named: the * in the list does not cover it in a browser.
      expect(answer[1]["access-control-allow-headers"].split(", ")).to include("Authorization")
      expect(answer[1]).not_to have_key("access-control-allow-credentials")

      # Each caller gets its own headers: changing them changes nothing for the next one.
      answer[1]["access-control-allow-origin"] = "https://evil.example.com"
      again = kinde.preflight_response("options", "/mcp/messages", origin: "null", access_control_request_method: "DELETE")
      expect(again[0]).to eq(204)
      expect(again[1]["access-control-allow-origin"]).to eq("*")

      # The same rule as protects?: a sibling a router could send to the handler, not another path.
      expect(kinde.preflight_response("OPTIONS", "/mcp-docs", origin: origin, access_control_request_method: "GET")).not_to be_nil
      expect(kinde.preflight_response("OPTIONS", "/mcpx", origin: origin, access_control_request_method: "GET")).to be_nil
      expect(kinde.preflight_response("OPTIONS", "/health", origin: origin, access_control_request_method: "GET")).to be_nil

      # Not a preflight: another method, or one of the two headers missing or empty.
      %w[GET HEAD POST PUT PATCH DELETE].each do |method|
        expect(kinde.preflight_response(method, "/mcp", origin: origin, access_control_request_method: "POST")).to be_nil
      end
      [nil, ""].each do |missing|
        expect(kinde.preflight_response("OPTIONS", "/mcp", origin: missing, access_control_request_method: "POST")).to be_nil
        expect(kinde.preflight_response("OPTIONS", "/mcp", origin: origin, access_control_request_method: missing)).to be_nil
      end

      # Nothing from the request is reflected, whatever it holds.
      ["x\r\nset-cookie: a=b", "x" * 100_000, "\xFF\xFE".b, "\0"].each do |hostile|
        expect(kinde.preflight_response("OPTIONS", "/mcp", origin: hostile, access_control_request_method: hostile))
          .to eq(kinde.preflight_response("OPTIONS", "/mcp", origin: origin, access_control_request_method: "POST"))
      end
    end
  end

  describe "introspection (default verification)" do
    it "C20: posts the token to the scoped introspection endpoint with the application's Basic credentials", :aggregate_failures do
      stub_introspection

      kinde.verify_access_token(token)

      expect(
        a_request(:post, "https://yourbiz.kinde.com/oauth2/agents/app_id/introspect").with(
          headers: {
            "Authorization" => "Basic #{Base64.strict_encode64('app_id:app_secret')}",
            "Content-Type" => "application/x-www-form-urlencoded"
          },
          body: "token=#{token}"
        )
      ).to have_been_made.once
      expect(a_request(:any, "https://yourbiz.kinde.com/oauth2/introspect")).not_to have_been_made
    end

    it "C21: URL-encodes the client id and secret before base64" do
      agent_auth = build_agent_auth(client_id: "app:id+1", client_secret: "p@ss:w/rd+=&")
      url = "https://yourbiz.kinde.com/oauth2/agents/app:id+1/introspect"
      stub_request(:post, url).to_return(status: 200, body: introspection_body.to_json)

      agent_auth.verify_access_token(token)

      expected = Base64.strict_encode64("app%3Aid%2B1:p%40ss%3Aw%2Frd%2B%3D%26")
      expect(a_request(:post, url).with(headers: { "Authorization" => "Basic #{expected}" })).to have_been_made.once
    end

    it "C22: returns a context whose permissions, roles, org_code and email come from the token", :aggregate_failures do
      # Signed by a key that has no JWKS stub: a JWKS or user profile request
      # would hit WebMock's net-connect guard and fail this example.
      unverifiable = sign_token(token_claims, key: AgentAuthHelpers::OTHER_RSA_KEY)
      stub_introspection(introspection_body("aud" => [AgentAuthHelpers::RESOURCE_URL, "https://other.example.com"]))

      auth = kinde.verify_access_token(unverifiable)

      expect(auth).to be_a(KindeSdk::AgentAuth::AuthContext)
      expect(auth.user_id).to eq("kp_user_1")
      expect(auth.permissions).to eq(["read:docs"])
      expect(auth.roles).to eq(["admin"])
      expect(auth.org_code).to eq("org_123")
      expect(auth.email).to eq("user@example.com")
      expect(auth.claims).to include("active" => true, "jti" => "jti_1")
      expect(a_request(:get, AgentAuthHelpers::JWKS_URL)).not_to have_been_made
      expect(a_request(:any, "https://yourbiz.kinde.com/oauth2/v2/user_profile")).not_to have_been_made
    end

    it "C23: accepts aud as a plain string equal to the Resource URL" do
      stub_introspection(introspection_body("aud" => AgentAuthHelpers::RESOURCE_URL))

      expect(kinde.verify_access_token(token).user_id).to eq("kp_user_1")
    end

    it "C24: rejects an inactive token" do
      stub_introspection({ "active" => false })

      expect { kinde.verify_access_token(token) }.to raise_error(invalid_token_error)
    end

    it "C25: requires active to be the boolean true", :aggregate_failures do
      stub_introspection(introspection_body.reject { |key, _| key == "active" })
      expect { kinde.verify_access_token(token) }.to raise_error(invalid_token_error)

      stub_introspection(introspection_body("active" => "true"))
      expect { kinde.verify_access_token(token) }.to raise_error(invalid_token_error)
    end

    it "C26: rejects a token whose introspected aud lacks the Resource URL", :aggregate_failures do
      stub_introspection(introspection_body("aud" => ["https://other.example.com/mcp"]))
      expect { kinde.verify_access_token(token) }.to raise_error(invalid_token_error)

      stub_introspection(introspection_body.reject { |key, _| key == "aud" })
      expect { kinde.verify_access_token(token) }.to raise_error(invalid_token_error)
    end

    it "C27: applies the clock tolerance to the introspected exp, and accepts a missing exp", :aggregate_failures do
      expired = introspection_body("exp" => Time.now.to_i - 120)

      stub_introspection(expired)
      expect { kinde.verify_access_token(token) }.to raise_error(invalid_token_error)

      tolerant = build_agent_auth(clock_tolerance_seconds: 300)
      expect(tolerant.verify_access_token(token).user_id).to eq("kp_user_1")

      stub_introspection(introspection_body.reject { |key, _| key == "exp" })
      expect(kinde.verify_access_token(token).user_id).to eq("kp_user_1")
    end

    it "C28: raises UnavailableError, never InvalidTokenError, when Kinde gives no verdict", :aggregate_failures do
      outages = {
        "a 500" => -> { stub_introspection("oops", status: 500) },
        "a timeout" => -> { stub_request(:post, AgentAuthHelpers::INTROSPECT_URL).to_timeout },
        "a refused connection" => -> { stub_request(:post, AgentAuthHelpers::INTROSPECT_URL).to_raise(Errno::ECONNREFUSED) },
        "a DNS failure" => -> { stub_request(:post, AgentAuthHelpers::INTROSPECT_URL).to_raise(SocketError) },
        "a malformed HTTP answer" => -> { stub_request(:post, AgentAuthHelpers::INTROSPECT_URL).to_raise(Net::HTTPBadResponse) },
        "a protocol error" => -> { stub_request(:post, AgentAuthHelpers::INTROSPECT_URL).to_raise(Net::ProtocolError) },
        "a malformed header" => -> { stub_request(:post, AgentAuthHelpers::INTROSPECT_URL).to_raise(Net::HTTPHeaderSyntaxError) },
        "a corrupt compressed body" => -> { stub_request(:post, AgentAuthHelpers::INTROSPECT_URL).to_raise(Zlib::DataError) },
        "a 200 that is not JSON" => -> { stub_introspection("<html>gateway</html>") },
        "a 200 that is not a JSON object" => -> { stub_introspection("[]") }
      }

      outages.each do |name, arrange|
        arrange.call
        expect { kinde.verify_access_token(token) }.to raise_error { |error|
          expect(error).to be_a(unavailable_error), "#{name}: got #{error.class}"
          expect(error).not_to be_a(KindeSdk::AuthenticationError)
        }
      end
    end

    it "C29: treats a 401 from Kinde as a configuration error and logs it once", :aggregate_failures do
      logs = capture_logs
      stub_introspection({ "error" => "invalid_client" }, status: 401)

      expect { kinde.verify_access_token(token) }.to raise_error(unavailable_error)

      expect(logs.size).to eq(1)
      level, message = logs.first
      expect(level).to eq(:error)
      expect(message).to match(/credentials/i)
      expect(message).to include(AgentAuthHelpers::INTROSPECT_URL)
      expect(message).to include("app_id")
    end

    it "C30: never puts the token, the client secret or the Basic header into a log line or an error message", :aggregate_failures do
      logs = capture_logs
      messages = []
      scenarios = [
        -> { stub_introspection({ "active" => false }) },
        -> { stub_introspection(introspection_body("active" => "true")) },
        -> { stub_introspection(introspection_body("aud" => ["https://other.example.com/mcp"])) },
        -> { stub_introspection(introspection_body("exp" => Time.now.to_i - 120)) },
        -> { stub_introspection("oops", status: 500) },
        -> { stub_request(:post, AgentAuthHelpers::INTROSPECT_URL).to_timeout },
        -> { stub_introspection("<html>#{token}</html>") },
        -> { stub_introspection({ "error" => "invalid_client" }, status: 401) }
      ]

      scenarios.each do |arrange|
        arrange.call
        expect { kinde.verify_access_token(token) }.to raise_error(KindeSdk::APIError) { |error| messages << error.message }
      end

      secrets = [token, *token.split("."), "app_secret", Base64.strict_encode64("app_id:app_secret")]
      output = (messages + logs.map(&:last)).join("\n")
      expect(messages.size).to eq(scenarios.size)
      secrets.each { |secret| expect(output).not_to include(secret) }
    end

    it "C64: gives Kinde 5 seconds to answer on every call it makes", :aggregate_failures do
      expect(KindeSdk::AgentAuth::Http::TIMEOUT_SECONDS).to eq(5)
      stub_introspection
      stub_jwks
      stub_request(:post, AgentAuthHelpers::REVOKE_URL).to_return(status: 200, body: "")
      stub_request(:get, AgentAuthHelpers::AS_METADATA_URL).to_return(status: 200, body: "{}")

      [AgentAuthHelpers::INTROSPECT_URL, AgentAuthHelpers::REVOKE_URL].each do |url|
        expect(HTTParty).to receive(:post).with(url, hash_including(timeout: 5)).once.and_call_original
      end
      [AgentAuthHelpers::JWKS_URL, AgentAuthHelpers::AS_METADATA_URL].each do |url|
        expect(HTTParty).to receive(:get).with(url, hash_including(timeout: 5)).once.and_call_original
      end

      kinde.verify_access_token(token)
      kinde.revoke_token(token)
      jwt_kinde.verify_access_token(token)
      kinde.authorization_server_metadata(:proxy)
    end
  end

  describe "the deadline of a call to Kinde" do
    it "C73: stops a call that takes longer in total, however the time is spent", :aggregate_failures do
      stub_const("KindeSdk::AgentAuth::Http::TIMEOUT_SECONDS", 0.2)
      slow = lambda do |body|
        lambda do |_request|
          sleep 2
          { status: 200, body: body.to_json }
        end
      end
      elapsed = lambda do |&call|
        started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        expect(&call).to raise_error(unavailable_error)
        Process.clock_gettime(Process::CLOCK_MONOTONIC) - started
      end

      stub_request(:post, AgentAuthHelpers::INTROSPECT_URL).to_return(slow.call(introspection_body))
      expect(elapsed.call { kinde.verify_access_token(token) }).to be < 1.5

      stub_request(:post, AgentAuthHelpers::REVOKE_URL).to_return(slow.call({}))
      expect(elapsed.call { kinde.revoke_token(token) }).to be < 1.5

      stub_request(:get, AgentAuthHelpers::JWKS_URL).to_return(slow.call(jwks_document))
      expect(elapsed.call { jwt_kinde.verify_access_token(token) }).to be < 1.5

      stub_request(:get, AgentAuthHelpers::AS_METADATA_URL).to_return(slow.call({}))
      expect(elapsed.call { kinde.authorization_server_metadata(:proxy) }).to be < 1.5
    end
  end

  describe KindeSdk::AgentAuth::AuthContext do
    def context(claims, raw_token = "raw.token.value")
      described_class.from_claims(raw_token, claims)
    end

    it "C31: reads scopes from scp, else from a space-separated scope", :aggregate_failures do
      expect(context("scp" => %w[offline profile], "scope" => "email").scopes).to eq(%w[offline profile])
      expect(context("scope" => "offline email").scopes).to eq(%w[offline email])
      expect(context({}).scopes).to eq([])
    end

    it "C32: reads the agent from azp, else from client_id", :aggregate_failures do
      expect(context("azp" => "https://claude.ai/cimd", "client_id" => "registrant").client_id).to eq("https://claude.ai/cimd")
      expect(context("client_id" => "registrant").client_id).to eq("registrant")
    end

    it "C33: defaults permissions and roles to empty lists and keeps role keys", :aggregate_failures do
      empty = context({})
      expect(empty.permissions).to eq([])
      expect(empty.roles).to eq([])

      roles = context("roles" => [{ "id" => "1", "key" => "admin", "name" => "Admin" }, "editor"]).roles
      expect(roles).to eq(%w[admin editor])
    end

    it "C34: carries the token, user id, expiry and every claim, and hides the token in inspect", :aggregate_failures do
      claims = token_claims("custom" => { "a" => 1 })
      auth = context(claims, "secret.raw.token")

      expect(auth.token).to eq("secret.raw.token")
      expect(auth.user_id).to eq("kp_user_1")
      expect(auth.expires_at).to eq(claims["exp"])
      expect(auth.claims).to eq(claims)
      expect(auth).to be_frozen
      expect(auth.inspect).not_to include("secret.raw.token")
      expect(auth.to_s).not_to include("secret.raw.token")
    end

    it "C69: keeps its own frozen copies of the token and the claims", :aggregate_failures do
      raw = +"raw.token.value"
      claims = {
        "sub" => +"kp_1", "permissions" => [+"read:docs"], "roles" => [{ "key" => +"admin" }],
        "scope" => +"offline profile", "nested" => { "list" => [+"a"] }
      }
      auth = context(claims, raw)

      # Nothing of the caller's is frozen, and editing it afterwards changes nothing that was verified.
      expect([raw, claims, claims["sub"], claims["permissions"], claims["permissions"][0], claims["roles"][0]])
        .to all(satisfy { |value| !value.frozen? })
      claims["permissions"][0].replace("write:docs")
      claims["permissions"] << "admin:all"
      claims["roles"][0]["key"] << "-plus"
      claims["nested"]["list"] << "b"
      raw << ".more"
      expect(auth.token).to eq("raw.token.value")
      expect(auth.permissions).to eq(["read:docs"])
      expect(auth.roles).to eq(["admin"])
      expect(auth.claims["nested"]).to eq("list" => ["a"])
      expect(auth.has_permission?("write:docs")).to be(false)

      # Everything the context hands out is frozen, down to each string.
      expect(auth.token).to be_frozen
      expect { auth.permissions[0] << "x" }.to raise_error(FrozenError)
      expect { auth.permissions << "write:docs" }.to raise_error(FrozenError)
      expect { auth.roles[0].upcase! }.to raise_error(FrozenError)
      expect { auth.scopes[0] << "x" }.to raise_error(FrozenError)
      expect { auth.claims["permissions"][0].replace("write:docs") }.to raise_error(FrozenError)
      expect { auth.claims["nested"]["list"] << "b" }.to raise_error(FrozenError)
      expect { auth.claims["roles"][0]["key"] << "x" }.to raise_error(FrozenError)
      expect(auth.has_permission?("read:docs")).to be(true)
    end

    it "C35: has_permission? is true only for a held key and never raises", :aggregate_failures do
      auth = context("permissions" => ["read:docs"])

      expect(auth.has_permission?("read:docs")).to be(true)
      expect(auth.has_permission?("write:docs")).to be(false)
      expect(auth.has_permission?(nil)).to be(false)
      expect(auth.hasPermission("read:docs")).to be(true)
      expect(auth.hasPermission("write:docs")).to be(false)

      expect(KindeSdk::AgentAuth.has_permission?(auth, "read:docs")).to be(true)
      expect(KindeSdk::AgentAuth.has_permission?(auth, "write:docs")).to be(false)
      expect(KindeSdk::AgentAuth.has_permission?(nil, "read:docs")).to be(false)
      expect(KindeSdk::AgentAuth.has_permission?("not a context", "read:docs")).to be(false)
      expect(KindeSdk::AgentAuth.hasPermission(auth, "read:docs")).to be(true)
      expect(KindeSdk::AgentAuth.hasPermission(nil, "read:docs")).to be(false)
    end
  end

  describe "local JWT verification" do
    def rejected(claims_or_token, agent_auth = jwt_kinde)
      candidate = claims_or_token.is_a?(String) ? claims_or_token : sign_token(claims_or_token)
      expect { agent_auth.verify_access_token(candidate) }
        .to raise_error(KindeSdk::AgentAuth::InvalidTokenError), "expected rejection of #{claims_or_token.inspect}"
    end

    def accepted(claims, agent_auth = jwt_kinde)
      expect(agent_auth.verify_access_token(sign_token(claims)).user_id).to eq("kp_user_1")
    end

    it "C36: accepts iss = domain with aud containing the Resource URL, without introspection", :aggregate_failures do
      stub_jwks

      auth = jwt_kinde.verify_access_token(token)

      expect(auth.user_id).to eq("kp_user_1")
      expect(auth.permissions).to eq(["read:docs"])
      expect(auth.roles).to eq(["admin"])
      expect(auth.org_code).to eq("org_123")
      expect(auth.scopes).to eq(["offline"])
      expect(auth.client_id).to eq("https://claude.ai/oauth/claude-code-client-metadata")
      expect(auth.token).to eq(token)
      expect(a_request(:post, AgentAuthHelpers::INTROSPECT_URL)).not_to have_been_made
    end

    it "C37: rejects iss = scoped issuer" do
      stub_jwks

      rejected(token_claims("iss" => AgentAuthHelpers::ISSUER))
    end

    it "C38: trims exactly one trailing slash from iss and rejects another domain", :aggregate_failures do
      stub_jwks

      accepted(token_claims("iss" => "#{AgentAuthHelpers::DOMAIN}/"))
      accepted(token_claims, build_agent_auth(verification: "jwt", domain: "https://YourBiz.Kinde.com"))
      rejected(token_claims("iss" => "#{AgentAuthHelpers::DOMAIN}//"))
      rejected(token_claims("iss" => "https://other.kinde.com"))
      rejected(token_claims.reject { |key, _| key == "iss" })
    end

    it "C39: matches aud against the Resource URL exactly", :aggregate_failures do
      stub_jwks

      rejected(token_claims("aud" => ["https://other.example.com/mcp"]))
      rejected(token_claims("aud" => ["https://api.example.com/mcp/"]))
      rejected(token_claims("aud" => ["https://API.example.com/mcp"]))
      rejected(token_claims.reject { |key, _| key == "aud" })
      accepted(token_claims("aud" => AgentAuthHelpers::RESOURCE_URL))
      accepted(token_claims("aud" => [AgentAuthHelpers::RESOURCE_URL, "https://yourbiz.kinde.com/api"]))
    end

    it "C40: applies the clock tolerance to exp and requires exp", :aggregate_failures do
      stub_jwks
      expired = token_claims("exp" => Time.now.to_i - 120)

      rejected(expired)
      accepted(expired, build_agent_auth(verification: "jwt", clock_tolerance_seconds: 300))
      rejected(token_claims.reject { |key, _| key == "exp" })
    end

    it "C41: applies the clock tolerance to nbf", :aggregate_failures do
      stub_jwks
      future = token_claims("nbf" => Time.now.to_i + 120)

      rejected(future)
      accepted(future, build_agent_auth(verification: "jwt", clock_tolerance_seconds: 300))
    end

    it "C42: rejects alg none, HS256 and RS512 before any key is fetched", :aggregate_failures do
      # No JWKS stub: a fetch would hit WebMock's net-connect guard.
      hs256 = JWT.encode(token_claims, AgentAuthHelpers::RSA_KEY.public_key.to_pem, "HS256", { kid: AgentAuthHelpers::KID })

      rejected(unsigned_token)
      rejected(hs256)
      rejected(sign_token(token_claims, alg: "RS512"))
      expect(a_request(:get, AgentAuthHelpers::JWKS_URL)).not_to have_been_made
    end

    it "C43: rejects a token signed by another key and a string that is not a JWT", :aggregate_failures do
      stub_jwks

      rejected(sign_token(token_claims, key: AgentAuthHelpers::OTHER_RSA_KEY))
      rejected("not-a-jwt")
      rejected("a.b.c")
      expect { jwt_kinde.verify_access_token(nil) }.to raise_error(invalid_token_error)
    end

    it "C44: fetches the JWKS from /.well-known/jwks once and again after an hour", :aggregate_failures do
      stub_jwks
      clock = AgentAuthHelpers::FakeClock.new
      verifier = KindeSdk::AgentAuth::TokenVerifier.new(jwt_kinde.config, clock: clock)

      verifier.verify(token)
      verifier.verify(token)
      expect(a_request(:get, "https://yourbiz.kinde.com/.well-known/jwks")).to have_been_made.once
      expect(a_request(:get, "https://yourbiz.kinde.com/.well-known/jwks.json")).not_to have_been_made

      clock.advance(3601)
      verifier.verify(token)
      expect(a_request(:get, "https://yourbiz.kinde.com/.well-known/jwks")).to have_been_made.times(2)
    end

    it "C45: refetches the JWKS once for an unknown kid, not on every request", :aggregate_failures do
      stub_jwks
      clock = AgentAuthHelpers::FakeClock.new
      verifier = KindeSdk::AgentAuth::TokenVerifier.new(jwt_kinde.config, clock: clock)
      unknown = sign_token(token_claims, kid: "unknown-kid", key: AgentAuthHelpers::OTHER_RSA_KEY)

      verifier.verify(token) # warm the cache
      expect(a_request(:get, AgentAuthHelpers::JWKS_URL)).to have_been_made.once

      expect { verifier.verify(unknown) }.to raise_error(invalid_token_error)
      expect(a_request(:get, AgentAuthHelpers::JWKS_URL)).to have_been_made.times(2)

      clock.advance(59)
      expect { verifier.verify(unknown) }.to raise_error(invalid_token_error)
      expect { verifier.verify(unknown) }.to raise_error(invalid_token_error)
      expect(a_request(:get, AgentAuthHelpers::JWKS_URL)).to have_been_made.times(2)

      clock.advance(2) # 61 seconds after the forced refetch
      expect { verifier.verify(unknown) }.to raise_error(invalid_token_error)
      expect(a_request(:get, AgentAuthHelpers::JWKS_URL)).to have_been_made.times(3)
    end

    it "C46: picks up a rotated key through the refetch", :aggregate_failures do
      stub_jwks
      verifier = KindeSdk::AgentAuth::TokenVerifier.new(jwt_kinde.config, clock: AgentAuthHelpers::FakeClock.new)
      verifier.verify(token) # warm the cache with the old key

      stub_jwks(key: AgentAuthHelpers::OTHER_RSA_KEY, kid: "kinde-key-2")
      rotated = sign_token(token_claims, kid: "kinde-key-2", key: AgentAuthHelpers::OTHER_RSA_KEY)

      expect(verifier.verify(rotated).user_id).to eq("kp_user_1")
      expect(a_request(:get, AgentAuthHelpers::JWKS_URL)).to have_been_made.times(2)
    end

    it "C47: raises UnavailableError when the JWKS cannot be fetched", :aggregate_failures do
      outages = [
        -> { stub_request(:get, AgentAuthHelpers::JWKS_URL).to_return(status: 500, body: "oops") },
        -> { stub_request(:get, AgentAuthHelpers::JWKS_URL).to_timeout },
        -> { stub_request(:get, AgentAuthHelpers::JWKS_URL).to_raise(Net::HTTPBadResponse) },
        -> { stub_request(:get, AgentAuthHelpers::JWKS_URL).to_return(status: 200, body: { "not_keys" => [] }.to_json) }
      ]

      outages.each_with_index do |arrange, index|
        arrange.call
        # A new instance per outage: one instance remembers a failed fetch for a few seconds (C62).
        expect { build_agent_auth(verification: "jwt").verify_access_token(token) }.to raise_error(unavailable_error)
        expect(a_request(:get, AgentAuthHelpers::JWKS_URL)).to have_been_made.times(index + 1)
      end
    end

    it "C62: remembers a failed JWKS fetch for a few seconds instead of repeating it", :aggregate_failures do
      interval = KindeSdk::AgentAuth::CachedDocument::FAILURE_RETRY_INTERVAL
      expect(interval).to be_between(1, 10)
      jwks_requests = -> { a_request(:get, AgentAuthHelpers::JWKS_URL) }
      clock = AgentAuthHelpers::FakeClock.new
      verifier = KindeSdk::AgentAuth::TokenVerifier.new(jwt_kinde.config, clock: clock)

      # Cold cache, Kinde down: the callers that follow a failed fetch do not repeat it.
      stub_request(:get, AgentAuthHelpers::JWKS_URL).to_timeout
      3.times { expect { verifier.verify(token) }.to raise_error(unavailable_error) }
      expect(jwks_requests.call).to have_been_made.once

      clock.advance(interval - 0.5)
      expect { verifier.verify(token) }.to raise_error(unavailable_error)
      expect(jwks_requests.call).to have_been_made.once

      # Still down after the interval: one new attempt. It takes 5 seconds to
      # fail, and the interval counts from the failure, not from the start.
      stub_request(:get, AgentAuthHelpers::JWKS_URL).to_return do
        clock.advance(5)
        { status: 500, body: "oops" }
      end
      clock.advance(1)
      2.times { expect { verifier.verify(token) }.to raise_error(unavailable_error) }
      expect(jwks_requests.call).to have_been_made.times(2)

      # Kinde is back: unavailable (never a rejected token) until the interval is over, then verified.
      stub_jwks
      expect { verifier.verify(token) }.to raise_error(unavailable_error)
      expect(jwks_requests.call).to have_been_made.times(2)
      clock.advance(interval)
      expect(verifier.verify(token).user_id).to eq("kp_user_1")
      expect(jwks_requests.call).to have_been_made.times(3)

      # The same when a cached document passes its ttl during an outage.
      stub_request(:get, AgentAuthHelpers::JWKS_URL).to_return(status: 500, body: "oops")
      clock.advance(3601)
      2.times { expect { verifier.verify(token) }.to raise_error(unavailable_error) }
      expect(jwks_requests.call).to have_been_made.times(4)
    end

    it "C63: a failed forced refetch does not use up the 60 second window", :aggregate_failures do
      interval = KindeSdk::AgentAuth::CachedDocument::FAILURE_RETRY_INTERVAL
      jwks_requests = -> { a_request(:get, AgentAuthHelpers::JWKS_URL) }
      stub_jwks
      clock = AgentAuthHelpers::FakeClock.new
      verifier = KindeSdk::AgentAuth::TokenVerifier.new(jwt_kinde.config, clock: clock)
      verifier.verify(token) # warm the cache with the old key
      rotated = sign_token(token_claims, kid: "kinde-key-2", key: AgentAuthHelpers::OTHER_RSA_KEY)

      # Kinde rotates its key and the one forced refetch times out.
      stub_request(:get, AgentAuthHelpers::JWKS_URL).to_timeout
      expect { verifier.verify(rotated) }.to raise_error(unavailable_error)
      expect(jwks_requests.call).to have_been_made.times(2)
      expect(verifier.verify(token).user_id).to eq("kp_user_1") # the cached keys still serve

      # Kinde is reachable again a moment later. Inside the failure interval the
      # answer is "unavailable" without a request, never a rejected token.
      stub_jwks(key: AgentAuthHelpers::OTHER_RSA_KEY, kid: "kinde-key-2")
      expect { verifier.verify(rotated) }.to raise_error(unavailable_error)
      expect(jwks_requests.call).to have_been_made.times(2)

      # After it (seconds, not the 60 second window) the refetch runs and the token verifies.
      clock.advance(interval)
      expect(clock.now - 1_000.0).to be < KindeSdk::AgentAuth::TokenVerifier::JWKS_MIN_REFRESH_INTERVAL
      expect(verifier.verify(rotated).user_id).to eq("kp_user_1")
      expect(jwks_requests.call).to have_been_made.times(3)

      # The refetch that succeeded is the one that starts the 60 second window.
      unknown = sign_token(token_claims, kid: "unknown-kid")
      expect { verifier.verify(unknown) }.to raise_error(invalid_token_error)
      clock.advance(59)
      expect { verifier.verify(unknown) }.to raise_error(invalid_token_error)
      expect(jwks_requests.call).to have_been_made.times(3)
    end

    it "C67: treats a JWKS answer without a keys array as a failed fetch, not as a document to cache", :aggregate_failures do
      interval = KindeSdk::AgentAuth::CachedDocument::FAILURE_RETRY_INTERVAL
      jwks_requests = -> { a_request(:get, AgentAuthHelpers::JWKS_URL) }
      not_a_key_set = { status: 200, body: { "message" => "try again" }.to_json }
      key_set = { status: 200, body: jwks_document.to_json }
      clock = AgentAuthHelpers::FakeClock.new
      verifier = KindeSdk::AgentAuth::TokenVerifier.new(jwt_kinde.config, clock: clock)

      # One bad 200 on a cold cache, the real key set from then on.
      stub_request(:get, AgentAuthHelpers::JWKS_URL).to_return(not_a_key_set, key_set)
      expect { verifier.verify(token) }.to raise_error(unavailable_error)
      expect(jwks_requests.call).to have_been_made.once

      # Remembered like any failed fetch: unavailable (never a rejected token) and no request inside the interval.
      clock.advance(interval - 0.5)
      expect { verifier.verify(token) }.to raise_error(unavailable_error)
      expect(jwks_requests.call).to have_been_made.once

      # A few seconds later, not an hour later, the next call fetches again and the token verifies.
      clock.advance(1)
      expect(clock.now - 1_000.0).to be < 10
      expect(verifier.verify(token).user_id).to eq("kp_user_1")
      expect(jwks_requests.call).to have_been_made.times(2)

      # The same answer to a forced refetch does not replace the cached keys either.
      stub_request(:get, AgentAuthHelpers::JWKS_URL).to_return(not_a_key_set)
      unknown = sign_token(token_claims, kid: "unknown-kid", key: AgentAuthHelpers::OTHER_RSA_KEY)
      expect { verifier.verify(unknown) }.to raise_error(unavailable_error)
      expect(jwks_requests.call).to have_been_made.times(3)
      expect(verifier.verify(token).user_id).to eq("kp_user_1")
      expect(jwks_requests.call).to have_been_made.times(3)

      # The same holds with introspection after the local check.
      stub_request(:get, AgentAuthHelpers::JWKS_URL).to_return(not_a_key_set, key_set)
      stub_introspection
      both_clock = AgentAuthHelpers::FakeClock.new
      both = KindeSdk::AgentAuth::TokenVerifier.new(build_agent_auth(verification: "jwt+introspection").config, clock: both_clock)
      expect { both.verify(token) }.to raise_error(unavailable_error)
      both_clock.advance(interval)
      expect(both.verify(token).user_id).to eq("kp_user_1")
      expect(jwks_requests.call).to have_been_made.times(5)
    end
  end

  describe "a JWKS the jwt gem cannot use" do
    let(:interval) { KindeSdk::AgentAuth::CachedDocument::FAILURE_RETRY_INTERVAL }
    let(:good_key) { jwks_document[:keys].first }
    let(:key_set) { { status: 200, body: jwks_document.to_json } }

    def answer(keys)
      { status: 200, body: { "keys" => keys }.to_json }
    end

    it "C75: is a failed fetch, never a rejected token, and is fetched again a few seconds later", :aggregate_failures do
      unusable = {
        "an empty entry" => [{}],
        "an RSA entry without n and e" => [{ "kty" => "RSA", "kid" => "k2" }],
        "a good key next to a broken one" => [good_key, { "kty" => "RSA", "kid" => "k2" }],
        "a null entry" => [good_key, nil],
        "no key at all" => [],
        "no RSA key" => [JWT::JWK.new(OpenSSL::PKey::EC.generate("prime256v1"), kid: "ec1").export]
      }
      requests = 0

      unusable.each do |name, keys|
        clock = AgentAuthHelpers::FakeClock.new
        verifier = KindeSdk::AgentAuth::TokenVerifier.new(jwt_kinde.config, clock: clock)
        stub_request(:get, AgentAuthHelpers::JWKS_URL).to_return(answer(keys), key_set)

        expect { verifier.verify(token) }.to raise_error(unavailable_error), name
        clock.advance(interval - 0.5)
        expect { verifier.verify(token) }.to raise_error(unavailable_error), name
        expect(a_request(:get, AgentAuthHelpers::JWKS_URL)).to have_been_made.times(requests += 1)

        clock.advance(1)
        expect(verifier.verify(token).user_id).to eq("kp_user_1"), name
        expect(a_request(:get, AgentAuthHelpers::JWKS_URL)).to have_been_made.times(requests += 1)
      end
    end

    it "C75: does not replace the cached keys when it answers a forced refetch", :aggregate_failures do
      clock = AgentAuthHelpers::FakeClock.new
      verifier = KindeSdk::AgentAuth::TokenVerifier.new(jwt_kinde.config, clock: clock)
      stub_request(:get, AgentAuthHelpers::JWKS_URL).to_return(key_set, answer([{}]))
      unknown = sign_token(token_claims, kid: "unknown-kid", key: AgentAuthHelpers::OTHER_RSA_KEY)

      expect(verifier.verify(token).user_id).to eq("kp_user_1")
      expect { verifier.verify(unknown) }.to raise_error(unavailable_error)
      clock.advance(interval + 1)
      expect(verifier.verify(token).user_id).to eq("kp_user_1")
      expect(a_request(:get, AgentAuthHelpers::JWKS_URL)).to have_been_made.times(2)
    end

    it "C75: still accepts a key set that also holds a key type the gem does not know" do
      stub_request(:get, AgentAuthHelpers::JWKS_URL).to_return(answer([good_key, { "kty" => "XYZ", "kid" => "k3" }]))

      expect(jwt_kinde.verify_access_token(token).user_id).to eq("kp_user_1")
    end
  end

  describe "jwt+introspection" do
    let(:both) { build_agent_auth(verification: "jwt+introspection") }

    it "C48: returns the context when both checks pass", :aggregate_failures do
      stub_jwks
      stub_introspection

      auth = both.verify_access_token(token)

      expect(auth.user_id).to eq("kp_user_1")
      expect(auth.permissions).to eq(["read:docs"])
      expect(a_request(:get, AgentAuthHelpers::JWKS_URL)).to have_been_made.once
      expect(a_request(:post, AgentAuthHelpers::INTROSPECT_URL)).to have_been_made.once
    end

    it "C49: rejects a valid JWT that introspection calls inactive" do
      stub_jwks
      stub_introspection({ "active" => false })

      expect { both.verify_access_token(token) }.to raise_error(invalid_token_error)
    end

    it "C50: rejects an invalid JWT without calling introspection", :aggregate_failures do
      stub_jwks
      stub_introspection
      forged = sign_token(token_claims, key: AgentAuthHelpers::OTHER_RSA_KEY)

      expect { both.verify_access_token(forged) }.to raise_error(invalid_token_error)
      expect { both.verify_access_token(sign_token(token_claims("iss" => AgentAuthHelpers::ISSUER))) }
        .to raise_error(invalid_token_error)
      expect(a_request(:post, AgentAuthHelpers::INTROSPECT_URL)).not_to have_been_made
    end

    it "C51: raises UnavailableError when the JWT is valid and introspection is down" do
      stub_jwks
      stub_introspection("oops", status: 500)

      expect { both.verify_access_token(token) }.to raise_error(unavailable_error)
    end

    it "C74: checks the signed expiry again after Kinde answered", :aggregate_failures do
      strict = build_agent_auth(verification: "jwt+introspection", clock_tolerance_seconds: 0)
      started = Time.now
      passed = 0
      allow(Time).to receive(:now) { started + passed }
      expiring = sign_token(token_claims("exp" => started.to_i + 2))
      active_without_exp = introspection_body.reject { |name, _| name == "exp" }.to_json
      stub_jwks

      # Kinde's answer arrives three seconds later, after the token expired, and carries no exp.
      stub_request(:post, AgentAuthHelpers::INTROSPECT_URL).to_return do |_request|
        passed = 3
        { status: 200, body: active_without_exp }
      end
      expect { strict.verify_access_token(expiring) }.to raise_error(invalid_token_error, "The access token has expired")
      expect(a_request(:post, AgentAuthHelpers::INTROSPECT_URL)).to have_been_made.once

      # An answer that arrives before the expiry still passes.
      passed = 0
      stub_request(:post, AgentAuthHelpers::INTROSPECT_URL).to_return do |_request|
        passed = 1
        { status: 200, body: active_without_exp }
      end
      expect(strict.verify_access_token(expiring).user_id).to eq("kp_user_1")
    end
  end

  describe "permission and scope guards" do
    let(:auth) do
      KindeSdk::AgentAuth::AuthContext.from_claims("t", "permissions" => %w[read:docs write:docs], "scp" => %w[offline profile])
    end

    it "C52: require_permission returns the context or raises PermissionDeniedError", :aggregate_failures do
      expect(kinde.require_permission(auth, "read:docs")).to equal(auth)
      expect(kinde.require_permission(auth, "read:docs", "write:docs")).to equal(auth)

      expect { kinde.require_permission(auth, "read:docs", "delete:docs") }.to raise_error(permission_denied_error) { |error|
        expect(error.permissions).to eq(%w[read:docs delete:docs])
        expect(error).not_to be_a(insufficient_scope_error)
        expect(error).to be_a(KindeSdk::AuthorizationError)
      }
      expect { kinde.require_permission(nil, "read:docs") }.to raise_error(missing_token_error)
    end

    it "C53: require_scope returns the context or raises InsufficientScopeError with the required scopes", :aggregate_failures do
      expect(kinde.require_scope(auth, "offline")).to equal(auth)
      expect(kinde.require_scope(auth, "offline", "profile")).to equal(auth)

      expect { kinde.require_scope(auth, "profile", "email") }.to raise_error(insufficient_scope_error) { |error|
        expect(error.scopes).to eq(%w[profile email])
        expect(error).to be_a(KindeSdk::AuthorizationError)
      }
      expect { kinde.require_scope(nil, "offline") }.to raise_error(missing_token_error)
    end
  end

  describe "#revoke_token" do
    let(:revoke_url) { "https://yourbiz.kinde.com/oauth2/agents/app_id/revoke" }

    it "C54: posts the token and the hint to the revoke endpoint with the application's credentials" do
      stub_request(:post, revoke_url).to_return(status: 200, body: "")

      kinde.revoke_token("refresh-token-value", "refresh_token")

      expect(
        a_request(:post, revoke_url).with(
          headers: {
            "Authorization" => AgentAuthHelpers::BASIC_HEADER,
            "Content-Type" => "application/x-www-form-urlencoded"
          },
          body: "token=refresh-token-value&token_type_hint=refresh_token"
        )
      ).to have_been_made.once
    end

    it "C55: leaves token_type_hint out when no hint is given", :aggregate_failures do
      stub_request(:post, revoke_url).to_return(status: 200, body: "")

      kinde.revoke_token("access-token-value")

      expect(a_request(:post, revoke_url).with(body: "token=access-token-value")).to have_been_made.once
      expect { kinde.revoke_token("  ") }.to raise_error(ArgumentError)
      expect { kinde.revoke_token(nil) }.to raise_error(ArgumentError)
    end

    it "C56: returns true on a 200" do
      stub_request(:post, revoke_url).to_return(status: 200, body: "{}")

      expect(kinde.revoke_token("access-token-value")).to be(true)
    end

    it "C57: raises KindeSdk::APIError on any other status", :aggregate_failures do
      [400, 500].each do |status|
        stub_request(:post, revoke_url).to_return(status: status, body: '{"error":"invalid_request"}')

        expect { kinde.revoke_token("access-token-value") }.to raise_error(KindeSdk::APIError) { |error|
          expect(error).to be_an_instance_of(KindeSdk::APIError)
          expect(error.message).to include(status.to_s)
          expect(error.message).not_to include("access-token-value")
          expect(error.message).not_to include("app_secret")
        }
      end
    end

    it "C58: raises UnavailableError on a timeout" do
      stub_request(:post, revoke_url).to_timeout

      expect { kinde.revoke_token("access-token-value") }.to raise_error(unavailable_error)
    end
  end

  describe "existing SDK behaviour" do
    it "C59: leaves the login configuration and the session middleware as they were", :aggregate_failures do
      config = KindeSdk::Configuration.new

      expect(config.scope).to eq("openid offline email profile")
      expect(config.jwks_url).to eq("/.well-known/jwks.json")
      expect(KindeSdk::Middleware).not_to equal(KindeSdk::AgentAuth::Middleware)
      expect(KindeSdk::Middleware.instance_method(:call).source_location.first).to end_with("lib/kinde_sdk/middleware.rb")
    end

    it "C60: uses nothing from Rails or ActiveSupport in the new files", :aggregate_failures do
      lib = File.expand_path("../lib/kinde_sdk", __dir__)
      files = Dir.glob(File.join(lib, "agent_auth*.rb")) + Dir.glob(File.join(lib, "agent_auth", "**", "*.rb"))

      expect(files.size).to be >= 10
      files.each do |file|
        source = File.read(file)
        %w[Rails ActionDispatch ActiveSupport .blank? .present? .presence].each do |forbidden|
          expect(source).not_to include(forbidden), "#{File.basename(file)} mentions #{forbidden}"
        end
      end
    end
  end
end
