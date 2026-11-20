require 'spec_helper'
require 'open3'
require 'rbconfig'
require 'kinde_sdk/agent_client/mcp'
require_relative 'support/agent_client_helpers'

# MCP client adapter: the settings and the store of a KindeSdk::AgentClient
# behind the official "mcp" gem's OAuth provider interface. Case ids (M1-M10)
# are the ones in the approved plan.
#
# There is no skip when the gem is missing: the require above fails loudly,
# because a silent skip would leave the adapter untested.
module AgentClientHelpers # so the constants of the helpers are in scope below
  RSpec.describe KindeSdk::AgentClient::KindeOAuthProvider do
    include AgentClientHelpers

    let(:clock) { AgentAuthHelpers::FakeClock.new(Time.now.to_i) }
    let(:store) { KindeSdk::AgentClient::MemoryStore.new }
    let(:agent) { cimd_client(storage: store) }
    # spec_helper sets Faraday's default adapter to :test; the gem's own
    # requests must go through Net::HTTP for WebMock to see them.
    let(:net_http) { ->(faraday) { faraday.adapter :net_http } }
    let(:provider) { described_class.new(agent, http_client_customizer: net_http) }
    let(:flow) { MCP::Client::OAuth::Flow.new(provider: provider) }
    let(:flow_error) { MCP::Client::OAuth::Flow::AuthorizationError }

    before do
      freeze_clock(clock)
      KindeSdk::AgentClient::Discovery.reset_cache!
      stub_prm({ "resource" => RESOURCE, "authorization_servers" => [ISSUER], "scopes_supported" => %w[openid offline] })
      stub_metadata
      stub_register(registration_response("client_secret_expires_at" => clock.now.to_i + (30 * 86_400)))
      stub_token
    end

    def provider_for(overrides = {})
      described_class.new(build_client({ storage: store }.merge(overrides)), http_client_customizer: net_http)
    end

    def run!(with = provider, **options)
      runner = MCP::Client::OAuth::Flow.new(provider: with)
      [runner.run!(server_url: RESOURCE, resource_metadata_url: PRM, **options), runner.authorization_url.to_s]
    end

    def without_warnings
      verbose = $VERBOSE
      $VERBOSE = nil
      yield
    ensure
      $VERBOSE = verbose
    end

    it "M1: is an OAuth provider of the mcp gem and wraps only a KindeSdk::AgentClient", :aggregate_failures do
      expect(provider).to be_a(MCP::Client::OAuth::Provider)
      expect(provider.agent_client).to equal(agent)
      expect(provider.authorization_flow).to eq(:authorization_code)
      expect(provider.callback_handler).to be_nil
      expect(provider.redirect_handler.call("https://example.com")).to be_nil
      expect(provider.pending_authorization_max_age).to eq(600)

      [nil, agent.config, "agent", KindeSdk::AgentAuth].each do |other|
        expect { described_class.new(other) }.to raise_error(ArgumentError, /KindeSdk::AgentClient/)
      end
      expect { provider_for(client_metadata_url: CIMD, client_id: "pre-registered") }
        .to raise_error(ArgumentError, /either client_metadata_url or client_id/)
    end

    it "M1: refuses a pending_authorization_max_age the stores would not keep an attempt for", :aggregate_failures do
      expect { described_class.new(agent, pending_authorization_max_age: 1800) }
        .to raise_error(ArgumentError, /pending_authorization_max_age must be 600 seconds or less/)
      expect { described_class.new(agent, pending_authorization_max_age: 601) }.to raise_error(ArgumentError, /600 seconds or less/)
      expect { described_class.new(agent, pending_authorization_max_age: 0) }.to raise_error(ArgumentError, /positive Integer/)

      short = described_class.new(agent, http_client_customizer: net_http, pending_authorization_max_age: 300)
      expect(short.pending_authorization_max_age).to eq(300)
      expect(described_class.new(agent, pending_authorization_max_age: 600).pending_authorization_max_age).to eq(600)

      _, url = run!(short)
      state = query_of(url)["state"]
      clock.advance(299)
      store.write("tokens", ["another"], {})
      expect(store.read("mcp_pending", [state])).not_to be_nil
      expect(short.finish!("code" => CODE, "state" => state)).to eq(:authorized)
    end

    it "M2: takes client metadata, redirect URI, metadata document URL and scope from the settings, never openid", :aggregate_failures do
      expect(provider.client_metadata).to eq(
        "redirect_uris" => [REDIRECT],
        "client_name" => "Kinde Ruby SDK agent",
        "grant_types" => %w[authorization_code refresh_token],
        "response_types" => ["code"],
        "token_endpoint_auth_method" => "none"
      )
      expect(provider.redirect_uri).to eq(REDIRECT)
      expect(provider.client_id_metadata_document_url).to eq(CIMD)
      expect(provider.scope).to eq("offline")
      expect(provider.storage).to be_a(KindeSdk::AgentClient::McpStorage)

      configured = provider_for(scopes: %w[openid offline profile], client_name: "My Agent")
      expect(configured.scope).to eq("offline profile")
      expect(configured.client_metadata["client_name"]).to eq("My Agent")
      expect(configured.client_id_metadata_document_url).to be_nil
      expect(provider_for(scopes: ["openid"]).scope).to be_nil
      expect(provider.scope_selector.call(%w[openid offline email])).to eq(%w[offline email])

      login = KindeSdk::Configuration.new { |c| c.scope = "openid profile email offline" }
      allow(KindeSdk).to receive(:config).and_return(login)
      expect(provider_for.scope).to eq("offline")
    end

    it "M3: keeps openid out of the request the gem builds, and refuses a challenge that demands it", :aggregate_failures do
      result, url = run!

      expect(result).to eq(:redirect)
      expect(url).to start_with("#{AUTHORIZE}?")
      expect(query_of(url)).to include(
        "scope" => "offline", "client_id" => CIMD, "redirect_uri" => REDIRECT,
        "code_challenge_method" => "S256", "resource" => RESOURCE, "response_type" => "code"
      )

      expect { run!(scope: "openid offline") }.to raise_error(MCP::Client::OAuth::Flow::AuthorizationRefusedError)
      expect(query_of(run!(scope: "offline profile").last)["scope"]).to eq("offline profile")
      expect(requests(:post, REGISTER)).to be_empty
    end

    it "M4: registers nothing with a supported metadata document, and keeps a registration in the core store otherwise", :aggregate_failures do
      run!
      expect(requests(:post, REGISTER)).to be_empty
      expect(store.read("mcp_registrations", [ISSUER, REDIRECT])).to be_nil

      stub_metadata(server_metadata("client_id_metadata_document_supported" => nil))
      _, url = run!

      expect(requests(:post, REGISTER).size).to eq(1)
      expect(JSON.parse(requests(:post, REGISTER).first.body)).to include(
        "redirect_uris" => [REDIRECT], "token_endpoint_auth_method" => "none", "grant_types" => %w[authorization_code refresh_token]
      )
      expect(query_of(url)["client_id"]).to eq(DCR_ID)
      expect(store.read("mcp_registrations", [ISSUER, REDIRECT])).to include(
        "client_id" => DCR_ID, "client_secret" => DCR_SECRET, "issuer" => ISSUER
      )
      expect(store.read("mcp_issuers", [RESOURCE, "default"])).to eq(ISSUER)

      run!
      expect(requests(:post, REGISTER).size).to eq(1)
    end

    it "M5: the sign-in attempt and the tokens live in the core store, and finish! exchanges the code", :aggregate_failures do
      result, url = run!
      state = query_of(url)["state"]
      pending = store.read("mcp_pending", [state])

      expect(result).to eq(:redirect)
      expect(pending).to include("code_verifier" => match(/\A[A-Za-z0-9\-._~]{43,128}\z/), "client_id" => CIMD, "redirect_uri" => REDIRECT)
      expect(provider.access_token).to be_nil

      expect { provider.finish!("code" => CODE, "state" => "made-up") }.to raise_error(flow_error)
      expect { provider.finish!("code" => CODE, "state" => state, "iss" => "https://evil.example") }.to raise_error(flow_error)
      expect(requests(:post, TOKEN)).to be_empty

      expect(provider.finish!("code" => CODE, "state" => state, "iss" => ISSUER)).to eq(:authorized)

      exchange = form_of(requests(:post, TOKEN).first)
      expect(exchange).to include(
        "grant_type" => "authorization_code", "code" => CODE, "code_verifier" => pending["code_verifier"],
        "client_id" => CIMD, "redirect_uri" => REDIRECT
      )
      expect(exchange).not_to have_key("client_secret")
      expect(store.read("mcp_tokens", [ISSUER, RESOURCE, "default"])).to include(
        "access_token" => ACCESS, "refresh_token" => REFRESH, "issuer" => ISSUER
      )
      expect(store.read("mcp_pending", [state])).to be_nil
      expect(provider.access_token).to eq(ACCESS)
      expect(provider_for(client_metadata_url: CIMD).access_token).to eq(ACCESS)
      expect(provider_for(client_metadata_url: CIMD, account: "someone-else").access_token).to be_nil
      expect { provider.finish!("code" => CODE, "state" => state) }.to raise_error(flow_error)

      expect(provider.storage.inspect).not_to match(/#{ACCESS}|#{REFRESH}/)
      expect(agent.token_info).to be_nil

      provider.clear_tokens!
      expect(provider.access_token).to be_nil
      expect(store.read("mcp_tokens", [ISSUER, RESOURCE, "default"])).to be_nil
    end

    it "M5: a registered client's secret is used at the token endpoint", :aggregate_failures do
      registered = provider_for
      stub_metadata(server_metadata("client_id_metadata_document_supported" => nil))
      _, url = run!(registered)

      expect(registered.finish!(code: CODE, state: query_of(url)["state"])).to eq(:authorized)
      expect(form_of(requests(:post, TOKEN).first)).to include("client_id" => DCR_ID, "client_secret" => DCR_SECRET)
    end

    it "M6: hides a registration that expires within a day, so the gem registers again", :aggregate_failures do
      stub_metadata(server_metadata("client_id_metadata_document_supported" => nil))
      registered = provider_for
      run!(registered)
      expect(registered.client_information).to include("client_id" => DCR_ID)

      clock.advance((29 * 86_400) - 60)
      expect(registered.client_information).to include("client_id" => DCR_ID)
      clock.advance(120)
      expect(registered.client_information).to be_nil

      stub_register(registration_response("client_id" => "dcr-client-id-two", "client_secret_expires_at" => clock.now.to_i + (30 * 86_400)))
      _, url = run!(registered)
      expect(requests(:post, REGISTER).size).to eq(2)
      expect(query_of(url)["client_id"]).to eq("dcr-client-id-two")
      expect(registered.client_information).to include("client_id" => "dcr-client-id-two")
    end

    it "M6: hands the gem a configured client without copying its secret into the store", :aggregate_failures do
      configured = provider_for(client_id: "pre-registered", client_secret: "configured-secret-value", issuer: ISSUER)
      expect(configured.client_information)
        .to eq("client_id" => "pre-registered", "client_secret" => "configured-secret-value", "issuer" => ISSUER)
      expect(provider_for(client_id: "pre-registered").client_information).to eq("client_id" => "pre-registered")

      _, url = run!(configured)
      expect(query_of(url)["client_id"]).to eq("pre-registered")
      expect(requests(:post, REGISTER)).to be_empty
      expect(configured.client_information).to include("client_id" => "pre-registered", "issuer" => ISSUER)
      expect(store.read("mcp_registrations", [ISSUER, REDIRECT])).to be_nil

      expect(configured.finish!("code" => CODE, "state" => query_of(url)["state"])).to eq(:authorized)
      expect(configured.access_token).to eq(ACCESS)
      expect(JSON.generate(store.instance_variable_get(:@data))).not_to include("configured-secret-value")
    end

    describe "a configured client is bound to its issuer" do
      let(:secret) { "configured-secret-value" }
      let(:other) { "https://evil.example/as" }
      let(:bound) { provider_for(client_id: "pre-registered", client_secret: secret, issuer: ISSUER) }

      # The resource names another authorization server than the configured issuer.
      def stub_other_server
        stub_prm({ "resource" => RESOURCE, "authorization_servers" => [other], "scopes_supported" => ["offline"] })
        stub_request(:get, %r{\Ahttps://evil\.example/}).to_return(
          json_response(server_metadata(
                          "issuer" => other, "authorization_endpoint" => "#{other}/authorize", "token_endpoint" => "#{other}/token",
                          "registration_endpoint" => "#{other}/register", "revocation_endpoint" => nil,
                          "token_endpoint_auth_methods_supported" => %w[client_secret_basic none],
                          "client_id_metadata_document_supported" => nil
                        ))
        )
        stub_register(registration_response("client_id" => "other-dcr-id", "client_secret" => nil,
                                            "client_secret_expires_at" => 0, "token_endpoint_auth_method" => "none"),
                      url: "#{other}/register")
        stub_token(url: "#{other}/token")
      end

      # Every request that carries +value+ in its URL, its body or a header (also inside a Basic header).
      def requests_carrying(value)
        requests.select do |request|
          headers = request.headers.to_h.values.map(&:to_s)
          basic = headers.filter_map { |header| header[/\ABasic (.+)\z/, 1] }.map { |pair| URI.decode_www_form_component(Base64.decode64(pair)) }
          ([request.uri.to_s, request.body.to_s] + headers + basic).any? { |text| text.include?(value) }
        end
      end

      it "M6: at the configured issuer the gem authenticates with the configured secret", :aggregate_failures do
        _, url = run!(bound)
        expect(bound.finish!("code" => CODE, "state" => query_of(url)["state"])).to eq(:authorized)

        expect(requests_carrying(secret).map { |request| request_url(request) }).to eq([TOKEN])
        expect(requests(:post, TOKEN).first.headers["Authorization"]).to eq("Basic #{Base64.strict_encode64("pre-registered:#{secret}")}")
        expect(requests(:post, REGISTER)).to be_empty
      end

      it "M6: a resource that names another authorization server never receives the secret", :aggregate_failures do
        stub_other_server

        _, url = run!(bound)
        expect(url).to start_with("#{other}/authorize?")
        expect(query_of(url)["client_id"]).to eq("other-dcr-id")
        expect(bound.client_information).to include("client_id" => "other-dcr-id", "issuer" => other)
        expect(bound.client_information).not_to have_key("client_secret")

        expect(bound.finish!("code" => CODE, "state" => query_of(url)["state"])).to eq(:authorized)
        expect(form_of(requests(:post, "#{other}/token").last)).to include("grant_type" => "authorization_code", "client_id" => "other-dcr-id")

        runner = MCP::Client::OAuth::Flow.new(provider: bound)
        expect(runner.refresh!(server_url: RESOURCE, resource_metadata_url: PRM)).to eq(:refreshed)
        expect(form_of(requests(:post, "#{other}/token").last)).to include("grant_type" => "refresh_token", "client_id" => "other-dcr-id")

        expect(requests.count { |request| request.uri.host == "evil.example" }).to be >= 4
        expect(requests_carrying(secret)).to be_empty
        expect(requests_carrying("pre-registered")).to be_empty
        expect(JSON.generate(store.instance_variable_get(:@data))).not_to include(secret)
      end

      it "M6: when the resource moves to another authorization server, the secret stays with the configured one", :aggregate_failures do
        _, url = run!(bound)
        bound.finish!("code" => CODE, "state" => query_of(url)["state"])
        expect(store.read("mcp_issuers", [RESOURCE, "default"])).to eq(ISSUER)
        sent = requests_carrying(secret).size

        stub_other_server
        runner = MCP::Client::OAuth::Flow.new(provider: bound)
        expect { runner.refresh!(server_url: RESOURCE, resource_metadata_url: PRM) }.to raise_error(flow_error)

        _, url = run!(bound)
        expect(query_of(url)["client_id"]).to eq("other-dcr-id")
        expect(bound.finish!("code" => CODE, "state" => query_of(url)["state"])).to eq(:authorized)
        expect(runner.refresh!(server_url: RESOURCE, resource_metadata_url: PRM)).to eq(:refreshed)

        expect(requests_carrying(secret).size).to eq(sent)
        expect(requests_carrying(secret).map { |request| request.uri.host }.uniq).to eq(["yourbiz.kinde.com"])
      end

      it "M6: back at the configured issuer after another one, the same sign-in uses the configured client", :aggregate_failures do
        stub_other_server
        _, url = run!(bound)
        expect(bound.finish!("code" => CODE, "state" => query_of(url)["state"])).to eq(:authorized)
        expect(store.read("mcp_issuers", [RESOURCE, "default"])).to eq(other)
        expect(store.read("mcp_registrations", [other, REDIRECT])).to include("client_id" => "other-dcr-id")

        stub_prm({ "resource" => RESOURCE, "authorization_servers" => [ISSUER], "scopes_supported" => ["offline"] })
        _, url = run!(bound)
        expect(url).to start_with("#{AUTHORIZE}?")
        expect(query_of(url)["client_id"]).to eq("pre-registered")
        expect(requests(:post, REGISTER)).to be_empty
        expect(store.read("mcp_registrations", [other, REDIRECT])).to be_nil
        expect(store.read("mcp_tokens", [other, RESOURCE, "default"])).to be_nil

        # The callback arrives in another request: a new provider on the same store.
        callback = provider_for(client_id: "pre-registered", client_secret: secret, issuer: ISSUER)
        expect(callback.finish!("code" => CODE, "state" => query_of(url)["state"])).to eq(:authorized)
        expect(requests(:post, TOKEN).last.headers["Authorization"]).to eq("Basic #{Base64.strict_encode64("pre-registered:#{secret}")}")
        expect(store.read("mcp_issuers", [RESOURCE, "default"])).to eq(ISSUER)
        expect(requests(:post, REGISTER)).to be_empty
        expect(requests_carrying(secret).map { |request| request_url(request) }).to eq([TOKEN])
        expect(JSON.generate(store.instance_variable_get(:@data))).not_to include(secret)
      end

      it "M6: back at the configured issuer, a refused request leaves what is kept for the other server", :aggregate_failures do
        stub_other_server
        _, url = run!(bound)
        bound.finish!("code" => CODE, "state" => query_of(url)["state"])

        stub_prm({ "resource" => RESOURCE, "authorization_servers" => [ISSUER], "scopes_supported" => ["offline"] })
        expect { run!(bound, scope: "openid offline") }.to raise_error(MCP::Client::OAuth::Flow::AuthorizationRefusedError)
        expect(store.read("mcp_issuers", [RESOURCE, "default"])).to eq(other)
        expect(store.read("mcp_registrations", [other, REDIRECT])).to include("client_id" => "other-dcr-id")
      end

      it "M6: with issuer set, refuses a client ID the gem would use at every authorization server", :aggregate_failures do
        expect { provider_for(client_id: "https://agent.example.com/client", client_secret: secret, issuer: ISSUER) }
          .to raise_error(ArgumentError, /client_id must not be an https URL with a path when issuer is set/)
        expect { KindeSdk::AgentClient::McpStorage.new(build_client(client_id: CIMD, issuer: ISSUER).config) }
          .to raise_error(ArgumentError, /when issuer is set/)
        expect(provider_for(client_id: "https://agent.example.com/client").client_information)
          .to eq("client_id" => "https://agent.example.com/client")
      end
    end

    it "M7: works on a SessionStore, across two requests that share only the session", :aggregate_failures do
      session = {}
      first = described_class.new(
        cimd_client(storage: KindeSdk::AgentClient::SessionStore.new(session)), http_client_customizer: net_http
      )
      _, url = run!(first)
      expect(JSON.parse(JSON.generate(session))).to eq(session)

      later_session = JSON.parse(JSON.generate(session))
      second = described_class.new(
        cimd_client(storage: KindeSdk::AgentClient::SessionStore.new(later_session)), http_client_customizer: net_http
      )
      expect(second.finish!("code" => CODE, "state" => query_of(url)["state"])).to eq(:authorized)
      expect(second.access_token).to eq(ACCESS)
      expect(later_session.keys).to eq(["kinde_agent_client"])
      expect(later_session["kinde_agent_client"].keys).to include("mcp_tokens", "mcp_issuers")
    end

    describe "optional dependency" do
      let(:root) { File.expand_path("..", __dir__) }
      let(:adapter_path) { File.join(root, "lib", "kinde_sdk", "agent_client", "mcp.rb") }

      it "M8: nothing but the adapter file loads the mcp client code", :aggregate_failures do
        requires_mcp = %r{^\s*require(_relative)?[\s(]+["'](mcp|(\S*/)?agent_(client|auth)/mcp)["']}
        server_adapter_path = File.join(root, "lib", "kinde_sdk", "agent_auth", "mcp.rb")
        others = Dir.glob(File.join(root, "lib", "**", "*.rb")) - [adapter_path, server_adapter_path]

        expect(others.size).to be >= 20
        expect(File.read(adapter_path)).to match(requires_mcp)
        others.each do |file|
          expect(File.read(file)).not_to match(requires_mcp), "#{file} requires the mcp gem or an MCP adapter"
        end
        expect(File.read(File.join(root, "kinde_sdk.gemspec"))).not_to match(/\bmcp\b/)

        script = 'require "kinde_sdk"; ' \
                 'print [defined?(::MCP).inspect, KindeSdk::AgentClient.const_defined?(:KindeOAuthProvider, false), ' \
                 'KindeSdk::AgentClient.const_defined?(:McpStorage, false)].join(",")'
        stdout, stderr, status = Open3.capture3(
          RbConfig.ruby, "-I", File.join(root, "lib"), "-I", File.join(root, "kinde_api", "lib"), "-e", script
        )
        expect(status).to be_success, stderr
        expect(stdout).to eq("nil,false,false")
      end

      it "M8: fails to load with an install hint when the mcp gem is missing or too old", :aggregate_failures do
        main = TOPLEVEL_BINDING.receiver

        stub_const("MCP::VERSION", "1.9.0")
        expect { without_warnings { load adapter_path } }.to raise_error(LoadError, /agent_client\/mcp needs the "mcp" gem >= 1\.10\.0/)

        missing = LoadError.new("cannot load such file -- mcp")
        missing.instance_variable_set(:@path, "mcp")
        allow(main).to receive(:require).and_call_original
        allow(main).to receive(:require).with("mcp").and_raise(missing)
        expect { without_warnings { load adapter_path } }
          .to raise_error(LoadError, /Add `gem "mcp", ">= 1\.10\.0"` to your Gemfile/)

        other = LoadError.new("cannot load such file -- json_schemer")
        other.instance_variable_set(:@path, "json_schemer")
        allow(main).to receive(:require).with("mcp").and_raise(other)
        expect { without_warnings { load adapter_path } }.to raise_error(LoadError) { |error| expect(error).to equal(other) }

        expect(KindeSdk::AgentClient::MCP_MINIMUM_VERSION).to eq("1.10.0")
      end
    end

    it "M9: the gem's HTTP transport accepts the provider", :aggregate_failures do
      transport = MCP::Client::HTTP.new(url: RESOURCE, oauth: provider)

      expect(transport.oauth).to equal(provider)
      expect(MCP::Client.new(transport: transport)).to be_a(MCP::Client)
      expect { MCP::Client::HTTP.new(url: "http://localhost:3001/mcp", oauth: provider) }.not_to raise_error
    end

    it "M10: the MCP client example from the README builds a provider on the session", :aggregate_failures do
      session = {}
      scope = binding
      eval(readme_ruby_example(/KindeOAuthProvider\.new/), scope, "README.md") # rubocop:disable Security/Eval
      built = scope.local_variable_get(:provider)

      expect(session).to eq({})
      expect(built).to be_a(described_class)
      expect(built.client_id_metadata_document_url).to eq(CIMD)
      expect(built.scope).to eq("offline")
      expect(scope.local_variable_get(:mcp_client)).to be_a(MCP::Client)

      built.storage.save_tokens("access_token" => ACCESS, "issuer" => ISSUER)
      expect(session["kinde_agent_client"]["mcp_tokens"].values).to eq([{ "access_token" => ACCESS, "issuer" => ISSUER }])
      expect(readme_ruby_example(/AuthorizationPendingError/)).to include("provider.finish!(request.query_parameters)")
    end
  end
end
