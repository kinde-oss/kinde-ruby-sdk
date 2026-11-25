require 'spec_helper'
require 'open3'
require 'rbconfig'
require 'rack'
require 'kinde_sdk/agent_auth/mcp'
require_relative 'support/agent_auth_helpers'

# MCP adapter: KindeSdk::AgentAuth behind the official "mcp" gem's token
# verifier interface. Case ids (A1-A16) are the ones in the approved plan.
#
# There is no skip when the gem is missing: the require above fails loudly,
# because a silent skip would leave the adapter untested.
RSpec.describe KindeSdk::AgentAuth::KindeTokenVerifier do
  include AgentAuthHelpers

  let(:kinde) { build_agent_auth }
  let(:jwt_kinde) { build_agent_auth(verification: "jwt") }
  let(:verifier) { described_class.new(kinde) }
  let(:jwt_verifier) { described_class.new(jwt_kinde) }
  let(:expiry) { Time.now.to_i + 3600 }
  let(:claims) { token_claims("exp" => expiry) }
  let(:token) { sign_token(claims) }
  let(:prm_url) { AgentAuthHelpers::PRM_URL }

  let(:mcp_invalid_token) { MCP::Server::OAuth::InvalidTokenError }
  let(:unavailable_error) { KindeSdk::AgentAuth::UnavailableError }

  # Every server_context the tool was called with.
  let(:tool_calls) { [] }
  let(:tool) do
    calls = tool_calls
    MCP::Tool.define(name: "whoami", description: "Says who is calling") do |server_context:|
      calls << server_context
      MCP::Tool::Response.new([{ type: "text", text: "ok" }])
    end
  end

  # Every env the app behind the gem's middleware was called with.
  let(:app_calls) { [] }
  let(:downstream) do
    lambda do |env|
      app_calls << env
      [200, { "content-type" => "text/plain" }, ["downstream"]]
    end
  end

  # The gem's bearer middleware: the counterpart of requireBearerAuth.
  def gem_middleware(with = verifier)
    MCP::Server::OAuth::Middleware.new(downstream, token_verifier: with, resource_metadata: with.resource_metadata)
  end

  # The gem's HTTP transport with its built-in enforcement: the counterpart of MCPServer.
  def transport(with = verifier)
    server = MCP::Server.new(name: "spec", tools: [tool])
    MCP::Server::Transports::StreamableHTTPTransport.new(
      server,
      stateless: true,
      token_verifier: with,
      resource_metadata: with.resource_metadata,
      allowed_hosts: ["api.example.com"]
    )
  end

  def post(app, authorization: nil, body: tool_call("whoami"), path: "/mcp")
    env = {
      "HTTP_HOST" => "api.example.com",
      "CONTENT_TYPE" => "application/json",
      "HTTP_ACCEPT" => "application/json, text/event-stream",
      input: JSON.generate(body)
    }
    env["HTTP_AUTHORIZATION"] = authorization if authorization
    Rack::MockRequest.new(app).post(path, env)
  end

  def tool_call(name)
    { jsonrpc: "2.0", id: 1, method: "tools/call", params: { name: name, arguments: {} } }
  end

  def bearer(value = token)
    "Bearer #{value}"
  end

  def without_warnings
    verbose = $VERBOSE
    $VERBOSE = nil
    yield
  ensure
    $VERBOSE = verbose
  end

  describe ".new" do
    it "A1: is a token verifier of the mcp gem and wraps only a KindeSdk::AgentAuth", :aggregate_failures do
      expect(verifier).to be_a(MCP::Server::OAuth::TokenVerifier)
      expect(verifier).to respond_to(:verify)
      expect(verifier.agent_auth).to equal(kinde)

      [nil, "kinde", kinde.config, { client_id: "app_id" }].each do |other|
        expect { described_class.new(other) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#verify" do
    it "A2: maps an active token to the gem's AccessToken with expiry, resource and the Kinde claims", :aggregate_failures do
      stub_introspection(introspection_body("exp" => expiry))

      access_token = verifier.verify(token)

      expect(access_token).to be_an_instance_of(MCP::Server::OAuth::AccessToken)
      expect(access_token.token).to eq(token)
      expect(access_token.expires_at).to eq(expiry)
      expect(access_token.expires_at).to be_an(Integer)
      expect(access_token.resource).to eq("https://api.example.com/mcp")
      expect(access_token.subject).to eq("kp_user_1")
      expect(access_token.client_id).to eq("https://claude.ai/oauth/claude-code-client-metadata")
      expect(access_token.scopes).to eq(["offline"])
      expect(access_token.issuer).to eq("https://yourbiz.kinde.com")
      expect(access_token.audience).to eq(["https://api.example.com/mcp"])
      expect(access_token.claims["permissions"]).to eq(["read:docs"])
      expect(access_token.claims["roles"]).to eq([{ "id" => "role_1", "key" => "admin", "name" => "Admin" }])
      expect(access_token.claims["org_code"]).to eq("org_123")
      expect(access_token).not_to be_expired
    end

    it "A3: sets the same fields in jwt mode without calling introspection", :aggregate_failures do
      stub_jwks

      access_token = jwt_verifier.verify(token)

      expect(access_token).to be_an_instance_of(MCP::Server::OAuth::AccessToken)
      expect(access_token.token).to eq(token)
      expect(access_token.expires_at).to eq(expiry)
      expect(access_token.resource).to eq("https://api.example.com/mcp")
      expect(access_token.subject).to eq("kp_user_1")
      expect(access_token.client_id).to eq("https://claude.ai/oauth/claude-code-client-metadata")
      expect(access_token.scopes).to eq(["offline"])
      expect(access_token.issuer).to eq("https://yourbiz.kinde.com")
      expect(access_token.audience).to eq(["https://api.example.com/mcp"])
      expect(access_token.claims).to include("permissions" => ["read:docs"], "org_code" => "org_123")
      expect(a_request(:post, AgentAuthHelpers::INTROSPECT_URL)).not_to have_been_made
    end

    it "A4: raises the gem's InvalidTokenError, with the core's description, for every rejected token", :aggregate_failures do
      stub_jwks
      rejections = [
        [verifier, token, -> { stub_introspection({ "active" => false }) }],
        [verifier, token, -> { stub_introspection(introspection_body("aud" => ["https://other.example.com/mcp"])) }],
        [jwt_verifier, sign_token(claims, key: AgentAuthHelpers::OTHER_RSA_KEY), nil],
        [jwt_verifier, sign_token(claims.merge("iss" => AgentAuthHelpers::ISSUER)), nil],
        [jwt_verifier, sign_token(claims.merge("aud" => ["https://other.example.com/mcp"])), nil],
        [jwt_verifier, sign_token(claims.merge("exp" => Time.now.to_i - 120)), nil]
      ]

      rejections.each do |subject_verifier, bad_token, arrange|
        arrange&.call
        core_message = begin
          subject_verifier.agent_auth.verify_access_token(bad_token)
          nil
        rescue KindeSdk::AgentAuth::InvalidTokenError => e
          e.message
        end
        expect(core_message).to be_a(String)

        result = :nothing_returned
        expect { result = subject_verifier.verify(bad_token) }.to raise_error(mcp_invalid_token) { |error|
          expect(error).to be_a(MCP::Server::OAuth::Error)
          expect(error).not_to be_a(KindeSdk::Error)
          expect(error.message).to eq(core_message)
        }
        expect(result).to eq(:nothing_returned)
      end
    end

    it "A5: rejects a token with no expiry and returns a Float expiry as an Integer", :aggregate_failures do
      no_expiry = sign_token(claims.reject { |key, _| key == "exp" })
      stub_introspection(introspection_body.reject { |key, _| key == "exp" })
      expect(kinde.verify_access_token(no_expiry).expires_at).to be_nil
      expect { verifier.verify(no_expiry) }.to raise_error(mcp_invalid_token, /expiry/)

      stub_introspection(introspection_body("exp" => expiry + 0.75))
      access_token = verifier.verify(token)
      expect(access_token.expires_at).to be_an(Integer)
      expect(access_token.expires_at).to eq(expiry)
    end

    it "A6: lets a Kinde outage through as UnavailableError, not as a token rejection", :aggregate_failures do
      outages = [
        [verifier, -> { stub_introspection("oops", status: 500) }],
        [verifier, -> { stub_request(:post, AgentAuthHelpers::INTROSPECT_URL).to_timeout }],
        [jwt_verifier, -> { stub_request(:get, AgentAuthHelpers::JWKS_URL).to_return(status: 500, body: "oops") }]
      ]

      outages.each do |subject_verifier, arrange|
        arrange.call
        result = :nothing_returned
        expect { result = subject_verifier.verify(token) }.to raise_error(unavailable_error) { |error|
          expect(error).not_to be_a(MCP::Server::OAuth::Error)
        }
        expect(result).to eq(:nothing_returned)
      end
    end

    it "A7: keeps tokens and the client secret out of messages and inspect output", :aggregate_failures do
      marker = "MARKER-do-not-echo-9f3a"
      stub_introspection({ "active" => false })
      stub_jwks

      [[verifier, marker], [jwt_verifier, marker], [jwt_verifier, sign_token(claims.merge("iss" => marker), kid: marker)]].each do |subject_verifier, bad_token|
        expect { subject_verifier.verify(bad_token) }.to raise_error(mcp_invalid_token) { |error|
          expect(error.message).not_to include(marker)
        }
      end

      secret_holder = described_class.new(build_agent_auth(client_secret: "super-secret-value"))
      expect(secret_holder.inspect).not_to include("super-secret-value")

      stub_introspection(introspection_body("exp" => expiry))
      access_token = verifier.verify(token)
      expect(access_token.inspect).not_to include(token)
      expect(access_token.to_h.to_s).not_to include(token)
    end
  end

  describe "#resource_metadata" do
    it "A8: describes the resource to the gem with the scoped issuer and the offline scope", :aggregate_failures do
      metadata = verifier.resource_metadata

      expect(metadata).to be_an_instance_of(MCP::Server::OAuth::ProtectedResourceMetadata)
      expect(metadata.resource).to eq("https://api.example.com/mcp")
      expect(metadata.authorization_servers).to eq(["https://yourbiz.kinde.com/oauth2/agents/app_id"])
      expect(metadata.authorization_servers).not_to include("https://yourbiz.kinde.com")
      expect(metadata.scopes_supported).to eq(["offline"])
      expect(metadata.resource_name).to be_nil
      expect(metadata.well_known_path).to eq(kinde.config.prm_path)
      expect(metadata.well_known_url).to eq(kinde.config.prm_url)
      expect(verifier.resource_metadata).to equal(metadata)
      expect(JSON.parse(metadata.to_json)).to eq(kinde.protected_resource_metadata)

      custom = build_agent_auth(
        resource_url: "https://api.example.com:8443/v1/mcp", scopes_supported: %w[profile email], resource_name: "Docs MCP"
      )
      custom_metadata = described_class.new(custom).resource_metadata
      expect(custom_metadata.scopes_supported).to eq(%w[profile email offline])
      expect(custom_metadata.resource_name).to eq("Docs MCP")
      expect(custom_metadata.well_known_path).to eq(custom.config.prm_path)
      expect(custom_metadata.well_known_url).to eq("https://api.example.com:8443/.well-known/oauth-protected-resource/v1/mcp")
      expect(custom_metadata.well_known_url).to eq(custom.config.prm_url)
    end
  end

  describe "through the mcp gem's HTTP layer" do
    it "A9: an invalid token gets 401, not 500, from the gem's middleware", :aggregate_failures do
      stub_introspection({ "active" => false })
      stub_jwks
      forged = sign_token(claims, key: AgentAuthHelpers::OTHER_RSA_KEY)

      [[gem_middleware, token], [gem_middleware(jwt_verifier), forged]].each do |app, bad_token|
        response = post(app, authorization: bearer(bad_token))

        expect(response.status).to eq(401)
        expect(response.headers["www-authenticate"]).to include('error="invalid_token"')
        expect(response.headers["www-authenticate"]).to include(%(resource_metadata="#{prm_url}"))
        expect(JSON.parse(response.body)).to include("error" => "invalid_token")
      end
      expect(app_calls).to be_empty
    end

    it "A10: an invalid or missing token gets the 401 challenge from the transport", :aggregate_failures do
      stub_introspection({ "active" => false })
      app = transport

      inactive = post(app, authorization: bearer)
      expect(inactive.status).to eq(401)
      expect(inactive.headers["www-authenticate"]).to include('error="invalid_token"')
      expect(inactive.headers["www-authenticate"]).to include(%(resource_metadata="#{prm_url}"))
      expect(JSON.parse(inactive.body)).to include("error" => "invalid_token")

      missing = post(app)
      expect(missing.status).to eq(401)
      expect(missing.headers["www-authenticate"]).to include(%(resource_metadata="#{prm_url}"))
      expect(missing.headers["www-authenticate"]).not_to include("error=")

      expect(tool_calls).to be_empty
    end

    it "A11: a Kinde outage is the gem's 500 server_error, never 401", :aggregate_failures do
      outages = [
        -> { stub_introspection("oops", status: 500) },
        -> { stub_request(:post, AgentAuthHelpers::INTROSPECT_URL).to_timeout }
      ]

      outages.each do |arrange|
        arrange.call

        [gem_middleware, transport].each do |app|
          response = post(app, authorization: bearer)

          expect(response.status).to eq(500)
          expect(response.status).not_to eq(401)
          expect(response.body).to eq('{"error":"server_error"}')
          expect(response.headers["www-authenticate"]).to be_nil
        end
      end
      expect(app_calls).to be_empty
      expect(tool_calls).to be_empty
    end

    it "A12: a valid token reaches the tool with expiry, resource and the Kinde claims", :aggregate_failures do
      stub_introspection(introspection_body("exp" => expiry))

      response = post(transport, authorization: bearer)

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).dig("result", "isError")).to be(false)
      expect(tool_calls.size).to eq(1)

      server_context = tool_calls.first
      auth_info = server_context.auth_info
      expect(auth_info).to be_an_instance_of(MCP::Server::OAuth::AccessToken)
      expect(auth_info.expires_at).to eq(expiry)
      expect(auth_info.resource).to eq("https://api.example.com/mcp")

      core = kinde.verify_access_token(token)
      auth = described_class.auth_context(server_context)
      expect(auth).to be_a(KindeSdk::AgentAuth::AuthContext)
      expect(auth.user_id).to eq(core.user_id)
      expect(auth.permissions).to eq(core.permissions)
      expect(auth.roles).to eq(core.roles)
      expect(auth.org_code).to eq(core.org_code)
      expect(KindeSdk::AgentAuth.has_permission?(auth, "read:docs")).to be(true)
      expect(KindeSdk::AgentAuth.has_permission?(auth, "write:docs")).to be(false)
      expect(described_class.auth_context(auth_info).user_id).to eq("kp_user_1")

      via_middleware = post(gem_middleware, authorization: bearer)
      expect(via_middleware.status).to eq(200)
      expect(app_calls.first["mcp.auth_info"]).to be_an_instance_of(MCP::Server::OAuth::AccessToken)
      expect(app_calls.first["mcp.auth_info"].subject).to eq("kp_user_1")

      # The gem hands the token over as a binary-encoded String.
      expect(verifier.verify(token.b).subject).to eq("kp_user_1")
    end
  end

  describe ".auth_context" do
    it "A13: returns nothing usable, and never raises, when the request was not authenticated", :aggregate_failures do
      anonymous = MCP::ServerContext.new(nil, progress: nil, notification_target: nil)
      empty_claims = MCP::Server::OAuth::AccessToken.new(token: "t")

      expect(anonymous.auth_info).to be_nil
      [nil, anonymous, empty_claims, "not a context", Object.new].each do |source|
        auth = nil
        expect { auth = described_class.auth_context(source) }.not_to raise_error
        expect(KindeSdk::AgentAuth.has_permission?(auth, "read:docs")).to be(false)
      end
      expect(described_class.auth_context(nil)).to be_nil
      expect(described_class.auth_context(anonymous)).to be_nil
      expect(described_class.auth_context(empty_claims).permissions).to eq([])
    end
  end

  describe "README example" do
    after { Object.send(:remove_const, :ReadDocs) if Object.const_defined?(:ReadDocs) }

    it "A14: the MCP example from the README serves the metadata, challenges and reports a missing permission as a tool error", :aggregate_failures do
      stub_readme_environment
      app = Rack::Builder.new_from_string(readme_ruby_example(/ProtectedResourceMetadataMiddleware/), "README.md")

      prm = Rack::MockRequest.new(app).get(AgentAuthHelpers::PRM_PATH, "HTTP_HOST" => "api.example.com")
      expect(prm.status).to eq(200)
      expect(JSON.parse(prm.body)).to include(
        "resource" => "https://api.example.com/mcp",
        "authorization_servers" => ["https://yourbiz.kinde.com/oauth2/agents/app_id"]
      )
      expect(JSON.parse(prm.body)["scopes_supported"]).to include("offline")

      challenge = post(app)
      expect(challenge.status).to eq(401)
      expect(challenge.headers["www-authenticate"]).to include(%(resource_metadata="#{prm_url}"))
      expect(challenge.headers["www-authenticate"]).to match(/scope="[^"]*\boffline\b[^"]*"/)

      stub_introspection(introspection_body("exp" => expiry))
      without_permission = sign_token(claims.merge("permissions" => ["other:thing"]))
      denied = post(app, authorization: bearer(without_permission), body: tool_call("read_docs"))
      expect(denied.status).to eq(200)
      expect(JSON.parse(denied.body).dig("result", "isError")).to be(true)

      granted = post(app, authorization: bearer, body: tool_call("read_docs"))
      expect(granted.status).to eq(200)
      expect(JSON.parse(granted.body).dig("result", "isError")).to be(false)
      expect(JSON.parse(granted.body).dig("result", "content", 0, "text")).to eq("Here are the docs.")
    end
  end

  describe "optional dependency" do
    let(:root) { File.expand_path("..", __dir__) }
    let(:adapter_path) { File.join(root, "lib", "kinde_sdk", "agent_auth", "mcp.rb") }

    it "A15: nothing but the adapter file loads the mcp gem", :aggregate_failures do
      requires_mcp = %r{^\s*require(_relative)?[\s(]+["'](mcp|(\S*/)?agent_auth/mcp)["']}
      others = Dir.glob(File.join(root, "lib", "**", "*.rb")) - [adapter_path, File.join(root, "lib", "kinde_sdk", "agent_client", "mcp.rb")]

      expect(others).not_to be_empty
      expect(File.read(adapter_path)).to match(requires_mcp)
      others.each do |file|
        expect(File.read(file)).not_to match(requires_mcp), "#{file} requires the mcp gem or the adapter"
      end
      expect(File.read(File.join(root, "kinde_sdk.gemspec"))).not_to match(/\bmcp\b/)

      script = 'require "kinde_sdk"; ' \
               'print [defined?(::MCP).inspect, KindeSdk::AgentAuth.const_defined?(:KindeTokenVerifier, false)].join(",")'
      stdout, stderr, status = Open3.capture3(
        RbConfig.ruby, "-I", File.join(root, "lib"), "-I", File.join(root, "kinde_api", "lib"), "-e", script
      )
      expect(status).to be_success, stderr
      expect(stdout).to eq("nil,false")
    end

    it "A16: fails to load with an install hint when the mcp gem is missing or too old", :aggregate_failures do
      main = TOPLEVEL_BINDING.receiver

      stub_const("MCP::VERSION", "1.9.0")
      expect { without_warnings { load adapter_path } }.to raise_error(LoadError, /1\.10\.0/)

      missing = LoadError.new("cannot load such file -- mcp")
      missing.instance_variable_set(:@path, "mcp")
      expect(missing.path).to eq("mcp")
      allow(main).to receive(:require).and_call_original
      allow(main).to receive(:require).with("mcp").and_raise(missing)
      expect { without_warnings { load adapter_path } }
        .to raise_error(LoadError, /Add `gem "mcp", ">= 1\.10\.0"` to your Gemfile/)

      other = LoadError.new("cannot load such file -- json_schemer")
      other.instance_variable_set(:@path, "json_schemer")
      allow(main).to receive(:require).with("mcp").and_raise(other)
      expect { without_warnings { load adapter_path } }.to raise_error(LoadError) { |error| expect(error).to equal(other) }

      expect(KindeSdk::AgentAuth::MCP_MINIMUM_VERSION).to eq("1.10.0")
    end
  end
end
