require 'spec_helper'
require_relative 'support/agent_client_helpers'

# Core of the agent-client helpers: discovery, client identity, sign-in,
# token storage, calling the resource, refresh and disconnect, against a fake
# resource server and a fake authorization server made of WebMock stubs.
# Case ids (C1-C85) are the ones in the approved plan; there is no C83.
# C86-C101 came out of review.
module AgentClientHelpers # so the constants of the helpers are in scope below
  RSpec.describe KindeSdk::AgentClient do
    include AgentClientHelpers

    let(:clock) { AgentAuthHelpers::FakeClock.new(NOW) }
    let(:store) { KindeSdk::AgentClient::MemoryStore.new }
    # Identified by a client ID metadata document: no registration call.
    let(:client) { cimd_client(storage: store) }
    # No identity configured: registers itself.
    let(:dcr_client) { build_client(storage: store) }
    # The tokens the fake resource accepts; specs change it to expire a token.
    let(:valid) { [ACCESS] }

    let(:authorization_required) { KindeSdk::AgentClient::AuthorizationRequiredError }
    let(:discovery_error) { KindeSdk::AgentClient::DiscoveryError }
    let(:callback_error) { KindeSdk::AgentClient::CallbackError }
    let(:oauth_error) { KindeSdk::AgentClient::OAuthError }
    let(:registration_error) { KindeSdk::AgentClient::RegistrationError }
    let(:unavailable_error) { KindeSdk::AgentClient::UnavailableError }

    # What the SDK logged; nothing is printed while the specs run.
    let(:logs) { capture_logs }

    before do
      logs
      freeze_clock(clock)
      KindeSdk::AgentClient::Discovery.reset_cache!
      stub_kinde(valid: valid)
    end

    def token_requests(grant_type = nil, url: TOKEN)
      requests(:post, url).select { |request| grant_type.nil? || form_of(request)["grant_type"] == grant_type }
    end

    def resource_requests(url: RESOURCE)
      requests.select { |request| request_url(request) == url }
    end

    def bearer_of(request)
      request.headers["Authorization"].to_s[/\ABearer (.+)\z/, 1]
    end

    # The error a block raises when the user has to sign in.
    def sign_in_needed
      yield
      raise "expected AuthorizationRequiredError"
    rescue KindeSdk::AgentClient::AuthorizationRequiredError => e
      e
    end

    def expire_access_token
      valid.replace([NEW_ACCESS])
    end

    def stub_refresh(overrides = {})
      stub_token(token_response({ "access_token" => NEW_ACCESS, "refresh_token" => nil }.merge(overrides)))
    end

    # Takes what a worker thread put on +queue+. When the worker died or
    # ended before it got that far, or takes too long, this fails (with the
    # worker's own error when it has one) and the suite does not hang.
    def wait_for(queue, worker, seconds: 5)
      deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + seconds
      while queue.empty?
        worker.value unless worker.alive?
        if !worker.alive? || Process.clock_gettime(Process::CLOCK_MONOTONIC) > deadline
          raise "the worker thread did not get there within #{seconds} seconds"
        end

        sleep 0.005
      end
      queue.pop
    end

    # Waits until +worker+ is blocked or has ended, for at most +seconds+.
    def settle(worker, seconds: 5)
      deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + seconds
      sleep 0.01 while worker.status == "run" && Process.clock_gettime(Process::CLOCK_MONOTONIC) < deadline
      # Blocked now; give it a moment to show that it stays blocked.
      sleep 0.05
    end

    # For an ensure: lets every stub that waits on +release+ go on, and
    # ends the workers, so a failed example leaves no thread behind.
    def stop_workers(release, *workers)
      release.close
      workers.compact.each do |worker|
        worker.kill unless worker.join(2)
      rescue StandardError
        nil # the example has already failed, with this error or an earlier one
      end
    end

    # A token endpoint whose first refresh waits for +release+; it reports on +entered+.
    def stub_slow_refresh(entered, release, overrides = {})
      refreshes = 0
      counting = Mutex.new
      stub_request(:post, TOKEN).to_return do |request|
        form = form_of(request)
        if form["grant_type"] == "refresh_token"
          first = counting.synchronize { (refreshes += 1) == 1 }
          entered << true
          release.pop if first
          json_response(token_response({ "access_token" => NEW_ACCESS, "refresh_token" => NEW_REFRESH }.merge(overrides)))
        else
          json_response(token_response("access_token" => "access-token-from-sign-in", "refresh_token" => "refresh-token-from-sign-in"))
        end
      end
    end

    describe "configuration" do
      it "C1: has the documented defaults, refuses bad values and hides the secret", :aggregate_failures do
        config = build_client.config

        expect(config.scopes).to eq(["offline"])
        expect(config.storage).to be_a(KindeSdk::AgentClient::MemoryStore)
        expect(config.account).to eq("default")
        expect(config.client_name).to eq("Kinde Ruby SDK agent")
        expect(config.resource_url).to eq(RESOURCE)
        expect(config.redirect_uri).to eq(REDIRECT)
        expect(config).to be_frozen
        expect(build_client.config.storage).not_to equal(config.storage)
        expect(build_client(scopes: "offline profile  email").config.scopes).to eq(%w[offline profile email])
        expect(build_client(scopes: %w[offline offline]).config.scopes).to eq(["offline"])

        expect { described_class.new(redirect_uri: REDIRECT) }.to raise_error(ArgumentError, /resource_url/)
        expect { described_class.new(resource_url: RESOURCE) }.to raise_error(ArgumentError, /redirect_uri/)
        [nil, "", "  "].each do |blank|
          expect { build_client(resource_url: blank) }.to raise_error(ArgumentError, /resource_url/)
          expect { build_client(redirect_uri: blank) }.to raise_error(ArgumentError, /redirect_uri/)
        end
        expect { build_client(client_secret: "secret") }.to raise_error(ArgumentError, /client_secret needs a client_id/)
        [
          "http://agent.example.com/doc.json", "https://agent.example.com", "https://agent.example.com/",
          "https://user@agent.example.com/doc.json", "https://agent.example.com/doc.json?v=1",
          "https://agent.example.com/doc.json#top", "not a url"
        ].each do |url|
          expect { build_client(client_metadata_url: url) }.to raise_error(ArgumentError, /client_metadata_url/), url
        end
        expect { build_client(storage: Object.new) }.to raise_error(ArgumentError, /storage must respond to read, write, delete/)
        expect { build_client(storage: {}) }.to raise_error(ArgumentError, /storage/)
        expect { build_client(scopes: 5) }.to raise_error(ArgumentError, /scopes/)

        secret = build_client(client_id: "pre-registered", client_secret: "configured-secret-value", issuer: ISSUER, storage: store)
        expect(secret.config.client_secret).to eq("configured-secret-value")
        [secret.inspect, secret.config.inspect, secret.config.to_s].each do |text|
          expect(text).not_to include("configured-secret-value")
        end
        expect(secret.config.inspect).to include("[FILTERED]").and include("pre-registered")
      end

      it "C2: asks for offline, never for the login scopes of KindeSdk.configure", :aggregate_failures do
        login = KindeSdk::Configuration.new do |c|
          c.domain = "https://login.kinde.com"
          c.client_id = "login_client_id"
          c.scope = "openid profile email offline"
        end
        allow(KindeSdk).to receive(:config).and_return(login)

        query = query_of(client.authorization_url)

        expect(query["scope"]).to eq("offline")
        expect(query["scope"]).not_to include("openid")
        expect(query["client_id"]).to eq(CIMD)
        expect(client.config.scopes).to eq(["offline"])
      end
    end

    describe "protected resource metadata" do
      it "C3: without resource_metadata in the challenge, tries the path-suffixed URL and then the root one", :aggregate_failures do
        stub_resource(challenge_metadata: nil)
        stub_prm({ "error" => "not here" }, status: 404)
        stub_prm(url: PRM_ROOT)

        error = sign_in_needed { client.fetch }

        expect(error.authorization_url).to start_with(AUTHORIZE)
        expect(requested_urls(:get)).to eq([RESOURCE, PRM, PRM_ROOT, METADATA])
      end

      it "C4: a 200 that is not a JSON object moves on to the root URL; nothing usable is an error", :aggregate_failures do
        stub_prm("<html>not json</html>")
        stub_prm(url: PRM_ROOT)
        expect(client.authorization_url).to start_with(AUTHORIZE)
        expect(requests(:get, PRM).size).to eq(1)
        expect(requests(:get, PRM_ROOT).size).to eq(1)

        stub_prm("[1, 2]")
        stub_prm({}, url: PRM_ROOT, status: 500)
        expect { client.authorization_url }.to raise_error(discovery_error, /No protected resource metadata/)
        expect { client.connect }.to raise_error(discovery_error)
      end

      it "C4: looks only at the root URL when the resource has no path" do
        root_resource = "https://api.example.com"
        stub_prm({ "resource" => root_resource, "authorization_servers" => [ISSUER] }, url: PRM_ROOT)

        cimd_client(resource_url: root_resource).authorization_url

        expect(requested_urls(:get)).to eq([PRM_ROOT, METADATA])
      end

      it "C5: fetches the resource_metadata URL of the challenge and neither well-known URL", :aggregate_failures do
        custom = "https://api.example.com/custom/prm.json"
        stub_resource(challenge_metadata: custom)
        stub_prm(url: custom)

        sign_in_needed { client.fetch }

        expect(requests(:get, custom).size).to eq(1)
        expect(requests(:get, PRM)).to be_empty
        expect(requests(:get, PRM_ROOT)).to be_empty

        stub_prm({}, url: custom, status: 404)
        expect { client.fetch }.to raise_error(discovery_error)
        expect(requests(:get, PRM)).to be_empty
      end

      it "C6: refuses metadata whose resource is on another origin, before any authorization server request", :aggregate_failures do
        ["https://other.example.com/mcp", "http://api.example.com/mcp", "https://api.example.com:8443/mcp", nil, 7].each do |resource|
          stub_prm({ "resource" => resource, "authorization_servers" => [ISSUER] })

          expect { client.authorization_url }
            .to raise_error(discovery_error, /does not cover https:\/\/api\.example\.com\/mcp/), "resource #{resource.inspect}"
        end
        expect { client.authorization_url }.to raise_error(discovery_error, /other|invalid|api\.example\.com/)
        expect(requests(:get, METADATA)).to be_empty
      end

      it "C7: refuses a resource path that does not cover resource_url", :aggregate_failures do
        ["https://api.example.com/other", "https://api.example.com/mc", "https://api.example.com/mcp/deeper"].each do |resource|
          stub_prm({ "resource" => resource, "authorization_servers" => [ISSUER] })

          expect { client.authorization_url }.to raise_error(discovery_error, /does not cover/), "resource #{resource}"
        end
        expect(requests(:get, METADATA)).to be_empty
      end

      it "C8: accepts a parent path, the origin, a trailing slash and another host case", :aggregate_failures do
        [
          "https://api.example.com/", "https://api.example.com", "https://api.example.com/mcp/",
          "https://API.Example.com/mcp", "https://api.example.com:443/mcp"
        ].each do |resource|
          stub_prm({ "resource" => resource, "authorization_servers" => [ISSUER] })

          expect(client.authorization_url).to start_with(AUTHORIZE), "resource #{resource}"
        end

        deep = cimd_client(resource_url: "https://api.example.com/mcp/v1/")
        stub_prm({ "resource" => RESOURCE, "authorization_servers" => [ISSUER] }, url: "#{PRM}/v1/")
        expect(deep.authorization_url).to start_with(AUTHORIZE)
      end

      it "C9: needs a non-empty authorization_servers list and uses its first entry", :aggregate_failures do
        [[], nil, "not a list", [7], [""]].each do |servers|
          stub_prm({ "resource" => RESOURCE, "authorization_servers" => servers }.compact)

          expect { client.authorization_url }
            .to raise_error(discovery_error, /names no authorization server/), "authorization_servers #{servers.inspect}"
        end
        expect(requests(:get, METADATA)).to be_empty

        stub_prm({ "resource" => RESOURCE, "authorization_servers" => [ISSUER, "https://second.example.com"] })
        expect(client.authorization_url).to start_with(AUTHORIZE)
        expect(requests.map { |request| request.uri.host }).not_to include("second.example.com")
      end
    end

    describe "step-up on 403 insufficient_scope" do
      let(:insufficient) do
        { status: 403, body: "more scope", headers: { "WWW-Authenticate" => %(Bearer error="insufficient_scope", scope="profile", resource_metadata="#{PRM}") } }
      end

      it "C93: reads a challenge that the resource sends on two header lines", :aggregate_failures do
        sign_in(client)
        stub_request(:get, RESOURCE).to_return(
          status: 403, body: "more scope", headers: { "WWW-Authenticate" => ['Bearer error="insufficient_scope"', 'scope="profile"'] }
        )

        error = sign_in_needed { client.fetch }

        expect(query_of(error.authorization_url)["scope"]).to eq("offline profile")
      end

      it "C10: starts a new sign-in with the challenge's scope added to the current ones", :aggregate_failures do
        sign_in(client)
        stub_request(:get, RESOURCE).to_return(insufficient)

        error = sign_in_needed { client.fetch }

        expect(query_of(error.authorization_url)["scope"]).to eq("offline profile")
        expect(store.read("pending", [error.state])).to include("scopes" => %w[offline profile])
        expect(stored_tokens(store)).to include("access_token" => ACCESS)
        expect(resource_requests.size).to eq(1)
      end

      it "C11: does not loop: once signed in with those scopes the same 403 is returned", :aggregate_failures do
        sign_in(client)
        stub_request(:get, RESOURCE).to_return(insufficient)
        error = sign_in_needed { client.fetch }
        stub_token(token_response("scope" => "offline"))
        client.handle_callback("code" => CODE, "state" => error.state)
        expect(stored_tokens(store)["requested_scopes"]).to eq(%w[offline profile])

        response = client.fetch

        expect(response.status).to eq(403)
        expect(response.body).to eq("more scope")
        expect(store.inspect).to include("pending=0")
        expect(client.fetch.status).to eq(403)
      end

      it "C12: returns a 403 without that challenge unchanged, and a 403 with it when no token was sent", :aggregate_failures do
        sign_in(client)
        stub_request(:get, RESOURCE).to_return(status: 403, body: "forbidden")
        expect(client.fetch.status).to eq(403)

        stub_request(:get, RESOURCE).to_return(status: 403, headers: { "WWW-Authenticate" => 'Bearer error="invalid_request", scope="profile"' })
        expect(client.fetch.status).to eq(403)

        stub_request(:get, RESOURCE).to_return(insufficient)
        expect(cimd_client.fetch.status).to eq(403)
        expect(store.inspect).to include("pending=0")
      end

      it "C12: never adds openid from a challenge at a server that does not list it" do
        sign_in(client)
        stub_request(:get, RESOURCE).to_return(
          status: 403, headers: { "WWW-Authenticate" => 'Bearer error="insufficient_scope", scope="openid"' }
        )

        expect(client.fetch.status).to eq(403)
      end
    end

    describe "authorization server metadata" do
      it "C13: uses the path-inserted URL and never asks under the issuer first", :aggregate_failures do
        client.authorization_url

        expect(requests(:get, METADATA).size).to eq(1)
        expect(requested_urls(:get)).to eq([PRM, METADATA])
        expect(a_request(:get, "#{ISSUER}/.well-known/openid-configuration")).not_to have_been_made
        expect(a_request(:get, "#{ISSUER}/.well-known/oauth-authorization-server")).not_to have_been_made
      end

      it "C14: falls back in the order of RFC 8414 for an issuer with a path" do
        second = "#{KINDE}/.well-known/openid-configuration/oauth2/agents/app_id"
        third = "#{ISSUER}/.well-known/openid-configuration"
        stub_metadata({}, status: 404)
        stub_request(:get, second).to_return(status: 200, body: "not json")
        stub_metadata(url: third)

        client.authorization_url

        expect(requested_urls(:get)).to eq([PRM, METADATA, second, third])
      end

      it "C15: tries oauth-authorization-server and then openid-configuration for an issuer without a path", :aggregate_failures do
        ["https://auth.example.org", "https://auth.example.org/"].each do |issuer|
          KindeSdk::AgentClient::Discovery.reset_cache!
          WebMock::RequestRegistry.instance.reset!
          first = "https://auth.example.org/.well-known/oauth-authorization-server"
          second = "https://auth.example.org/.well-known/openid-configuration"
          stub_prm({ "resource" => RESOURCE, "authorization_servers" => [issuer] })
          stub_metadata({}, url: first, status: 404)
          stub_metadata(
            server_metadata("issuer" => issuer, "authorization_endpoint" => "https://auth.example.org/authorize",
                            "token_endpoint" => "https://auth.example.org/token"),
            url: second
          )

          expect(client.authorization_url).to start_with("https://auth.example.org/authorize?")
          expect(requested_urls(:get)).to eq([PRM, first, second])
        end
      end

      it "C14: reports a missing document, and a network failure at once without trying the next URL", :aggregate_failures do
        second = "#{KINDE}/.well-known/openid-configuration/oauth2/agents/app_id"
        third = "#{ISSUER}/.well-known/openid-configuration"
        [METADATA, second, third].each { |url| stub_metadata({}, url: url, status: 404) }
        expect { client.authorization_url }.to raise_error(discovery_error, /No authorization server metadata/)

        stub_request(:get, METADATA).to_timeout
        expect { client.authorization_url }.to raise_error(unavailable_error, /could not be reached/)
        expect(requests(:get, second).size).to eq(1)
      end

      it "C16: refuses a document whose issuer differs, and caches nothing", :aggregate_failures do
        [KINDE, "#{ISSUER}/", ISSUER.upcase, nil].each do |issuer|
          stub_metadata(server_metadata("issuer" => issuer))

          expect { client.authorization_url }.to raise_error(discovery_error, /names issuer/), "issuer #{issuer.inspect}"
        end
        expect(requests(:get, METADATA).size).to eq(4)
        expect(store.inspect).not_to include("pending=1")

        stub_metadata
        expect(client.authorization_url).to start_with(AUTHORIZE)
      end

      it "C17: refuses a server that does not advertise S256", :aggregate_failures do
        [nil, [], ["plain"], "S256"].each do |methods|
          stub_metadata(server_metadata("code_challenge_methods_supported" => methods))

          expect { client.authorization_url }.to raise_error(discovery_error, /PKCE with S256/), "methods #{methods.inspect}"
        end
        expect { client.connect }.to raise_error(discovery_error)
        expect { client.fetch }.to raise_error(discovery_error)
      end

      it "C18: caches the document for 300 seconds, for every client in the process", :aggregate_failures do
        client.authorization_url
        clock.advance(299)
        cimd_client.authorization_url
        expect(requests(:get, METADATA).size).to eq(1)

        clock.advance(1)
        client.authorization_url
        expect(requests(:get, METADATA).size).to eq(2)
        expect(requests(:get, PRM).size).to eq(3)
      end

      it "C19: calls exactly the endpoints of the document, whatever their paths", :aggregate_failures do
        endpoints = {
          "authorization_endpoint" => "#{KINDE}/a/authz", "token_endpoint" => "#{KINDE}/b/tok",
          "registration_endpoint" => "#{KINDE}/c/reg", "revocation_endpoint" => "#{KINDE}/d/rev"
        }
        stub_metadata(server_metadata(endpoints))
        stub_register(url: endpoints["registration_endpoint"])
        stub_token(url: endpoints["token_endpoint"])
        stub_revoke(url: endpoints["revocation_endpoint"])

        url = dcr_client.authorization_url
        expect(url).to start_with("#{KINDE}/a/authz?")
        dcr_client.handle_callback("code" => CODE, "state" => query_of(url)["state"])
        expect(dcr_client.fetch.status).to eq(200)
        expire_access_token
        stub_token(token_response("access_token" => NEW_ACCESS), url: endpoints["token_endpoint"])
        expect(dcr_client.fetch.status).to eq(200)
        dcr_client.disconnect

        expect(requested_urls(:post)).to eq(["#{KINDE}/c/reg", "#{KINDE}/b/tok", "#{KINDE}/d/rev"])
        expect(requests(:post, "#{KINDE}/b/tok").size).to eq(2)
        expect(requests.map { |request| request.uri.host }.uniq).to contain_exactly("api.example.com", "yourbiz.kinde.com")
        expect(a_request(:any, %r{yourbiz\.kinde\.com/oauth2/(auth|token|introspect|revoke|v2)})).not_to have_been_made
        expect(a_request(:any, /#{Regexp.escape(ISSUER)}/)).not_to have_been_made

        sources = Dir.glob(File.expand_path("../lib/kinde_sdk/agent_client{.rb,/*.rb}", __dir__))
        expect(sources.size).to eq(12)
        sources.each do |file|
          code = File.readlines(file).reject { |line| line.strip.start_with?("#") }.join
          expect(code).not_to include("/oauth2/"), "#{file} builds a Kinde path by hand"
          expect(code).not_to match(/kinde\.com/i), "#{file} names a Kinde host"
        end
      end

      it "C20: refuses a document without a token or authorization endpoint", :aggregate_failures do
        stub_metadata(server_metadata("token_endpoint" => nil))
        expect { client.authorization_url }.to raise_error(discovery_error, /no token_endpoint/)

        stub_metadata(server_metadata("authorization_endpoint" => nil))
        expect { client.authorization_url }.to raise_error(discovery_error, /no authorization_endpoint/)
      end
    end

    describe "client identity" do
      it "C21: uses the client ID metadata document when the server supports it: no registration, no secret", :aggregate_failures do
        url = client.authorization_url
        client.handle_callback("code" => CODE, "state" => query_of(url)["state"])

        expect(query_of(url)["client_id"]).to eq(CIMD)
        expect(requests(:post, REGISTER)).to be_empty
        exchange = token_requests.first
        expect(form_of(exchange)).to include("client_id" => CIMD)
        expect(form_of(exchange)).not_to have_key("client_secret")
        expect(exchange.headers).not_to have_key("Authorization")
        expect(client.token_info.client_id).to eq(CIMD)
      end

      it "C22: registers when the server does not advertise support with a JSON true", :aggregate_failures do
        [nil, "true", 1, false].each do |flag|
          KindeSdk::AgentClient::Discovery.reset_cache!
          stub_metadata(server_metadata("client_id_metadata_document_supported" => flag))
          fresh = cimd_client

          expect(query_of(fresh.authorization_url)["client_id"]).to eq(DCR_ID), "flag #{flag.inspect}"
        end
        expect(requests(:post, REGISTER).size).to eq(4)
      end

      it "C23: uses the configured client ID when the metadata document is not supported", :aggregate_failures do
        stub_metadata(server_metadata("client_id_metadata_document_supported" => nil))
        both = cimd_client(client_id: "pre-registered", storage: store)

        expect(query_of(both.authorization_url)["client_id"]).to eq("pre-registered")
        expect(requests(:post, REGISTER)).to be_empty

        KindeSdk::AgentClient::Discovery.reset_cache!
        stub_metadata
        expect(query_of(both.authorization_url)["client_id"]).to eq(CIMD)
      end

      it "C24: a configured client is public without a secret and uses client_secret_post with one", :aggregate_failures do
        public_client = build_client(client_id: "pre-registered")
        sign_in(public_client)
        expect(form_of(token_requests.last)).to include("client_id" => "pre-registered")
        expect(form_of(token_requests.last)).not_to have_key("client_secret")
        expect(token_requests.last.headers).not_to have_key("Authorization")

        confidential = build_client(client_id: "confidential", client_secret: "configured-secret-value", issuer: ISSUER)
        sign_in(confidential)
        expect(form_of(token_requests.last)).to include("client_id" => "confidential", "client_secret" => "configured-secret-value")
        expect(token_requests.last.headers).not_to have_key("Authorization")
        expect(requests(:post, REGISTER)).to be_empty
      end

      it "C25: says to configure client_id when the server offers neither identity", :aggregate_failures do
        stub_metadata(server_metadata("client_id_metadata_document_supported" => nil, "registration_endpoint" => nil))

        expect { dcr_client.authorization_url }.to raise_error(
          discovery_error,
          "The authorization server supports neither client ID metadata documents nor dynamic registration; configure client_id"
        )
        expect { client.fetch }.to raise_error(discovery_error, /configure client_id/)
        expect(query_of(build_client(client_id: "pre-registered").authorization_url)["client_id"]).to eq("pre-registered")
      end
    end

    describe "a configured client is bound to its issuer" do
      let(:secret) { "configured-secret-value" }
      let(:other) { "https://evil.example/as" }
      let(:other_token) { "#{other}/token" }
      let(:other_register) { "#{other}/register" }
      let(:other_revoke) { "#{other}/revoke" }
      let(:bound) { build_client(client_id: "pre-registered", client_secret: secret, issuer: ISSUER, storage: store) }

      def other_metadata(overrides = {})
        server_metadata({
          "issuer" => other, "authorization_endpoint" => "#{other}/authorize", "token_endpoint" => other_token,
          "registration_endpoint" => other_register, "revocation_endpoint" => other_revoke,
          "token_endpoint_auth_methods_supported" => %w[client_secret_basic client_secret_post none],
          "client_id_metadata_document_supported" => nil
        }.merge(overrides))
      end

      # The resource names another authorization server than the configured issuer.
      def stub_other_server(metadata = other_metadata)
        KindeSdk::AgentClient::Discovery.reset_cache!
        stub_prm({ "resource" => RESOURCE, "authorization_servers" => [other] })
        stub_request(:get, %r{\Ahttps://evil\.example/\.well-known/}).to_return(json_response(metadata))
        stub_register(registration_response("client_id" => "other-dcr-id", "client_secret" => nil,
                                            "token_endpoint_auth_method" => "none"), url: other_register)
        stub_token(url: other_token)
        stub_revoke(url: other_revoke)
      end

      # Every request that carries +value+ in its URL, its body or a header (also inside a Basic header).
      def requests_carrying(value)
        requests.select do |request|
          headers = request.headers.to_h.values.map(&:to_s)
          basic = headers.filter_map { |header| header[/\ABasic (.+)\z/, 1] }.map { |pair| URI.decode_www_form_component(Base64.decode64(pair)) }
          ([request.uri.to_s, request.body.to_s] + headers + basic).any? { |text| text.include?(value) }
        end
      end

      it "C24: client_secret needs issuer, and issuer follows the URL rule", :aggregate_failures do
        options = { client_id: "pre-registered", client_secret: secret }
        expect { build_client(options) }.to raise_error(ArgumentError, /client_secret needs an issuer/)
        [nil, "", "  "].each do |blank|
          expect { build_client(options.merge(issuer: blank)) }.to raise_error(ArgumentError, /client_secret needs an issuer/)
        end
        ["http://yourbiz.kinde.com/oauth2/agents/app_id", "ftp://yourbiz.kinde.com", "not a url", "#{ISSUER}#top"].each do |bad|
          expect { build_client(options.merge(issuer: bad)) }.to raise_error(ArgumentError, /issuer/), bad
          expect { build_client(client_id: "pre-registered", issuer: bad) }.to raise_error(ArgumentError, /issuer/), bad
        end
        expect { build_client(issuer: 5) }.to raise_error(ArgumentError, /issuer must be a String/)

        expect(bound.config.issuer).to eq(ISSUER)
        expect(bound.config.inspect).to include("issuer=#{ISSUER.inspect}")
        expect(build_client(options.merge(issuer: "http://localhost:9000/as")).config.issuer).to eq("http://localhost:9000/as")
        expect(build_client(client_id: "pre-registered").config.issuer).to be_nil
        expect(build_client(issuer: ISSUER).config.issuer).to eq(ISSUER)
      end

      it "C24: at the configured issuer the client and its secret are used as before", :aggregate_failures do
        sign_in(bound)
        expect(form_of(token_requests.last)).to include("client_id" => "pre-registered", "client_secret" => secret)
        clock.advance(86_400)
        stub_refresh
        expect(bound.connect.client_id).to eq("pre-registered")
        expect(form_of(token_requests("refresh_token").last)).to include("client_secret" => secret)
        bound.disconnect
        expect(form_of(requests(:post, REVOKE).last)).to include("client_id" => "pre-registered", "client_secret" => secret)
        expect(requests(:post, REGISTER)).to be_empty
      end

      it "C24: a resource that names another authorization server never receives the secret", :aggregate_failures do
        stub_other_server

        url = bound.authorization_url
        expect(url).to start_with("#{other}/authorize?")
        expect(query_of(url)["client_id"]).to eq("other-dcr-id")
        expect(requests(:post, other_register).size).to eq(1)
        expect(logs.map(&:last).join("\n")).to match(/not the configured issuer/)

        info = bound.handle_callback("code" => CODE, "state" => query_of(url)["state"], "iss" => other)
        expect(info.client_id).to eq("other-dcr-id")
        expect(form_of(token_requests(url: other_token).last)).to include("grant_type" => "authorization_code", "client_id" => "other-dcr-id")

        clock.advance(86_400)
        stub_token(token_response("access_token" => NEW_ACCESS), url: other_token)
        expect(bound.connect.client_id).to eq("other-dcr-id")
        expect(token_requests("refresh_token", url: other_token).size).to eq(1)

        expect(bound.disconnect).to be(true)
        expect(requests(:post, other_revoke).size).to eq(1)

        expect(requests.count { |request| request.uri.host == "evil.example" }).to be >= 5
        expect(requests_carrying(secret)).to be_empty
        expect(requests_carrying("pre-registered")).to be_empty
        expect(JSON.generate(store.instance_variable_get(:@data))).not_to include(secret)
      end

      it "C24: at another issuer the order goes on: metadata document, registration, then the error", :aggregate_failures do
        stub_other_server(other_metadata("client_id_metadata_document_supported" => true))
        with_document = cimd_client(client_id: "pre-registered", client_secret: secret, issuer: ISSUER)
        expect(query_of(with_document.authorization_url)["client_id"]).to eq(CIMD)
        expect(requests(:post, other_register)).to be_empty

        stub_other_server(other_metadata("registration_endpoint" => nil))
        expect { bound.authorization_url }.to raise_error(discovery_error, /configure client_id/)
        expect { bound.fetch }.to raise_error(discovery_error, /configure client_id/)

        stub_other_server
        public_client = build_client(client_id: "pre-registered", issuer: ISSUER)
        expect(query_of(public_client.authorization_url)["client_id"]).to eq("other-dcr-id")
        expect(query_of(build_client(client_id: "pre-registered").authorization_url)["client_id"]).to eq("pre-registered")
        expect(requests_carrying(secret)).to be_empty
      end

      it "C24: the issuer is compared as a String: a trailing slash is another issuer", :aggregate_failures do
        slash = build_client(client_id: "pre-registered", client_secret: secret, issuer: "#{ISSUER}/", storage: store)

        expect(query_of(slash.authorization_url)["client_id"]).to eq(DCR_ID)
        sign_in(slash)
        expect(requests_carrying(secret)).to be_empty
      end

      it "C24: a sign-in attempt stored for the configured client at another issuer is not finished", :aggregate_failures do
        stub_other_server
        store.write("pending", ["old-state"], {
                      "code_verifier" => "v" * 64, "issuer" => other, "token_endpoint" => other_token,
                      "client_id" => "pre-registered", "redirect_uri" => REDIRECT, "resource_url" => RESOURCE,
                      "account" => "default", "scopes" => ["offline"], "created_at" => clock.now
                    })

        expect { bound.handle_callback("code" => CODE, "state" => "old-state") }
          .to raise_error(oauth_error, /client registration changed/)
        expect(requests(:post)).to be_empty

        store.write("pending", ["no-issuer"], {
                      "code_verifier" => "v" * 64, "token_endpoint" => other_token,
                      "client_id" => "pre-registered", "redirect_uri" => REDIRECT, "resource_url" => RESOURCE,
                      "account" => "default", "scopes" => ["offline"], "created_at" => clock.now
                    })
        expect { bound.handle_callback("code" => CODE, "state" => "no-issuer") }.to raise_error(oauth_error)
        expect(requests(:post)).to be_empty
      end

      it "C24: tokens stored for the configured client at another issuer are refreshed and revoked without the secret", :aggregate_failures do
        stub_other_server(other_metadata("token_endpoint_auth_methods_supported" => ["client_secret_basic"]))
        record = {
          "access_token" => ACCESS, "refresh_token" => REFRESH, "expires_at" => clock.now + 10, "scope" => "offline",
          "requested_scopes" => ["offline"], "issuer" => other, "resource_url" => RESOURCE, "client_id" => "pre-registered"
        }
        store.write("tokens", [other, RESOURCE, "default"], record)
        store.write("issuers", [RESOURCE, "default"], other)

        error = sign_in_needed { bound.fetch }
        expect(query_of(error.authorization_url)["client_id"]).to eq("other-dcr-id")
        expect(token_requests(url: other_token)).to be_empty
        expect(stored_tokens(store, issuer: other)).to be_nil

        store.write("tokens", [other, RESOURCE, "default"], record.merge("expires_at" => clock.now + 3600))
        store.write("issuers", [RESOURCE, "default"], other)
        valid.clear
        sign_in_needed { bound.fetch }
        expect(token_requests(url: other_token)).to be_empty

        store.write("tokens", [other, RESOURCE, "default"], record)
        store.write("issuers", [RESOURCE, "default"], other)
        expect(bound.disconnect).to be(true)
        revocation = requests(:post, other_revoke).last
        expect(form_of(revocation)).to eq("token" => REFRESH, "token_type_hint" => "refresh_token", "client_id" => "pre-registered")
        expect(revocation.headers).not_to have_key("Authorization")
        expect(requests_carrying(secret)).to be_empty
      end

      it "C24: when the resource moves to another authorization server, the secret stays with the configured one", :aggregate_failures do
        sign_in(bound)
        expect(requests_carrying(secret).map { |request| request_url(request) }.uniq).to eq([TOKEN])
        sent = requests_carrying(secret).size

        stub_other_server
        valid.clear
        error = sign_in_needed { bound.fetch }
        expect(error.authorization_url).to start_with("#{other}/authorize?")
        expect(query_of(error.authorization_url)["client_id"]).to eq("other-dcr-id")
        bound.handle_callback("code" => CODE, "state" => error.state)
        bound.disconnect

        expect(requests_carrying(secret).size).to eq(sent)
        expect(requests.select { |request| request.uri.host == "evil.example" } & requests_carrying(secret)).to be_empty
      end
    end

    describe "dynamic client registration" do
      it "C26: posts exactly the five members as JSON, without scope or resource", :aggregate_failures do
        build_client(client_name: "My Agent", storage: store).authorization_url

        request = requests(:post, REGISTER).first
        expect(JSON.parse(request.body)).to eq(
          "redirect_uris" => [REDIRECT],
          "client_name" => "My Agent",
          "grant_types" => %w[authorization_code refresh_token],
          "response_types" => ["code"],
          "token_endpoint_auth_method" => "none"
        )
        expect(request.headers["Content-Type"]).to eq("application/json")
        expect(request.headers).not_to have_key("Authorization")
      end

      it "C87: uses a stored registration at a server that no longer has a registration endpoint", :aggregate_failures do
        sign_in(dcr_client)
        KindeSdk::AgentClient::Discovery.reset_cache!
        stub_metadata(server_metadata("registration_endpoint" => nil, "client_id_metadata_document_supported" => nil))

        expect(query_of(dcr_client.authorization_url)["client_id"]).to eq(DCR_ID)
        expect(requests(:post, REGISTER).size).to eq(1)
        expect { build_client(storage: KindeSdk::AgentClient::MemoryStore.new).authorization_url }
          .to raise_error(discovery_error, /neither client ID metadata documents nor dynamic registration/)
      end

      it "C88: sign-ins that start together on one store register once", :aggregate_failures do
        registered = Queue.new
        stub_request(:post, REGISTER).to_return do |_request|
          registered << true
          sleep 0.2
          json_response(registration_response("client_id" => "dcr-client-id-#{registered.size}"), status: 201)
        end

        urls = Array.new(6) { Thread.new { build_client(storage: store).authorization_url } }.map(&:value)

        expect(requests(:post, REGISTER).size).to eq(1)
        expect(urls.map { |url| query_of(url)["client_id"] }.uniq).to eq(["dcr-client-id-1"])
        expect(stored_registration(store)).to include("client_id" => "dcr-client-id-1")
        expect(stored_registration(store)).not_to have_key("previous")
        expect(KindeSdk::AgentClient::KeyedLock.instance_variable_get(:@table)).to be_empty
      end

      it "C100: dropping a refused registration waits for a registration that is under way, and keeps what it stores", :aggregate_failures do
        stub_register(registration_response("client_id" => "dcr-old", "client_secret_expires_at" => NOW + 86_400 + 100))
        dcr_client.authorization_url
        clock.advance(200) # the old registration is now within a day of its expiry: the next sign-in replaces it
        entered = Queue.new
        release = Queue.new
        stub_request(:post, REGISTER).to_return do |_request|
          entered << true
          release.pop
          json_response(registration_response("client_id" => "dcr-new"), status: 201)
        end
        registration = KindeSdk::AgentClient::Registration.new(dcr_client.config)

        registering = Thread.new { build_client(storage: store).authorization_url }
        wait_for(entered, registering)
        dropping = Thread.new { registration.forget_client(ISSUER, "dcr-old") }
        settle(dropping)
        expect(dropping).to be_alive
        expect(stored_registration(store)).to include("client_id" => "dcr-old")
        release << true

        expect(query_of(registering.value)["client_id"]).to eq("dcr-new")
        # It read what the registration stored: the new one is current and stays, only the refused one goes.
        expect(dropping.value).to be(false)
        expect(stored_registration(store)).to include("client_id" => "dcr-new")
        expect(stored_registration(store)).not_to have_key("previous")
        expect(KindeSdk::AgentClient::KeyedLock.instance_variable_get(:@table)).to be_empty
      ensure
        stop_workers(release, registering, dropping)
      end

      it "C89: refuses a registration with an authentication method it cannot use, and stores nothing", :aggregate_failures do
        unusable = {
          "a method the client does not have" => { "token_endpoint_auth_method" => "private_key_jwt" },
          "client_secret_jwt" => { "token_endpoint_auth_method" => "client_secret_jwt" },
          "client_secret_post without a secret" => { "client_secret" => nil },
          "client_secret_basic with an empty secret" => { "client_secret" => "", "token_endpoint_auth_method" => "client_secret_basic" },
          "client_secret_basic with a secret that is no string" => { "client_secret" => 7, "token_endpoint_auth_method" => "client_secret_basic" }
        }
        unusable.each do |name, members|
          fresh = KindeSdk::AgentClient::MemoryStore.new
          stub_register(registration_response(members))

          expect { build_client(storage: fresh).authorization_url }
            .to raise_error(registration_error, /authentication method this client cannot use/), name
          expect(stored_registration(fresh)).to be_nil, name
          expect(fresh.inspect).not_to include("pending"), name
        end

        usable = [
          { "client_secret" => nil, "token_endpoint_auth_method" => "none" },
          { "client_secret" => nil, "token_endpoint_auth_method" => nil },
          { "token_endpoint_auth_method" => "client_secret_basic" },
          { "token_endpoint_auth_method" => nil }
        ]
        usable.each do |members|
          stub_register(registration_response(members))
          expect(build_client(storage: KindeSdk::AgentClient::MemoryStore.new).authorization_url).to start_with(AUTHORIZE)
        end
      end

      it "C27: asked for none, got client_secret_post: the secret is sent at token, refresh and revoke", :aggregate_failures do
        sign_in(dcr_client)
        expire_access_token
        stub_refresh
        expect(dcr_client.fetch.status).to eq(200)
        dcr_client.disconnect

        expect(JSON.parse(requests(:post, REGISTER).first.body)["token_endpoint_auth_method"]).to eq("none")
        sent = token_requests + requests(:post, REVOKE)
        expect(sent.map { |request| form_of(request)["grant_type"] }).to eq(["authorization_code", "refresh_token", nil])
        sent.each do |request|
          expect(form_of(request)).to include("client_id" => DCR_ID, "client_secret" => DCR_SECRET)
          expect(request.headers).not_to have_key("Authorization")
        end
      end

      it "C27: a registration without a secret stays public, and one without a method uses Basic", :aggregate_failures do
        stub_register(registration_response("client_secret" => nil, "token_endpoint_auth_method" => nil))
        sign_in(dcr_client)
        expect(stored_registration(store)).to include("token_endpoint_auth_method" => "none", "client_secret" => nil)
        expect(form_of(token_requests.last)).to include("client_id" => DCR_ID)
        expect(form_of(token_requests.last)).not_to have_key("client_secret")

        other = KindeSdk::AgentClient::MemoryStore.new
        stub_register(registration_response("token_endpoint_auth_method" => nil))
        sign_in(build_client(storage: other))
        expect(stored_registration(other)["token_endpoint_auth_method"]).to eq("client_secret_basic")
        expect(token_requests.last.headers["Authorization"]).to eq("Basic #{Base64.strict_encode64("#{DCR_ID}:#{DCR_SECRET}")}")
        expect(form_of(token_requests.last)).not_to have_key("client_secret")
      end

      it "C28: stores the registration under issuer and redirect URI and reuses it", :aggregate_failures do
        dcr_client.authorization_url

        expect(stored_registration(store)).to eq(
          "client_id" => DCR_ID,
          "client_secret" => DCR_SECRET,
          "token_endpoint_auth_method" => "client_secret_post",
          "client_secret_expires_at" => NOW + (30 * 86_400)
        )

        again = build_client(storage: store)
        expect(query_of(again.authorization_url)["client_id"]).to eq(DCR_ID)
        dcr_client.authorization_url
        expect(requests(:post, REGISTER).size).to eq(1)
      end

      it "C29: replaces a registration that expires within a day, and keeps one that expires later or never", :aggregate_failures do
        key = [ISSUER, REDIRECT]
        record = { "client_id" => "stored-id", "client_secret" => "stored-secret", "token_endpoint_auth_method" => "client_secret_post" }

        store.write("registrations", key, record.merge("client_secret_expires_at" => NOW + (25 * 3600)))
        expect(query_of(dcr_client.authorization_url)["client_id"]).to eq("stored-id")
        store.write("registrations", key, record.merge("client_secret_expires_at" => 0))
        expect(query_of(dcr_client.authorization_url)["client_id"]).to eq("stored-id")
        store.write("registrations", key, record.merge("client_secret_expires_at" => NOW + 86_400))
        expect(query_of(dcr_client.authorization_url)["client_id"]).to eq("stored-id")
        store.write("registrations", key, record)
        expect(query_of(dcr_client.authorization_url)["client_id"]).to eq("stored-id")
        expect(requests(:post, REGISTER)).to be_empty

        store.write("registrations", key, record.merge("client_secret_expires_at" => NOW + (23 * 3600)))
        expect(query_of(dcr_client.authorization_url)["client_id"]).to eq(DCR_ID)
        expect(requests(:post, REGISTER).size).to eq(1)
        expect(stored_registration(store)["client_id"]).to eq(DCR_ID)

        store.write("registrations", key, record.merge("client_secret_expires_at" => NOW - 5))
        expect(query_of(dcr_client.authorization_url)["client_id"]).to eq(DCR_ID)
        expect(requests(:post, REGISTER).size).to eq(2)
      end

      it "C29: tokens issued to a registration that was replaced before its expiry are still refreshed and revoked with it", :aggregate_failures do
        sign_in(dcr_client)
        clock.advance((29 * 86_400) + 3600)
        stub_register(registration_response("client_id" => "dcr-client-id-two", "client_secret" => "dcr-client-secret-two",
                                            "client_secret_expires_at" => clock.now + (30 * 86_400)))

        expect(query_of(dcr_client.authorization_url)["client_id"]).to eq("dcr-client-id-two")
        expect(requests(:post, REGISTER).size).to eq(2)
        expect(stored_registration(store)).to include(
          "client_id" => "dcr-client-id-two",
          "previous" => {
            "client_id" => DCR_ID, "client_secret" => DCR_SECRET, "token_endpoint_auth_method" => "client_secret_post",
            "client_secret_expires_at" => NOW + (30 * 86_400)
          }
        )

        expire_access_token
        stub_refresh
        expect(dcr_client.fetch.status).to eq(200)
        expect(form_of(token_requests("refresh_token").last)).to include(
          "refresh_token" => REFRESH, "client_id" => DCR_ID, "client_secret" => DCR_SECRET
        )
        expect(dcr_client.token_info.client_id).to eq(DCR_ID)

        dcr_client.disconnect
        expect(form_of(requests(:post, REVOKE).last)).to include("client_id" => DCR_ID, "client_secret" => DCR_SECRET)
        expect(stored_registration(store)).to include("client_id" => "dcr-client-id-two")
      end

      it "C29: once the replaced registration has expired, its tokens are dropped without a refresh", :aggregate_failures do
        sign_in(dcr_client)
        clock.advance((29 * 86_400) + 3600)
        stub_register(registration_response("client_id" => "dcr-client-id-two",
                                            "client_secret_expires_at" => clock.now + (30 * 86_400)))
        dcr_client.authorization_url
        clock.advance(23 * 3600)

        error = sign_in_needed { dcr_client.fetch }

        expect(query_of(error.authorization_url)["client_id"]).to eq("dcr-client-id-two")
        expect(token_requests("refresh_token")).to be_empty
        expect(stored_tokens(store)).to be_nil
        expect(requests(:post, REGISTER).size).to eq(2)
      end

      it "C29: invalid_client for a replaced registration drops only that one and its tokens, and registers nothing", :aggregate_failures do
        sign_in(dcr_client)
        clock.advance((29 * 86_400) + 3600)
        stub_register(registration_response("client_id" => "dcr-client-id-two", "client_secret" => "dcr-client-secret-two",
                                            "client_secret_expires_at" => clock.now + (30 * 86_400)))
        started = query_of(dcr_client.authorization_url)
        expect(stored_registration(store)["previous"]).to include("client_id" => DCR_ID)

        expire_access_token
        stub_token_error("invalid_client", status: 401)
        error = sign_in_needed { dcr_client.fetch }

        expect(form_of(token_requests("refresh_token").last)).to include("client_id" => DCR_ID, "client_secret" => DCR_SECRET)
        expect(requests(:post, REGISTER).size).to eq(2)
        expect(query_of(error.authorization_url)["client_id"]).to eq("dcr-client-id-two")
        expect(stored_registration(store)).to include("client_id" => "dcr-client-id-two", "client_secret" => "dcr-client-secret-two")
        expect(stored_registration(store)).not_to have_key("previous")
        expect(stored_tokens(store)).to be_nil
        expect(store.read("pending", [error.state])["reregistered"]).not_to eq(true)

        stub_token
        expect(dcr_client.handle_callback("code" => CODE, "state" => started["state"]).client_id).to eq("dcr-client-id-two")
        expect(form_of(token_requests("authorization_code").last)).to include("client_id" => "dcr-client-id-two")
        expect(requests(:post, REGISTER).size).to eq(2)
      end

      it "C29: invalid_client at the code exchange for a replaced registration keeps the current one", :aggregate_failures do
        store.write("registrations", [ISSUER, REDIRECT],
                    "client_id" => "stored-id", "client_secret" => "stored-secret",
                    "token_endpoint_auth_method" => "client_secret_post", "client_secret_expires_at" => NOW + 86_400 + 100)
        state = query_of(dcr_client.authorization_url)["state"]
        clock.advance(300)
        expect(query_of(dcr_client.authorization_url)["client_id"]).to eq(DCR_ID)
        stub_token_error("invalid_client", status: 401)

        error = sign_in_needed { dcr_client.handle_callback("code" => CODE, "state" => state) }

        expect(form_of(token_requests.last)).to include("client_id" => "stored-id")
        expect(requests(:post, REGISTER).size).to eq(1)
        expect(query_of(error.authorization_url)["client_id"]).to eq(DCR_ID)
        expect(stored_registration(store)).to include("client_id" => DCR_ID)
        expect(stored_registration(store)).not_to have_key("previous")
      end

      it "C29: invalid_client for the current registration keeps the replaced one, so its tokens are still refreshed and revoked", :aggregate_failures do
        sign_in(dcr_client)
        clock.advance((29 * 86_400) + 3600)
        stub_register(registration_response("client_id" => "dcr-client-id-two", "client_secret" => "dcr-client-secret-two",
                                            "client_secret_expires_at" => clock.now + (30 * 86_400)))
        state = query_of(dcr_client.authorization_url)["state"]
        stub_token_error("invalid_client", status: 401)
        stub_register(registration_response("client_id" => "dcr-client-id-three", "client_secret" => "dcr-client-secret-three",
                                            "client_secret_expires_at" => clock.now + (30 * 86_400)))

        error = sign_in_needed { dcr_client.handle_callback("code" => CODE, "state" => state) }

        expect(form_of(token_requests("authorization_code").last)).to include("client_id" => "dcr-client-id-two")
        expect(requests(:post, REGISTER).size).to eq(3)
        expect(query_of(error.authorization_url)["client_id"]).to eq("dcr-client-id-three")
        expect(store.read("pending", [error.state])).to include("reregistered" => true)
        expect(stored_registration(store)).to eq(
          "client_id" => "dcr-client-id-three", "client_secret" => "dcr-client-secret-three",
          "token_endpoint_auth_method" => "client_secret_post", "client_secret_expires_at" => clock.now + (30 * 86_400),
          "previous" => {
            "client_id" => DCR_ID, "client_secret" => DCR_SECRET, "token_endpoint_auth_method" => "client_secret_post",
            "client_secret_expires_at" => NOW + (30 * 86_400)
          }
        )
        expect(stored_tokens(store)).to include("client_id" => DCR_ID, "refresh_token" => REFRESH)

        expire_access_token
        stub_refresh
        expect(dcr_client.fetch.status).to eq(200)
        expect(form_of(token_requests("refresh_token").last)).to include(
          "refresh_token" => REFRESH, "client_id" => DCR_ID, "client_secret" => DCR_SECRET
        )

        dcr_client.disconnect
        expect(form_of(requests(:post, REVOKE).last)).to include("client_id" => DCR_ID, "client_secret" => DCR_SECRET)
        expect(stored_registration(store)).to include("client_id" => "dcr-client-id-three")
      end

      it "C29: invalid_client at a refresh for the current registration keeps the replaced one, but not an expired one", :aggregate_failures do
        key = [ISSUER, REDIRECT]
        old = { "client_id" => "old-id", "client_secret" => "old-secret", "token_endpoint_auth_method" => "client_secret_post" }
        sign_in(dcr_client)
        current = stored_registration(store)
        tokens = stored_tokens(store)
        expire_access_token
        stub_token_error("invalid_client", status: 401)
        stub_register(registration_response("client_id" => "dcr-client-id-two"))

        store.write("registrations", key, current.merge("previous" => old.merge("client_secret_expires_at" => NOW + 3600)))
        error = sign_in_needed { dcr_client.fetch }

        expect(form_of(token_requests("refresh_token").last)).to include("client_id" => DCR_ID)
        expect(requests(:post, REGISTER).size).to eq(2)
        expect(query_of(error.authorization_url)["client_id"]).to eq("dcr-client-id-two")
        expect(stored_registration(store)).to include("client_id" => "dcr-client-id-two",
                                                      "previous" => old.merge("client_secret_expires_at" => NOW + 3600))
        expect(stored_tokens(store)).to be_nil

        store.write("registrations", key, current.merge("previous" => old.merge("client_secret_expires_at" => NOW - 5)))
        store.write("tokens", [ISSUER, RESOURCE, "default"], tokens)
        sign_in_needed { dcr_client.fetch }

        expect(requests(:post, REGISTER).size).to eq(3)
        expect(stored_registration(store)).to include("client_id" => "dcr-client-id-two")
        expect(stored_registration(store)).not_to have_key("previous")
      end

      it "C29: when registering again fails, the replaced registration stays usable and the next sign-in registers", :aggregate_failures do
        sign_in(dcr_client)
        clock.advance((29 * 86_400) + 3600)
        stub_register(registration_response("client_id" => "dcr-client-id-two",
                                            "client_secret_expires_at" => clock.now + (30 * 86_400)))
        state = query_of(dcr_client.authorization_url)["state"]
        stub_token_error("invalid_client", status: 401)
        stub_register({ "error" => "too_many_registrations" }, status: 429)

        expect { dcr_client.handle_callback("code" => CODE, "state" => state) }.to raise_error(registration_error)
        expect(stored_registration(store)).to include("client_id" => DCR_ID, "client_secret" => DCR_SECRET)
        expect(stored_registration(store)).not_to have_key("previous")

        stub_register(registration_response("client_id" => "dcr-client-id-three",
                                            "client_secret_expires_at" => clock.now + (30 * 86_400)))
        expect(query_of(dcr_client.authorization_url)["client_id"]).to eq("dcr-client-id-three")
        expect(stored_registration(store)["previous"]).to include("client_id" => DCR_ID, "client_secret" => DCR_SECRET)

        dcr_client.disconnect
        expect(form_of(requests(:post, REVOKE).last)).to include("client_id" => DCR_ID, "client_secret" => DCR_SECRET)
      end

      it "C30: invalid_client at the token endpoint registers once more and asks to sign in again; a second one is an error", :aggregate_failures do
        state = query_of(dcr_client.authorization_url)["state"]
        stub_token_error("invalid_client", status: 401)
        stub_register(registration_response("client_id" => "dcr-client-id-two"))
        seen = []
        dcr_client.on_auth_required { |url| seen << url }

        error = sign_in_needed { dcr_client.handle_callback("code" => CODE, "state" => state) }

        expect(requests(:post, REGISTER).size).to eq(2)
        expect(query_of(error.authorization_url)).to include("client_id" => "dcr-client-id-two", "scope" => "offline")
        expect(seen).to eq([error.authorization_url])
        expect(stored_registration(store)["client_id"]).to eq("dcr-client-id-two")
        expect(store.read("pending", [error.state])).to include("reregistered" => true)

        expect { dcr_client.handle_callback("code" => CODE, "state" => error.state) }
          .to raise_error(oauth_error) { |failure| expect(failure.error).to eq("invalid_client") }
        expect(requests(:post, REGISTER).size).to eq(2)
        expect(token_requests.size).to eq(2)
        expect(dcr_client.token_info).to be_nil
      end

      it "C31: registers again for another redirect URI on the same store", :aggregate_failures do
        dcr_client.authorization_url
        other_redirect = "https://agent.example.com/other/callback"
        build_client(storage: store, redirect_uri: other_redirect).authorization_url

        expect(requests(:post, REGISTER).size).to eq(2)
        expect(JSON.parse(requests(:post, REGISTER).last.body)["redirect_uris"]).to eq([other_redirect])
        expect(stored_registration(store, redirect_uri: other_redirect)).to include("client_id" => DCR_ID)
        expect(stored_registration(store)).to include("client_id" => DCR_ID)
      end

      it "C32: invalid_client for a client that did not register itself is an error, with no registration", :aggregate_failures do
        stub_token_error("invalid_client", status: 401)

        [client, build_client(client_id: "pre-registered")].each do |agent|
          state = query_of(agent.authorization_url)["state"]

          expect { agent.handle_callback("code" => CODE, "state" => state) }.to raise_error(oauth_error) do |failure|
            expect(failure).not_to be_a(registration_error)
            expect(failure.error).to eq("invalid_client")
            expect(failure.error_description).to eq("The server said invalid_client")
            expect(failure.status).to eq(401)
          end
        end
        expect(requests(:post, REGISTER)).to be_empty
      end

      it "C33: a 429 is reported as try again later, without a retry", :aggregate_failures do
        stub_register({ "error" => "too_many_registrations", "error_description" => "Slow down" }, status: 429)

        expect { dcr_client.authorization_url }.to raise_error(registration_error, "Too many registrations; try again later") do |failure|
          expect(failure.status).to eq(429)
          expect(failure.error).to eq("too_many_registrations")
          expect(failure).to be_a(oauth_error)
        end
        expect(requests(:post, REGISTER).size).to eq(1)
        expect(stored_registration(store)).to be_nil
      end

      it "C34: invalid_redirect_uri is reported with the server's description, word for word, and logged once", :aggregate_failures do
        description = "Host agent.example.com is not trusted; add it to Trusted agent hosts"
        stub_register({ "error" => "invalid_redirect_uri", "error_description" => description }, status: 400)

        expect { dcr_client.authorization_url }.to raise_error(registration_error) do |failure|
          expect(failure.message).to eq(description)
          expect(failure.error_description).to eq(description)
          expect(failure.status).to eq(400)
        end
        expect(logs.size).to eq(1)
        expect(logs.first.first).to eq(:warn)
        expect(logs.first.last).to include(REDIRECT).and include("invalid_redirect_uri").and include(description)

        stub_register({ "error" => "invalid_client_metadata" }, status: 400)
        expect { dcr_client.authorization_url }.to raise_error(registration_error, /status 400: invalid_client_metadata/)
        stub_register("{}", status: 201)
        expect { dcr_client.authorization_url }.to raise_error(registration_error)
      end

      it "C35: a 404 clears everything stored for that issuer and the cached metadata", :aggregate_failures do
        sign_in(dcr_client)
        expect(stored_tokens(store)).not_to be_nil
        other_issuer_tokens = ["https://other.example.com", RESOURCE, "default"]
        store.write("tokens", other_issuer_tokens, { "access_token" => "kept" })
        clock.advance((29 * 86_400) + 3600)
        stub_register({ "error" => "registration_disabled" }, status: 404)
        metadata_requests = requests(:get, METADATA).size

        expect { dcr_client.authorization_url }.to raise_error(registration_error, /answered 404/) do |failure|
          expect(failure.status).to eq(404)
        end

        expect(stored_registration(store)).to be_nil
        expect(stored_tokens(store)).to be_nil
        expect(store.read("issuers", [RESOURCE, "default"])).to be_nil
        expect(dcr_client.token_info).to be_nil
        expect(store.read("tokens", other_issuer_tokens)).to eq("access_token" => "kept")
        expect(requests(:get, METADATA).size).to eq(metadata_requests + 1)

        stub_register({ "error" => "registration_disabled" }, status: 404)
        expect { dcr_client.authorization_url }.to raise_error(registration_error)
        expect(requests(:get, METADATA).size).to eq(metadata_requests + 2)
      end
    end

    describe "authorization request" do
      it "C36: makes a new verifier, S256 challenge and state for every attempt, kept under the state", :aggregate_failures do
        first = query_of(client.authorization_url)
        second = query_of(client.authorization_url)
        record = store.read("pending", [first["state"]])
        verifier = record["code_verifier"]

        expect(verifier).to match(/\A[A-Za-z0-9\-._~]{43,128}\z/)
        expect(verifier.length).to eq(64)
        expect(first["code_challenge"]).to eq(Base64.urlsafe_encode64(Digest::SHA256.digest(verifier), padding: false))
        expect(first["state"]).to match(/\A[A-Za-z0-9_-]{22,}\z/)
        expect(first["state"].length).to eq(43)
        expect(second["state"]).not_to eq(first["state"])
        expect(second["code_challenge"]).not_to eq(first["code_challenge"])
        expect(store.read("pending", [second["state"]])["code_verifier"]).not_to eq(verifier)
        expect(record).to include(
          "issuer" => ISSUER, "token_endpoint" => TOKEN, "client_id" => CIMD, "redirect_uri" => REDIRECT,
          "resource_url" => RESOURCE, "account" => "default", "scopes" => ["offline"], "created_at" => NOW
        )
        expect(record).not_to have_key("reregistered")
      end

      it "C37: builds the URL from the authorization endpoint with exactly the eight parameters", :aggregate_failures do
        url = client.authorization_url
        query = query_of(url)

        expect(url).to start_with("#{AUTHORIZE}?")
        expect(query.keys).to contain_exactly(
          "response_type", "client_id", "redirect_uri", "scope", "state", "code_challenge", "code_challenge_method", "resource"
        )
        expect(query).to include(
          "response_type" => "code", "client_id" => CIMD, "redirect_uri" => REDIRECT, "scope" => "offline",
          "code_challenge_method" => "S256", "resource" => RESOURCE
        )
        expect(URI.decode_www_form(URI.parse(url).query).size).to eq(8)

        KindeSdk::AgentClient::Discovery.reset_cache!
        stub_metadata(server_metadata("authorization_endpoint" => "#{AUTHORIZE}?tenant=acme&scope=openid"))
        with_query = query_of(client.authorization_url)
        expect(with_query).to include("tenant" => "acme", "scope" => "offline")
        expect(with_query.size).to eq(9)

        expect(query_of(client.authorization_url(scopes: "offline email"))["scope"]).to eq("offline email")
        expect(query_of(cimd_client(scopes: []).authorization_url)).not_to have_key("scope")
      end

      it "C38: drops openid when the server's scopes_supported lacks it and keeps it otherwise", :aggregate_failures do
        configured = cimd_client(scopes: %w[openid offline profile])
        expect(query_of(configured.authorization_url)["scope"]).to eq("offline profile")
        expect(query_of(configured.authorization_url(scopes: %w[openid email]))["scope"]).to eq("email")

        KindeSdk::AgentClient::Discovery.reset_cache!
        stub_metadata(server_metadata("scopes_supported" => %w[openid offline profile]))
        expect(query_of(configured.authorization_url)["scope"]).to eq("openid offline profile")

        KindeSdk::AgentClient::Discovery.reset_cache!
        stub_metadata(server_metadata("scopes_supported" => nil))
        expect(query_of(configured.authorization_url)["scope"]).to eq("openid offline profile")
        expect(query_of(client.authorization_url)["scope"]).to eq("offline")
      end

      it "C39: sends PKCE S256 for every kind of client identity", :aggregate_failures do
        agents = [
          client,
          build_client(client_id: "confidential", client_secret: "configured-secret-value", issuer: ISSUER),
          build_client(client_id: "public"),
          dcr_client
        ]

        agents.each do |agent|
          query = query_of(agent.authorization_url)

          expect(query["code_challenge_method"]).to eq("S256")
          expect(query["code_challenge"]).to match(/\A[A-Za-z0-9_-]{43}\z/)
        end
      end
    end

    describe "callback" do
      let(:state) { query_of(client.authorization_url)["state"] }

      it "C86: refuses a callback without iss when the authorization server says it sends one", :aggregate_failures do
        stub_metadata(server_metadata("authorization_response_iss_parameter_supported" => true))

        expect { client.handle_callback("code" => CODE, "state" => state) }.to raise_error(callback_error, /no iss parameter/)
        [{ "iss" => "" }, { "iss" => [ISSUER] }].each do |extra|
          expect { client.handle_callback({ "code" => CODE, "state" => state }.merge(extra)) }
            .to raise_error(callback_error, /iss parameter that is empty or repeated/)
        end
        expect { client.handle_callback("code" => CODE, "state" => state, "iss" => "https://evil.example") }
          .to raise_error(callback_error, /another authorization server/)
        expect(token_requests).to be_empty

        # None of the refused callbacks used up the attempt.
        expect(client.handle_callback("code" => CODE, "state" => state, "iss" => ISSUER).scopes).to eq(["offline"])
      end

      it "C86: still accepts a callback without iss from a server that does not say it sends one", :aggregate_failures do
        ["false", 1, false, nil].each do |flag|
          KindeSdk::AgentClient::Discovery.reset_cache!
          stub_metadata(server_metadata("authorization_response_iss_parameter_supported" => flag))
          agent = cimd_client(storage: KindeSdk::AgentClient::MemoryStore.new)
          attempt = query_of(agent.authorization_url)["state"]

          expect(agent.handle_callback("code" => CODE, "state" => attempt).scopes).to eq(["offline"])
        end
      end

      it "C86: an iss that is there but empty or repeated is refused, also when the server need not send one", :aggregate_failures do
        [{ "iss" => "" }, { "iss" => [ISSUER] }, { "iss" => [] }, { iss: "" }, { "iss" => { "0" => ISSUER } }].each do |extra|
          expect { client.handle_callback({ "code" => CODE, "state" => state }.merge(extra)) }
            .to raise_error(callback_error, /iss parameter that is empty or repeated/), extra.inspect
        end
        expect(token_requests).to be_empty

        # None of them used up the attempt, and a nil value is no parameter at all.
        expect(client.handle_callback("code" => CODE, "state" => state, "iss" => nil).scopes).to eq(["offline"])
      end

      it "C40: refuses a missing or unknown state, with no token request and no retry", :aggregate_failures do
        state
        [
          { "code" => CODE }, { "code" => CODE, "state" => "" }, { "code" => CODE, "state" => "unknown-state" },
          { "code" => CODE, "state" => [state] }, { "code" => CODE, "state" => "#{state}x" }, {}, nil, "state=#{state}"
        ].each do |params|
          expect { client.handle_callback(params) }.to raise_error(callback_error), "params #{params.inspect}"
        end
        expect(token_requests).to be_empty
        expect(client.token_info).to be_nil

        expect(client.handle_callback(code: CODE, state: state)).to be_a(KindeSdk::AgentClient::TokenInfo)
      end

      it "C40: refuses an attempt another client started for another resource, account or redirect URI", :aggregate_failures do
        [
          cimd_client(storage: store, account: "someone-else"),
          cimd_client(storage: store, redirect_uri: "https://agent.example.com/other"),
          cimd_client(storage: store, resource_url: "https://api.example.com/mcp/v2")
        ].each do |other|
          expect { other.handle_callback("code" => CODE, "state" => state) }.to raise_error(callback_error)
        end
        expect(token_requests).to be_empty
        expect(client.handle_callback("code" => CODE, "state" => state)).to be_a(KindeSdk::AgentClient::TokenInfo)
      end

      it "C41: accepts a state once", :aggregate_failures do
        client.handle_callback("code" => CODE, "state" => state)

        expect { client.handle_callback("code" => CODE, "state" => state) }.to raise_error(callback_error, /already used/)
        expect(token_requests.size).to eq(1)
        expect(store.read("pending", [state])).to be_nil
      end

      it "C42: raises the error of the redirect with both fields, and uses up the state", :aggregate_failures do
        params = { "state" => state, "error" => "access_denied", "error_description" => "The user said no" }

        expect { client.handle_callback(params) }.to raise_error(oauth_error, /access_denied: The user said no/) do |failure|
          expect(failure.error).to eq("access_denied")
          expect(failure.error_description).to eq("The user said no")
          expect(failure.status).to be_nil
        end
        expect(token_requests).to be_empty
        expect { client.handle_callback("code" => CODE, "state" => state) }.to raise_error(callback_error)
      end

      it "C43: refuses an iss that is not the issuer before the attempt is used up, and accepts the issuer", :aggregate_failures do
        [KINDE, "https://evil.example.com", "#{ISSUER}/"].each do |iss|
          expect { client.handle_callback("code" => CODE, "state" => state, "iss" => iss) }
            .to raise_error(callback_error, /another authorization server/), "iss #{iss}"
        end
        expect(token_requests).to be_empty
        expect(store.read("pending", [state])).not_to be_nil

        expect(client.handle_callback("code" => CODE, "state" => state, "iss" => ISSUER).client_id).to eq(CIMD)
      end

      it "C44: refuses an attempt older than ten minutes, and a callback without a code", :aggregate_failures do
        old = state
        clock.advance(600)
        fresh = query_of(client.authorization_url)["state"]
        expect { client.handle_callback("state" => fresh) }.to raise_error(callback_error, /no authorization code/)
        expect { client.handle_callback("code" => CODE, "state" => fresh) }.to raise_error(callback_error)

        clock.advance(1)
        expect { client.handle_callback("code" => CODE, "state" => old) }.to raise_error(callback_error, /expired/)
        expect(store.read("pending", [old])).to be_nil
        expect(token_requests).to be_empty

        at_limit = query_of(client.authorization_url)["state"]
        clock.advance(600)
        expect(client.handle_callback("code" => CODE, "state" => at_limit)).to be_a(KindeSdk::AgentClient::TokenInfo)
      end
    end

    describe "token exchange" do
      it "C90: refuses a token that is not a Bearer token, at the exchange and at a refresh", :aggregate_failures do
        ["mac", "DPoP", "", 5].each do |type|
          stub_token(token_response("token_type" => type))
          expect { sign_in(client) }.to raise_error(oauth_error, /only Bearer tokens are supported/), type.inspect
          expect(stored_tokens(store)).to be_nil
        end

        ["Bearer", "BEARER", "bearer", nil].each do |type|
          stub_token(token_response("token_type" => type))
          expect(sign_in(cimd_client(storage: KindeSdk::AgentClient::MemoryStore.new)).scopes).to eq(["offline"]), type.inspect
        end

        stub_token
        sign_in(client)
        expire_access_token
        stub_refresh("token_type" => "mac")
        expect { client.fetch }.to raise_error(oauth_error, /only Bearer tokens are supported/)
        expect(stored_tokens(store)).to include("access_token" => ACCESS, "refresh_token" => REFRESH)
        expect(resource_requests.map { |request| bearer_of(request) }).not_to include(NEW_ACCESS)
      end

      it "C45: a public client posts the six fields, no secret, and the redirect URI of the authorization request", :aggregate_failures do
        url = client.authorization_url
        verifier = store.read("pending", [query_of(url)["state"]])["code_verifier"]
        client.handle_callback("code" => CODE, "state" => query_of(url)["state"])

        request = token_requests.first
        expect(form_of(request)).to eq(
          "grant_type" => "authorization_code", "code" => CODE, "redirect_uri" => REDIRECT,
          "code_verifier" => verifier, "client_id" => CIMD, "resource" => RESOURCE
        )
        expect(form_of(request)["redirect_uri"]).to eq(query_of(url)["redirect_uri"])
        expect(request.headers["Content-Type"]).to eq("application/x-www-form-urlencoded")
        expect(request.headers).not_to have_key("Authorization")
        expect(request.uri.query).to be_nil
      end

      it "C46: client_secret_post puts the secret in the body and sends no Authorization header", :aggregate_failures do
        sign_in(dcr_client)

        request = token_requests.first
        expect(form_of(request)).to include("client_id" => DCR_ID, "client_secret" => DCR_SECRET, "grant_type" => "authorization_code")
        expect(request.headers).not_to have_key("Authorization")
      end

      it "C47: client_secret_basic sends a Basic header with both parts form-encoded, and no secret in the body", :aggregate_failures do
        stub_metadata(server_metadata("token_endpoint_auth_methods_supported" => ["client_secret_basic"]))
        sign_in(build_client(client_id: "my client", client_secret: "s3cr3t:/+value", issuer: ISSUER))

        request = token_requests.first
        expect(request.headers["Authorization"]).to eq("Basic #{Base64.strict_encode64('my+client:s3cr3t%3A%2F%2Bvalue')}")
        expect(form_of(request)).not_to have_key("client_secret")
        expect(form_of(request)).not_to have_key("client_id")
        expect(form_of(request)).to include("grant_type" => "authorization_code", "code" => CODE)

        KindeSdk::AgentClient::Discovery.reset_cache!
        stub_metadata(server_metadata("token_endpoint_auth_methods_supported" => nil))
        sign_in(build_client(client_id: "confidential", client_secret: "configured-secret-value", issuer: ISSUER))
        expect(token_requests.last.headers["Authorization"]).to start_with("Basic ")
      end

      it "C48: accepts a response without id_token and a token that is not a JWT, and verifies nothing", :aggregate_failures do
        stub_token({ "access_token" => "opaque", "token_type" => "bearer" })

        info = sign_in(client)

        expect(info.expires_at).to be_nil
        expect(info.scopes).to eq(["offline"])
        expect(stored_tokens(store)).to include("access_token" => "opaque")
        expect(stored_tokens(store)).not_to have_key("refresh_token")
        expect(requests.map { |request| request.uri.path }.grep(/jwks/)).to be_empty
      end

      it "C48: reports a refused code, and an answer without an access token, as an OAuth error", :aggregate_failures do
        stub_token_error("invalid_grant")
        state = query_of(client.authorization_url)["state"]
        expect { client.handle_callback("code" => CODE, "state" => state) }
          .to raise_error(oauth_error, /status 400: invalid_grant: The server said invalid_grant/)

        [json_response({ "token_type" => "bearer" }), json_response("[]"), json_response("nope"), json_response(token_response, status: 201)].each do |answer|
          stub_request(:post, TOKEN).to_return(answer)
          state = query_of(client.authorization_url)["state"]

          expect { client.handle_callback("code" => CODE, "state" => state) }.to raise_error(oauth_error, /token request failed/)
        end
        expect(client.token_info).to be_nil
      end
    end

    describe "token storage" do
      it "C49: stores the tokens under issuer, resource and account, with every field", :aggregate_failures do
        sign_in(client)

        expect(stored_tokens(store)).to eq(
          "access_token" => ACCESS, "refresh_token" => REFRESH, "expires_at" => NOW + 86_400, "scope" => "offline",
          "requested_scopes" => ["offline"], "issuer" => ISSUER, "resource_url" => RESOURCE, "client_id" => CIMD
        )
        expect(store.read("issuers", [RESOURCE, "default"])).to eq(ISSUER)
      end

      it "C49: keeps the accounts of one store apart", :aggregate_failures do
        alice = cimd_client(storage: store, account: "alice")
        bob = cimd_client(storage: store, account: "bob")
        sign_in(alice)
        stub_token(token_response("access_token" => NEW_ACCESS))
        sign_in(bob)

        expect(stored_tokens(store, account: "alice")["access_token"]).to eq(ACCESS)
        expect(stored_tokens(store, account: "bob")["access_token"]).to eq(NEW_ACCESS)
        expect(stored_tokens(store)).to be_nil
        expect(client.token_info).to be_nil

        alice.disconnect
        expect(alice.token_info).to be_nil
        expect(bob.token_info).not_to be_nil
      end
    end

    describe "#fetch" do
      it "C50: sends the token to the resource, and no other request ever carries it", :aggregate_failures do
        sign_in(dcr_client)
        response = dcr_client.fetch(nil, headers: { "authorization" => "Bearer caller-supplied", "X-Trace" => "1" })
        expire_access_token
        stub_refresh
        dcr_client.fetch("/tools?page=2")
        dcr_client.disconnect

        expect(response).to be_a(KindeSdk::AgentClient::Response)
        expect(response.status).to eq(200)
        expect(response.body).to eq("resource says hello")
        expect(response.headers["content-type"]).to eq("text/plain")
        first = resource_requests.first
        expect(first.headers["Authorization"]).to eq("Bearer #{ACCESS}")
        expect(first.headers["X-Trace"]).to eq("1")

        elsewhere = requests.reject { |request| request.uri.host == "api.example.com" && request.uri.path.start_with?("/mcp") }
        expect(elsewhere.map { |request| request_url(request) }.uniq).to contain_exactly(PRM, METADATA, REGISTER, TOKEN, REVOKE)
        elsewhere.each do |request|
          expect(request.headers["Authorization"].to_s).not_to match(/Bearer/i), "#{request_url(request)} got a bearer token"
        end
        expect(requests(:get, "#{RESOURCE}/tools").map { |request| bearer_of(request) }).to eq([ACCESS, NEW_ACCESS])
      end

      it "C50: builds the URL from resource_url and the path", :aggregate_failures do
        stub_request(:any, %r{\Ahttps://api\.example\.com/mcp}).to_return(status: 204)
        sign_in(client)

        client.fetch
        client.fetch("")
        client.fetch("/tools")
        client.fetch("tools/list")
        client.fetch("?page=2")
        client.fetch("#{RESOURCE}/absolute?x=1", method: "POST", body: "{}")
        client.fetch("https://API.example.com:443/mcp/", method: :delete)

        made = requests.select { |request| request.uri.path.start_with?("/mcp") }
        expect(made.map { |request| [request.method, request.uri.to_s] }).to eq(
          [
            [:get, "https://api.example.com:443/mcp"], [:get, "https://api.example.com:443/mcp"],
            [:get, "https://api.example.com:443/mcp/tools"],
            [:get, "https://api.example.com:443/mcp/tools/list"], [:get, "https://api.example.com:443/mcp?page=2"],
            [:post, "https://api.example.com:443/mcp/absolute?x=1"], [:delete, "https://api.example.com:443/mcp/"]
          ]
        )
      end

      it "C50: a path with a colon is a path, not an absolute URL", :aggregate_failures do
        stub_request(:any, %r{\Ahttps://api\.example\.com/mcp}).to_return(status: 204)
        sign_in(client)

        expect(client.fetch("tools:list").status).to eq(204)
        client.fetch("v1:batchGet", method: :post)
        client.fetch("/tools:list?x=a:b")

        made = requests.select { |request| request.uri.path.start_with?("/mcp/") }
        expect(made.map { |request| [request.method, request.uri.to_s] }).to eq(
          [
            [:get, "https://api.example.com:443/mcp/tools:list"], [:post, "https://api.example.com:443/mcp/v1:batchGet"],
            [:get, "https://api.example.com:443/mcp/tools:list?x=a:b"]
          ]
        )
        made.each { |request| expect(bearer_of(request)).to eq(ACCESS) }
      end

      it "C50: with a query in resource_url, the path goes before the query", :aggregate_failures do
        stub_request(:any, %r{\Ahttps://api\.example\.com/mcp}).to_return(status: 204)
        tenant = cimd_client(storage: store, resource_url: "#{RESOURCE}?tenant=1")
        sign_in(tenant)
        # WebMock records a query with its parameters sorted, so the URLs are taken where they are sent.
        sent = []
        allow(KindeSdk::AgentClient::Http).to receive(:request).and_wrap_original do |original, verb, url, **options|
          sent << url
          original.call(verb, url, **options)
        end

        tenant.fetch
        tenant.fetch("/tools")
        tenant.fetch("tools/list?page=2")
        tenant.fetch("?page=2")

        expect(sent).to eq(
          [
            "#{RESOURCE}?tenant=1", "#{RESOURCE}/tools?tenant=1",
            "#{RESOURCE}/tools/list?tenant=1&page=2", "#{RESOURCE}?tenant=1&page=2"
          ]
        )
        made = requests.select { |request| request.uri.path.start_with?("/mcp") }
        expect(made.map { |request| request.uri.path }).to eq(%w[/mcp /mcp/tools /mcp/tools/list /mcp])
        made.each { |request| expect(bearer_of(request)).to eq(ACCESS) }
      end

      it "C91: refuses a dot segment behind an encoded separator, and still allows an encoded slash", :aggregate_failures do
        sign_in(client)
        made = requests.size

        [
          "/%2e%2e%2fadmin", "/..%2Fadmin", "/tools%2f..%2f..%2fadmin", "/tools/%2E%2E%5Cadmin", "/x%5c..%5cadmin",
          "/.%2fx", "/tools%2f%2e%2e", "https://api.example.com/mcp/%2e%2e%2fadmin"
        ].each do |target|
          expect { client.fetch(target) }.to raise_error(ArgumentError, /fetch only calls/), "expected #{target.inspect} to be refused"
        end
        expect(requests.size).to eq(made)

        expect(client.fetch("/files/a%2Fb").status).to eq(200)
        expect(client.fetch("/files/..a%2F.b/c..").status).to eq(200)
      end

      it "C51: refuses another origin, another port and a path outside the resource, before any request", :aggregate_failures do
        sign_in(client)
        made = requests.size

        [
          "https://evil.example/x", "https://api.example.com:8443/mcp", "http://api.example.com/mcp",
          "https://api.example.com/other", "https://api.example.com/mcpx", "https://api.example.com/",
          "https://user:pw@api.example.com/mcp", "/../admin", "/tools/../../admin", "/%2e%2e/admin", "/./x",
          "https://api.example.com/mcp/../admin", "https://evil.example//api.example.com/mcp",
          "ftp://api.example.com/mcp", "https://api.example.com.evil.example/mcp", "/tools with space"
        ].each do |target|
          expect { client.fetch(target) }.to raise_error(ArgumentError), "expected #{target.inspect} to be refused"
        end
        expect { client.fetch(method: :trace) }.to raise_error(ArgumentError, /method/)
        expect { client.fetch(body: { "a" => 1 }) }.to raise_error(ArgumentError, /body/)
        expect { client.fetch(headers: "X: 1") }.to raise_error(ArgumentError, /headers/)
        expect(requests.size).to eq(made)
      end

      it "C52: returns a redirect instead of following it", :aggregate_failures do
        sign_in(client)
        stub_request(:get, RESOURCE).to_return(status: 302, headers: { "Location" => "https://evil.example/steal" })

        response = client.fetch

        expect(response.status).to eq(302)
        expect(response.headers["location"]).to eq("https://evil.example/steal")
        expect(requests.map { |request| request.uri.host }).not_to include("evil.example")
      end

      it "C52: reports a resource that cannot be reached as unavailable", :aggregate_failures do
        sign_in(client)
        stub_request(:get, RESOURCE).to_timeout

        expect { client.fetch }.to raise_error(unavailable_error, "https://api.example.com/mcp could not be reached")
        expect(stored_tokens(store)).not_to be_nil
      end
    end

    describe "refresh" do
      it "C53: refreshes a token within 60 seconds of expiry before calling the resource", :aggregate_failures do
        sign_in(client)
        clock.advance(86_400 - 61)
        expect(client.fetch.status).to eq(200)
        expect(token_requests("refresh_token")).to be_empty

        clock.advance(1)
        expire_access_token
        stub_refresh("expires_in" => 3600)
        expect(client.fetch.status).to eq(200)

        expect(token_requests("refresh_token").size).to eq(1)
        expect(resource_requests.map { |request| bearer_of(request) }).to eq([ACCESS, NEW_ACCESS])
        expect(stored_tokens(store)).to include("access_token" => NEW_ACCESS, "expires_at" => clock.now + 3600)
      end

      it "C54: on a 401 refreshes once and sends the request once more", :aggregate_failures do
        sign_in(client)
        expire_access_token
        stub_refresh

        response = client.fetch

        expect(response.status).to eq(200)
        expect(resource_requests.map { |request| bearer_of(request) }).to eq([ACCESS, NEW_ACCESS])
        expect(token_requests("refresh_token").size).to eq(1)
        expect(client.fetch.status).to eq(200)
        expect(token_requests("refresh_token").size).to eq(1)
      end

      it "C55: keeps the stored refresh token when the response has none", :aggregate_failures do
        sign_in(client)
        expire_access_token
        stub_refresh("refresh_token" => nil, "scope" => nil)
        client.fetch

        expect(stored_tokens(store)).to include("access_token" => NEW_ACCESS, "refresh_token" => REFRESH, "scope" => "offline")

        stub_refresh("refresh_token" => "")
        valid.replace(["third"])
        stub_token(token_response("access_token" => "third", "refresh_token" => ""))
        client.fetch
        expect(stored_tokens(store)).to include("access_token" => "third", "refresh_token" => REFRESH)
      end

      it "C56: replaces the stored refresh token when the response has a new one", :aggregate_failures do
        sign_in(client)
        expire_access_token
        stub_refresh("refresh_token" => NEW_REFRESH)
        client.fetch

        expect(stored_tokens(store)).to include("access_token" => NEW_ACCESS, "refresh_token" => NEW_REFRESH)

        valid.replace(["third"])
        stub_token(token_response("access_token" => "third", "refresh_token" => nil))
        client.fetch
        expect(form_of(token_requests("refresh_token").last)["refresh_token"]).to eq(NEW_REFRESH)
      end

      it "C57: posts grant_type, refresh_token, client_id and resource, with the secret the method asks for", :aggregate_failures do
        sign_in(client)
        expire_access_token
        stub_refresh
        client.fetch
        expect(form_of(token_requests("refresh_token").last)).to eq(
          "grant_type" => "refresh_token", "refresh_token" => REFRESH, "client_id" => CIMD, "resource" => RESOURCE
        )
        expect(token_requests("refresh_token").last.headers).not_to have_key("Authorization")

        other = KindeSdk::AgentClient::MemoryStore.new
        registered = build_client(storage: other)
        valid.replace([ACCESS])
        stub_token
        sign_in(registered)
        expire_access_token
        stub_refresh
        registered.fetch
        expect(form_of(token_requests("refresh_token").last)).to eq(
          "grant_type" => "refresh_token", "refresh_token" => REFRESH, "client_id" => DCR_ID,
          "client_secret" => DCR_SECRET, "resource" => RESOURCE
        )
      end

      it "C58: invalid_grant deletes the tokens and asks to sign in again", :aggregate_failures do
        sign_in(client)
        expire_access_token
        stub_token_error("invalid_grant")

        error = sign_in_needed { client.fetch }

        expect(error.authorization_url).to start_with(AUTHORIZE)
        expect(stored_tokens(store)).to be_nil
        expect(client.token_info).to be_nil
        expect(token_requests("refresh_token").size).to eq(1)
        expect(resource_requests.size).to eq(1)

        valid.replace([ACCESS])
        stub_token
        client.handle_callback("code" => CODE, "state" => error.state)
        expect(client.fetch.status).to eq(200)
      end

      it "C59: invalid_client for a registered client registers once more, deletes the tokens and asks to sign in", :aggregate_failures do
        sign_in(dcr_client)
        expire_access_token
        stub_token_error("invalid_client", status: 401)
        stub_register(registration_response("client_id" => "dcr-client-id-two"))

        error = sign_in_needed { dcr_client.fetch }

        expect(query_of(error.authorization_url)["client_id"]).to eq("dcr-client-id-two")
        expect(requests(:post, REGISTER).size).to eq(2)
        expect(stored_registration(store)["client_id"]).to eq("dcr-client-id-two")
        expect(stored_tokens(store)).to be_nil
        expect(store.read("pending", [error.state])).to include("reregistered" => true)
      end

      it "C59: invalid_client for a client that did not register itself is an error and keeps the tokens", :aggregate_failures do
        sign_in(client)
        expire_access_token
        stub_token_error("invalid_client", status: 401)

        expect { client.fetch }.to raise_error(oauth_error) { |failure| expect(failure.error).to eq("invalid_client") }
        expect(requests(:post, REGISTER)).to be_empty
        expect(stored_tokens(store)).not_to be_nil
      end

      it "C60: any other refresh failure is an error and keeps the tokens", :aggregate_failures do
        sign_in(client)
        expire_access_token
        stub_token({ "error" => "server_error" }, status: 500)
        expect { client.fetch }.to raise_error(oauth_error, /status 500: server_error/) { |failure| expect(failure.status).to eq(500) }
        expect(stored_tokens(store)).to include("access_token" => ACCESS, "refresh_token" => REFRESH)

        stub_request(:post, TOKEN).to_timeout
        expect { client.fetch }.to raise_error(unavailable_error)
        expect(stored_tokens(store)).to include("access_token" => ACCESS, "refresh_token" => REFRESH)

        clock.advance(86_400)
        expect { client.connect }.to raise_error(unavailable_error)
        expect(stored_tokens(store)).to include("refresh_token" => REFRESH)
      end

      it "C98: a store whose write returns something else than the value still refreshes", :aggregate_failures do
        answering_true = Class.new(KindeSdk::AgentClient::MemoryStore) do
          def write(namespace, key, value)
            super
            true
          end
        end.new
        agent = cimd_client(storage: answering_true)
        sign_in(agent)
        expire_access_token
        stub_refresh("expires_in" => 600)

        expect(agent.fetch.status).to eq(200)
        expect(resource_requests.map { |request| bearer_of(request) }).to eq([ACCESS, NEW_ACCESS])

        clock.advance(590)
        stub_refresh("expires_in" => 900)
        expect(agent.connect.expires_at).to eq(clock.now + 900)
        expect(stored_tokens(answering_true)).to include("access_token" => NEW_ACCESS, "refresh_token" => REFRESH)
      end

      it "C101: an OAuth error code in a 5xx answer deletes neither the tokens nor the registration", :aggregate_failures do
        sign_in(dcr_client)
        clock.advance(86_400)

        %w[invalid_grant invalid_client].each do |code|
          stub_token_error(code, status: 503)
          expect { dcr_client.fetch }.to(raise_error { |error| expect([error.class, error.status, error.error]).to eq([oauth_error, 503, code]) })
          expect { dcr_client.connect }.to(raise_error { |error| expect(error.class).to eq(oauth_error) })
          expect(stored_tokens(store)).to include("access_token" => ACCESS, "refresh_token" => REFRESH)
          expect(stored_registration(store)).to include("client_id" => DCR_ID)
        end
        expect(resource_requests).to be_empty
        expect(requests(:post, REGISTER).size).to eq(1)

        # The same at the code exchange: the registration is not taken for refused.
        other_store = KindeSdk::AgentClient::MemoryStore.new
        agent = build_client(storage: other_store)
        attempt = query_of(agent.authorization_url)["state"]
        stub_token_error("invalid_client", status: 502)
        expect { agent.handle_callback("code" => CODE, "state" => attempt) }
          .to(raise_error { |error| expect(error.class).to eq(oauth_error) })
        expect(stored_registration(other_store)).to include("client_id" => DCR_ID)
        expect(requests(:post, REGISTER).size).to eq(2)

        # A 4xx answer with the code still means what it says.
        stub_token_error("invalid_grant", status: 400)
        sign_in_needed { dcr_client.fetch }
        expect(stored_tokens(store)).to be_nil
      end

      it "C99: the on_auth_required block runs after the token lock is released, so it can sign the user out", :aggregate_failures do
        sign_in(client)
        clock.advance(86_400)
        stub_token_error("invalid_grant")
        seen = []
        client.on_auth_required do |url|
          seen << url
          client.disconnect
        end

        error = sign_in_needed { client.fetch }

        expect(seen).to eq([error.authorization_url])
        expect(stored_tokens(store)).to be_nil
        expect(resource_requests).to be_empty

        # The same when the registration is refused, and when the refresh follows a 401.
        stub_token
        sign_in(dcr_client)
        valid.clear
        stub_token_error("invalid_client", status: 401)
        dcr_client.on_auth_required do |url|
          seen << url
          dcr_client.disconnect
        end

        error = sign_in_needed { dcr_client.fetch }

        expect(seen.last).to eq(error.authorization_url)
        expect(requests(:post, REGISTER).size).to eq(2)
        expect(stored_tokens(store)).to be_nil
        expect(KindeSdk::AgentClient::KeyedLock.instance_variable_get(:@table)).to be_empty
      end

      it "C97: users with a session each do not wait for each other's refresh", :aggregate_failures do
        ada = cimd_client(storage: KindeSdk::AgentClient::SessionStore.new({}))
        grace = cimd_client(storage: KindeSdk::AgentClient::SessionStore.new({}))
        [ada, grace].each { |agent| sign_in(agent) }
        clock.advance(86_400)
        expire_access_token
        entered = Queue.new
        release = Queue.new
        stub_slow_refresh(entered, release)

        slow = Thread.new { ada.fetch.status }
        wait_for(entered, slow)
        other = Thread.new { grace.fetch.status }

        # Grace's refresh goes through while Ada's is still waiting for the token endpoint.
        expect(other.join(5)).not_to be_nil
        expect(other.value).to eq(200)
        expect(slow).to be_alive
        release << true
        expect(slow.value).to eq(200)
        expect(token_requests("refresh_token").size).to eq(2)
      ensure
        stop_workers(release, slow, other)
      end

      it "C97: a store of your own without lock_scope keeps one lock per record, whichever object wraps the data", :aggregate_failures do
        wrapper = Class.new do
          def initialize(inner) = @inner = inner
          def read(namespace, key) = @inner.read(namespace, key)
          def write(namespace, key, value) = @inner.write(namespace, key, value)
          def delete(namespace, key) = @inner.delete(namespace, key)
        end
        first = cimd_client(storage: wrapper.new(store))
        second = cimd_client(storage: wrapper.new(store))
        sign_in(first)
        clock.advance(86_400)
        expire_access_token
        entered = Queue.new
        release = Queue.new
        stub_slow_refresh(entered, release)

        slow = Thread.new { first.fetch.status }
        wait_for(entered, slow)
        waiting = Thread.new { second.fetch.status }
        settle(waiting)
        expect(waiting).to be_alive
        release << true

        expect([slow.value, waiting.value]).to eq([200, 200])
        expect(token_requests("refresh_token").size).to eq(1)
      ensure
        stop_workers(release, slow, waiting)
      end

      it "C97: the built-in stores name their own data as the lock scope", :aggregate_failures do
        storage = KindeSdk::AgentClient::Storage
        session = {}
        over_session = KindeSdk::AgentClient::SessionStore.new(session)

        expect(store.lock_scope).to eq(store.lock_scope)
        expect(store.lock_scope).not_to eq(KindeSdk::AgentClient::MemoryStore.new.lock_scope)
        expect(over_session.lock_scope).to eq(KindeSdk::AgentClient::SessionStore.new(session).lock_scope)
        expect(over_session.lock_scope).not_to eq(KindeSdk::AgentClient::SessionStore.new({}).lock_scope)
        expect(over_session.lock_scope).not_to eq(KindeSdk::AgentClient::SessionStore.new(session, key: "other").lock_scope)
        expect(storage.lock_scope(store)).to eq(store.lock_scope)
        expect(storage.lock_scope(Object.new)).to be_nil
        expect(storage.lock_scope(Struct.new(:lock_scope).new("tenant-7"))).to eq("tenant-7")
      end

      # Every thread gets a 401 for the old token before the one refresh
      # answers: the token stub waits until the resource has refused them all.
      def concurrent_fetches(agents)
        refused = Queue.new
        stub_request(:get, RESOURCE).to_return do |request|
          if bearer_of(request) == NEW_ACCESS
            { status: 200, body: "ok" }
          else
            refused << true
            { status: 401, headers: { "WWW-Authenticate" => %(Bearer error="invalid_token", resource_metadata="#{PRM}") } }
          end
        end
        stub_request(:post, TOKEN).to_return do |_request|
          deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + 10
          Thread.pass until refused.size >= agents.size || Process.clock_gettime(Process::CLOCK_MONOTONIC) > deadline
          json_response(token_response("access_token" => NEW_ACCESS, "refresh_token" => NEW_REFRESH))
        end

        agents.map { |agent| Thread.new { agent.fetch.status } }.map(&:value)
      end

      it "C61: eight threads on one client that all get a 401 send exactly one refresh", :aggregate_failures do
        sign_in(client)

        statuses = concurrent_fetches([client] * 8)

        expect(statuses).to eq([200] * 8)
        expect(token_requests("refresh_token").size).to eq(1)
        expect(resource_requests.map { |request| bearer_of(request) }.tally).to eq(ACCESS => 8, NEW_ACCESS => 8)
        expect(stored_tokens(store)).to include("access_token" => NEW_ACCESS, "refresh_token" => NEW_REFRESH)
      end

      it "C62: two clients that share a store send exactly one refresh", :aggregate_failures do
        sign_in(client)
        twin = cimd_client(storage: store)

        statuses = concurrent_fetches(([client] * 4) + ([twin] * 4))

        expect(statuses).to eq([200] * 8)
        expect(token_requests("refresh_token").size).to eq(1)
        expect(KindeSdk::AgentClient::KeyedLock.instance_variable_get(:@table)).to be_empty
      end
    end

    describe "#fetch when the token is refused" do
      it "C63: a 401 after the refresh deletes the tokens and asks to sign in, without a loop", :aggregate_failures do
        sign_in(client)
        valid.clear
        stub_refresh

        error = sign_in_needed { client.fetch }

        expect(error.authorization_url).to start_with(AUTHORIZE)
        expect(token_requests("refresh_token").size).to eq(1)
        expect(resource_requests.map { |request| bearer_of(request) }).to eq([ACCESS, NEW_ACCESS])
        expect(stored_tokens(store)).to be_nil
      end

      it "C63: a 401 for a token that cannot be refreshed asks to sign in after one request", :aggregate_failures do
        stub_token(token_response("refresh_token" => nil))
        sign_in(client)
        valid.clear

        sign_in_needed { client.fetch }

        expect(resource_requests.size).to eq(1)
        expect(token_requests("refresh_token")).to be_empty
        expect(stored_tokens(store)).to be_nil
      end

      it "C63: does not refresh twice when the token was refreshed before the request", :aggregate_failures do
        sign_in(client)
        clock.advance(86_400)
        valid.clear
        stub_refresh

        sign_in_needed { client.fetch }

        expect(token_requests("refresh_token").size).to eq(1)
        expect(resource_requests.map { |request| bearer_of(request) }).to eq([NEW_ACCESS])
      end

      it "C64: with nothing stored sends one request without a token, then asks to sign in", :aggregate_failures do
        seen = []
        client.on_auth_required { |url| seen << url }

        error = sign_in_needed { client.fetch }

        expect(resource_requests.size).to eq(1)
        expect(resource_requests.first.headers).not_to have_key("Authorization")
        expect(error.authorization_url).to start_with("#{AUTHORIZE}?")
        expect(error.state).to eq(query_of(error.authorization_url)["state"])
        expect(seen).to eq([error.authorization_url])
        expect(error.message).to eq("The user has to sign in")
      end

      it "C64: returns what a resource answers without a token when it asks for none", :aggregate_failures do
        stub_request(:get, RESOURCE).to_return(status: 200, body: "public")

        expect(client.fetch.body).to eq("public")
        expect(requests.size).to eq(1)
      end

      it "C64: sends a stored token it finds for the discovered issuer when its pointer is missing", :aggregate_failures do
        sign_in(client)
        store.delete("issuers", [RESOURCE, "default"])

        expect(client.token_info).to be_nil
        expect(client.fetch.status).to eq(200)
        expect(resource_requests.map { |request| bearer_of(request) }).to eq([nil, ACCESS])
        expect(store.read("issuers", [RESOURCE, "default"])).to eq(ISSUER)
      end

      it "C64: drops tokens of an authorization server the resource no longer names", :aggregate_failures do
        sign_in(client)
        valid.clear
        moved = "https://auth.example.org"
        stub_prm({ "resource" => RESOURCE, "authorization_servers" => [moved] })
        stub_metadata(
          server_metadata("issuer" => moved, "authorization_endpoint" => "#{moved}/authorize", "token_endpoint" => "#{moved}/token"),
          url: "#{moved}/.well-known/oauth-authorization-server"
        )

        error = sign_in_needed { client.fetch }

        expect(error.authorization_url).to start_with("#{moved}/authorize?")
        expect(stored_tokens(store)).to be_nil
        expect(token_requests).to eq(token_requests("authorization_code"))
      end

      it "C95: a refresh at the old authorization server does not use up the refresh at the one the resource names now", :aggregate_failures do
        sign_in(client)
        moved = "https://auth.example.org"
        store.write("tokens", [moved, RESOURCE, "default"],
                    "access_token" => "moved-access-old", "refresh_token" => "moved-refresh", "expires_at" => NOW + (30 * 86_400),
                    "scope" => "offline", "requested_scopes" => ["offline"], "issuer" => moved, "resource_url" => RESOURCE,
                    "client_id" => CIMD)
        clock.advance(86_400) # the stored issuer's token is due: it is refreshed before the request
        stub_refresh
        valid.replace(["moved-access-new"])
        stub_prm({ "resource" => RESOURCE, "authorization_servers" => [moved] })
        stub_metadata(
          server_metadata("issuer" => moved, "authorization_endpoint" => "#{moved}/authorize", "token_endpoint" => "#{moved}/token"),
          url: "#{moved}/.well-known/oauth-authorization-server"
        )
        stub_token(token_response("access_token" => "moved-access-new", "refresh_token" => nil), url: "#{moved}/token")

        expect(client.fetch.status).to eq(200)

        expect(resource_requests.map { |request| bearer_of(request) }).to eq([NEW_ACCESS, "moved-access-old", "moved-access-new"])
        expect(token_requests("refresh_token").size).to eq(1)
        expect(form_of(token_requests("refresh_token", url: "#{moved}/token").first)).to include("refresh_token" => "moved-refresh")
        expect(stored_tokens(store)).to be_nil
        expect(stored_tokens(store, issuer: moved)).to include("access_token" => "moved-access-new", "refresh_token" => "moved-refresh")
        expect(store.read("issuers", [RESOURCE, "default"])).to eq(moved)
      end

      describe "a 401 for tokens that were replaced while the request was under way" do
        let(:newer) { stored_tokens(store).merge("access_token" => NEW_ACCESS) }

        # The resource refuses the old token, and a sign-in finishes at that moment.
        def stub_resource_with_sign_in_meanwhile(accepted)
          stub_request(:get, RESOURCE).to_return do |request|
            if accepted.include?(bearer_of(request))
              { status: 200, body: "ok" }
            else
              store.write("tokens", [ISSUER, RESOURCE, "default"], newer)
              { status: 401, headers: { "WWW-Authenticate" => %(Bearer error="invalid_token", resource_metadata="#{PRM}") } }
            end
          end
        end

        before do
          stub_token(token_response("refresh_token" => nil))
          sign_in(client)
          newer
        end

        it "C96: keeps the newer tokens and sends them once", :aggregate_failures do
          stub_resource_with_sign_in_meanwhile([NEW_ACCESS])

          expect(client.fetch.status).to eq(200)

          expect(resource_requests.map { |request| bearer_of(request) }).to eq([ACCESS, NEW_ACCESS])
          expect(stored_tokens(store)).to include("access_token" => NEW_ACCESS)
          expect(token_requests("refresh_token")).to be_empty
        end

        it "C96: deletes the newer tokens too when the resource refuses them, and asks to sign in", :aggregate_failures do
          stub_resource_with_sign_in_meanwhile([])

          sign_in_needed { client.fetch }

          expect(resource_requests.map { |request| bearer_of(request) }).to eq([ACCESS, NEW_ACCESS])
          expect(stored_tokens(store)).to be_nil
        end
      end

      it "C96: a sign-in that finishes during a refresh stores its tokens after it, so the refresh does not replace them", :aggregate_failures do
        sign_in(client)
        attempt = query_of(client.authorization_url)["state"]
        clock.advance(86_400)
        valid.replace([NEW_ACCESS, "access-token-from-sign-in"])
        entered = Queue.new
        release = Queue.new
        stub_slow_refresh(entered, release)

        refreshing = Thread.new { client.fetch.status }
        wait_for(entered, refreshing)
        # Ten minutes have not passed for the attempt: the clock moved a day, so it is started again here.
        attempt = query_of(client.authorization_url)["state"]
        signing_in = Thread.new { cimd_client(storage: store).handle_callback("code" => CODE, "state" => attempt) }
        settle(signing_in)
        expect(signing_in).to be_alive
        release << true

        expect(refreshing.value).to eq(200)
        expect(signing_in.value.scopes).to eq(["offline"])
        expect(stored_tokens(store)).to include("access_token" => "access-token-from-sign-in", "refresh_token" => "refresh-token-from-sign-in")
      ensure
        stop_workers(release, refreshing, signing_in)
      end

      it "C65: sends the same body again on the retry", :aggregate_failures do
        sign_in(client)
        expire_access_token
        stub_refresh
        body = JSON.generate("jsonrpc" => "2.0", "method" => "tools/list", "id" => 1)

        response = client.fetch(nil, method: :post, headers: { "Content-Type" => "application/json" }, body: body)

        expect(response.status).to eq(200)
        sent = requests(:post, RESOURCE)
        expect(sent.map(&:body)).to eq([body, body])
        expect(sent.map { |request| request.headers["Content-Type"] }).to eq(["application/json"] * 2)
        expect(sent.map { |request| bearer_of(request) }).to eq([ACCESS, NEW_ACCESS])
      end
    end

    describe "#disconnect" do
      it "C92: waits for a refresh that is under way, so the refresh cannot put tokens back after the sign-out", :aggregate_failures do
        sign_in(client)
        clock.advance(86_400)
        expire_access_token
        entered = Queue.new
        release = Queue.new
        stub_slow_refresh(entered, release)

        refreshing = Thread.new { client.fetch.status }
        wait_for(entered, refreshing)
        signing_out = Thread.new { cimd_client(storage: store).disconnect }
        settle(signing_out)
        release << true

        expect(refreshing.value).to eq(200)
        expect(signing_out.value).to be(true)
        expect(stored_tokens(store)).to be_nil
        expect(store.read("issuers", [RESOURCE, "default"])).to be_nil
        expect(form_of(requests(:post, REVOKE).last)).to include("token" => NEW_REFRESH)
      ensure
        stop_workers(release, refreshing, signing_out)
      end

      it "C66: a public client revokes the refresh token with its client_id, and the tokens and pointer are deleted", :aggregate_failures do
        sign_in(dcr_client)
        store.delete("tokens", [ISSUER, RESOURCE, "default"])
        store.delete("issuers", [RESOURCE, "default"])
        sign_in(client)

        expect(client.disconnect).to be(true)

        request = requests(:post, REVOKE).first
        expect(form_of(request)).to eq("token" => REFRESH, "token_type_hint" => "refresh_token", "client_id" => CIMD)
        expect(request.headers).not_to have_key("Authorization")
        expect(request.headers["Content-Type"]).to eq("application/x-www-form-urlencoded")
        expect(stored_tokens(store)).to be_nil
        expect(store.read("issuers", [RESOURCE, "default"])).to be_nil
        expect(client.token_info).to be_nil
        expect(stored_registration(store)).to include("client_id" => DCR_ID)

        expect(client.disconnect).to be(true)
        expect(requests(:post, REVOKE).size).to eq(1)
      end

      it "C67: a registered client authenticates as at the token endpoint; forget also deletes the registration", :aggregate_failures do
        sign_in(dcr_client)
        dcr_client.disconnect
        expect(form_of(requests(:post, REVOKE).last)).to eq(
          "token" => REFRESH, "token_type_hint" => "refresh_token", "client_id" => DCR_ID, "client_secret" => DCR_SECRET
        )
        expect(stored_registration(store)).not_to be_nil

        sign_in(dcr_client)
        expect(dcr_client.disconnect(forget: true)).to be(true)
        expect(stored_registration(store)).to be_nil
        expect(stored_tokens(store)).to be_nil
        expect(requests(:post, REGISTER).size).to eq(1)

        KindeSdk::AgentClient::Discovery.reset_cache!
        stub_metadata(server_metadata("token_endpoint_auth_methods_supported" => ["client_secret_basic"]))
        basic = build_client(client_id: "confidential", client_secret: "configured-secret-value", issuer: ISSUER)
        sign_in(basic)
        basic.disconnect
        expect(requests(:post, REVOKE).last.headers["Authorization"])
          .to eq("Basic #{Base64.strict_encode64('confidential:configured-secret-value')}")
        expect(form_of(requests(:post, REVOKE).last)).to eq("token" => REFRESH, "token_type_hint" => "refresh_token")
      end

      it "C67: forget deletes the registration when the sign-in was never finished, and after a plain disconnect", :aggregate_failures do
        dcr_client.authorization_url
        expect(stored_registration(store)).to include("client_secret" => DCR_SECRET)
        expect(store.read("issuers", [RESOURCE, "default"])).to be_nil

        expect(dcr_client.disconnect(forget: true)).to be(true)
        expect(stored_registration(store)).to be_nil
        expect(requests(:post, REVOKE)).to be_empty

        sign_in(dcr_client)
        dcr_client.disconnect
        expect(stored_registration(store)).not_to be_nil
        expect(build_client(storage: store).disconnect(forget: true)).to be(true)
        expect(stored_registration(store)).to be_nil
        expect(logs).to be_empty
      end

      it "C67: forget without stored tokens does not raise when the authorization server cannot be found", :aggregate_failures do
        dcr_client.authorization_url
        stub_request(:get, PRM).to_timeout

        expect(dcr_client.disconnect(forget: true)).to be(true)
        expect(stored_registration(store)).not_to be_nil
        expect(logs.map(&:first)).to eq([:warn])
        expect(logs.flatten.join).not_to include(DCR_SECRET)

        stub_prm({ "error" => "not_found" }, status: 404)
        stub_prm({ "error" => "not_found" }, url: PRM_ROOT, status: 404)
        expect(dcr_client.disconnect(forget: true)).to be(true)
        expect(logs.size).to eq(2)
        expect(dcr_client.disconnect).to be(true)
        expect(logs.size).to eq(2)
      end

      it "C68: a failed revocation is logged once and ignored; the tokens are deleted", :aggregate_failures do
        sign_in(client)
        stub_revoke(status: 500)
        expect(client.disconnect).to be(true)
        expect(stored_tokens(store)).to be_nil
        expect(logs.map(&:first)).to eq([:warn])
        expect(logs.first.last).to include("500")

        logs.clear
        sign_in(client)
        stub_request(:post, REVOKE).to_timeout
        expect(client.disconnect).to be(true)
        expect(stored_tokens(store)).to be_nil
        expect(logs.size).to eq(1)

        logs.clear
        sign_in(client)
        KindeSdk::AgentClient::Discovery.reset_cache!
        stub_request(:get, METADATA).to_timeout
        expect(client.disconnect).to be(true)
        expect(stored_tokens(store)).to be_nil
        expect(logs.size).to eq(1)
        expect(logs.flatten.join).not_to match(/#{ACCESS}|#{REFRESH}/)
      end

      it "C69: without a revocation endpoint nothing is called and the tokens are deleted", :aggregate_failures do
        stub_metadata(server_metadata("revocation_endpoint" => nil))
        sign_in(client)
        made = requests(:post).size

        expect(client.disconnect).to be(true)

        expect(requests(:post).size).to eq(made)
        expect(requests(:post, REVOKE)).to be_empty
        expect(stored_tokens(store)).to be_nil
        expect(cimd_client.disconnect).to be(true)
      end

      it "C70: revokes the access token when there is no refresh token" do
        stub_token(token_response("refresh_token" => nil))
        sign_in(client)
        client.disconnect

        expect(form_of(requests(:post, REVOKE).first)).to eq("token" => ACCESS, "token_type_hint" => "refresh_token", "client_id" => CIMD)
      end
    end

    describe "server-hosted sign-in" do
      it "C71: connect with nothing stored raises at once with the URL and the state, and tells the callback", :aggregate_failures do
        seen = []
        expect(client.on_auth_required { |url| seen << url }).to equal(client)

        error = sign_in_needed { client.connect }

        expect(error.authorization_url).to start_with("#{AUTHORIZE}?")
        expect(error.state).to eq(query_of(error.authorization_url)["state"])
        expect(store.read("pending", [error.state])).to include("code_verifier" => a_kind_of(String))
        expect(seen).to eq([error.authorization_url])
        expect(requested_urls).to eq([PRM, METADATA])
        expect(resource_requests).to be_empty
      end

      it "C72: authorization_url and handle_callback sign in; connect then returns the token info", :aggregate_failures do
        seen = []
        client.on_auth_required { |url| seen << url }
        url = client.authorization_url
        expect(url).to be_a(String)
        expect(seen).to be_empty

        info = client.handle_callback(code: CODE, state: query_of(url)["state"])
        expect(info).to eq(KindeSdk::AgentClient::TokenInfo.new(scopes: ["offline"], expires_at: NOW + 86_400, client_id: CIMD))

        made = requests.size
        expect(client.connect).to eq(info)
        expect(requests.size).to eq(made)

        clock.advance(86_400 - 30)
        stub_refresh("expires_in" => 600)
        expect(client.connect.expires_at).to eq(clock.now + 600)
        expect(token_requests("refresh_token").size).to eq(1)

        store.delete("issuers", [RESOURCE, "default"])
        expect(client.connect.expires_at).to eq(clock.now + 600)
        expect(store.read("issuers", [RESOURCE, "default"])).to eq(ISSUER)
      end

      it "C94: connect refreshes a token that is due when it finds it without a pointer", :aggregate_failures do
        sign_in(client)
        store.delete("issuers", [RESOURCE, "default"])
        clock.advance(86_400 + 10)
        stub_refresh("expires_in" => 600)

        expect(client.connect.expires_at).to eq(clock.now + 600)
        expect(token_requests("refresh_token").size).to eq(1)
        expect(store.read("issuers", [RESOURCE, "default"])).to eq(ISSUER)
      end

      it "C94: connect asks to sign in when the token has expired and cannot be refreshed, with or without a pointer", :aggregate_failures do
        stub_token(token_response("refresh_token" => nil, "expires_in" => 600))

        [true, false].each do |pointer|
          fresh = KindeSdk::AgentClient::MemoryStore.new
          agent = cimd_client(storage: fresh)
          sign_in(agent)
          forget_pointer = -> { fresh.delete("issuers", [RESOURCE, "default"]) unless pointer }

          # Close to its expiry but still good: it is reported, as nothing can refresh it.
          clock.advance(590)
          forget_pointer.call
          expect(agent.connect.expires_at).to eq(clock.now + 10)

          clock.advance(10)
          forget_pointer.call
          error = sign_in_needed { agent.connect }
          expect(error.authorization_url).to start_with("#{AUTHORIZE}?")
          expect(stored_tokens(fresh)).to be_nil
          expect(agent.token_info).to be_nil
        end
        expect(token_requests("refresh_token")).to be_empty
        expect(resource_requests).to be_empty
      end

      it "C73: has no browser hook, loopback listener or Rails route", :aggregate_failures do
        expect(client).not_to respond_to(:open_browser)
        expect(client.config).not_to respond_to(:open_browser)
        expect { described_class.new(resource_url: RESOURCE, redirect_uri: REDIRECT, open_browser: -> {}) }
          .to raise_error(ArgumentError, /open_browser/)

        root = File.expand_path("..", __dir__)
        code = Dir.glob(File.join(root, "lib/kinde_sdk/agent_client{.rb,/*.rb}")).map { |file| File.read(file) }.join
        expect(code).not_to match(/TCPServer|WEBrick|Launchy|xdg-open/)
        expect(File.read(File.join(root, "config/routes.rb"))).not_to match(/agent/i)
      end
    end

    describe "#token_info" do
      it "C74: returns scopes, expiry and client ID, never a token, and calls nothing", :aggregate_failures do
        expect(client.token_info).to be_nil
        expect(requests).to be_empty

        stub_token(token_response("scope" => "offline profile"))
        sign_in(client)
        made = requests.size
        info = client.token_info

        expect(info.members).to eq(%i[scopes expires_at client_id])
        expect(info.scopes).to eq(%w[offline profile])
        expect(info.expires_at).to eq(NOW + 86_400)
        expect(info.client_id).to eq(CIMD)
        [info.inspect, info.to_h.inspect, info.to_a.inspect, client.inspect].each do |text|
          expect(text).not_to match(/#{ACCESS}|#{REFRESH}/)
        end
        expect(client.inspect).to include("signed_in=true")
        expect(requests.size).to eq(made)
      end
    end

    describe "URL safety" do
      it "C75: accepts https and http on the three loopback hosts, and refuses everything else", :aggregate_failures do
        ["http://localhost:3001/mcp", "http://127.0.0.1:3001/mcp", "http://[::1]:3001/mcp", "http://LOCALHOST/mcp", "https://10.0.0.1/mcp"].each do |url|
          expect(build_client(resource_url: url).config.resource_url).to eq(url)
          expect(build_client(redirect_uri: url).config.redirect_uri).to eq(url)
        end

        [
          "http://example.com/mcp", "http://127.0.0.2/mcp", "http://foo.localhost/mcp", "http://localhost.example.com/mcp",
          "http://[::2]/mcp", "http://0.0.0.0/mcp", "ftp://localhost/mcp", "ws://localhost/mcp", "myapp://callback",
          "localhost:3001/mcp", "/mcp", "https://", "http://127.0.0.1.example.com/mcp", "https://api.example.com/mcp#frag"
        ].each do |url|
          expect { build_client(resource_url: url) }.to raise_error(ArgumentError, /resource_url/), "resource_url #{url}"
          expect { build_client(redirect_uri: url) }.to raise_error(ArgumentError, /redirect_uri/), "redirect_uri #{url}"
        end

        ["https://user:pw@api.example.com/mcp", "https://user@api.example.com/mcp"].each do |url|
          expect { build_client(resource_url: url) }.to raise_error(ArgumentError, "resource_url must not contain userinfo")
        end
        expect(build_client(resource_url: "#{RESOURCE}?tenant=1").config.resource_url).to eq("#{RESOURCE}?tenant=1")
      end

      it "C76: refuses an insecure URL in a challenge or a metadata document, and never requests it", :aggregate_failures do
        stub_prm({ "resource" => RESOURCE, "authorization_servers" => ["http://auth.example.org/tenant"] })
        expect { client.authorization_url }.to raise_error(discovery_error, %r{authorization server http://auth\.example\.org/tenant is refused})

        stub_prm
        stub_resource(challenge_metadata: "http://api.example.com/.well-known/oauth-protected-resource/mcp?secret=1")
        expect { client.fetch }.to raise_error(discovery_error) do |failure|
          expect(failure.message).to include("resource_metadata URL http://api.example.com/.well-known/oauth-protected-resource/mcp is refused")
          expect(failure.message).not_to include("secret=1")
        end

        {
          "token_endpoint" => "http://yourbiz.kinde.com/token", "authorization_endpoint" => "http://yourbiz.kinde.com/authorize",
          "registration_endpoint" => "http://yourbiz.kinde.com/register"
        }.each do |name, url|
          KindeSdk::AgentClient::Discovery.reset_cache!
          stub_metadata(server_metadata(name => url, "client_id_metadata_document_supported" => nil))
          expect { build_client.authorization_url }.to raise_error(discovery_error, /#{name}.*is refused/), name
        end

        KindeSdk::AgentClient::Discovery.reset_cache!
        stub_metadata(server_metadata("revocation_endpoint" => "http://yourbiz.kinde.com/revoke"))
        sign_in(client)
        expect(client.disconnect).to be(true)
        expect(logs.size).to eq(1)

        expect(requests.map { |request| request.uri.scheme }.uniq).to eq(["https"])
        expect(requests.map { |request| request.uri.host }).not_to include("auth.example.org")
      end

      it "C76: refuses a token endpoint that became insecure in the stored sign-in attempt" do
        state = query_of(client.authorization_url)["state"]
        store.write("pending", [state], store.read("pending", [state]).merge("token_endpoint" => "http://yourbiz.kinde.com/token"))

        expect { client.handle_callback("code" => CODE, "state" => state) }.to raise_error(discovery_error, /is refused/)
      end

      it "C76: a remote resource cannot point the client at a loopback http URL", :aggregate_failures do
        loopback_urls = ["http://127.0.0.1:9200/internal", "http://localhost:8500/v1/register", "http://[::1]:9000/x"]

        # In the challenge of a 401.
        stub_resource(challenge_metadata: loopback_urls[0])
        expect { client.fetch }.to raise_error(discovery_error, %r{resource_metadata URL http://127\.0\.0\.1:9200/internal is refused})

        # As the authorization server the resource's metadata names.
        stub_prm({ "resource" => RESOURCE, "authorization_servers" => ["http://localhost:9000"] })
        expect { client.authorization_url }.to raise_error(discovery_error, %r{authorization server http://localhost:9000 is refused})

        # As an endpoint in the authorization server's metadata.
        stub_prm
        {
          "authorization_endpoint" => loopback_urls[2], "token_endpoint" => loopback_urls[2],
          "registration_endpoint" => loopback_urls[1]
        }.each do |name, url|
          KindeSdk::AgentClient::Discovery.reset_cache!
          stub_metadata(server_metadata(name => url, "client_id_metadata_document_supported" => nil))
          expect { build_client.authorization_url }.to raise_error(discovery_error, /#{name}.*is refused/), name
        end

        # A loopback revocation endpoint is not called either; disconnect still succeeds.
        KindeSdk::AgentClient::Discovery.reset_cache!
        stub_metadata(server_metadata("revocation_endpoint" => loopback_urls[2]))
        sign_in(client)
        expect(client.disconnect).to be(true)

        expect(requests.map { |request| request.uri.scheme }.uniq).to eq(["https"])
        expect(client.config.loopback_resource?).to be(false)
      end

      it "C76: metadata cached by a client for a loopback resource does not open loopback URLs to a remote one", :aggregate_failures do
        issuer = "http://127.0.0.1:9000"
        local_resource = "http://localhost:3001/mcp"
        local_prm = "http://localhost:3001/.well-known/oauth-protected-resource/mcp"
        stub_prm({ "resource" => local_resource, "authorization_servers" => [issuer] }, url: local_prm)
        stub_metadata(
          server_metadata(
            "issuer" => issuer, "authorization_endpoint" => "#{issuer}/authorize", "token_endpoint" => "#{issuer}/token",
            "registration_endpoint" => "#{issuer}/register", "client_id_metadata_document_supported" => nil
          ),
          url: "#{issuer}/.well-known/oauth-authorization-server"
        )
        stub_register(url: "#{issuer}/register")
        local = build_client(resource_url: local_resource, redirect_uri: "http://localhost:4000/callback")
        expect(local.config.loopback_resource?).to be(true)
        expect(local.authorization_url).to start_with("#{issuer}/authorize?")
        registrations = requests(:post, "#{issuer}/register").size

        # The same process, a remote resource that names the cached loopback issuer.
        stub_prm({ "resource" => RESOURCE, "authorization_servers" => [issuer] })
        expect { build_client.authorization_url }.to raise_error(discovery_error, %r{authorization server http://127\.0\.0\.1:9000 is refused})
        expect(requests(:post, "#{issuer}/register").size).to eq(registrations)
      end

      context "when a client for a loopback resource cached loopback endpoints for an https issuer" do
        let(:loopback_authorize) { "http://127.0.0.1:9000/authorize" }
        let(:loopback_token) { "http://127.0.0.1:9000/token" }

        # The metadata cache is shared by the process and a cache hit is not
        # validated again, so only the check where an endpoint is used is left.
        def cache_for_loopback_resource(endpoints)
          KindeSdk::AgentClient::Discovery.reset_cache!
          stub_prm({ "resource" => "http://localhost:3001/mcp", "authorization_servers" => [ISSUER] },
                   url: "http://localhost:3001/.well-known/oauth-protected-resource/mcp")
          stub_metadata(server_metadata(endpoints))
          local = cimd_client(resource_url: "http://localhost:3001/mcp", redirect_uri: "http://localhost:4000/callback")
          expect(local.config.loopback_resource?).to be(true)
          expect(local.authorization_url).to start_with("#{endpoints.fetch('authorization_endpoint', AUTHORIZE)}?")
        end

        it "C76: a client for a remote resource does not build a sign-in on a cached loopback endpoint", :aggregate_failures do
          { "authorization_endpoint" => loopback_authorize, "token_endpoint" => loopback_token }.each do |name, url|
            cache_for_loopback_resource(name => url)
            fetched = requests(:get, METADATA).size

            expect { client.authorization_url }.to raise_error(discovery_error, /#{name} #{Regexp.escape(url)} is refused/), name
            expect { client.fetch }.to raise_error(discovery_error, /#{name} #{Regexp.escape(url)} is refused/), name
            expect(requests(:get, METADATA).size).to eq(fetched), "#{name}: the document came from the cache"
          end

          expect(requests.map { |request| request.uri.host }).not_to include("127.0.0.1")
          expect(client.config.loopback_resource?).to be(false)
        end

        it "C76: a client for a remote resource does not refresh at a cached loopback token endpoint", :aggregate_failures do
          sign_in(client)
          clock.advance(86_400 - 60)
          cache_for_loopback_resource("token_endpoint" => loopback_token)

          expect { client.fetch }.to raise_error(discovery_error, /token_endpoint #{Regexp.escape(loopback_token)} is refused/)
          expect(requests.map { |request| request.uri.host }).not_to include("127.0.0.1")
          expect(stored_tokens(store)).to include("refresh_token" => REFRESH)
        end
      end

      it "C76: refuses a loopback http token endpoint in the stored sign-in attempt of a remote resource", :aggregate_failures do
        state = query_of(client.authorization_url)["state"]
        store.write("pending", [state], store.read("pending", [state]).merge("token_endpoint" => "http://127.0.0.1:9000/token"))

        expect { client.handle_callback("code" => CODE, "state" => state) }
          .to raise_error(discovery_error, %r{authorization server endpoint http://127\.0\.0\.1:9000/token is refused})
        expect(requests.map { |request| request.uri.host }).not_to include("127.0.0.1")
        expect(client.token_info).to be_nil
      end

      it "C77: runs a whole flow against http://localhost", :aggregate_failures do
        resource = "http://localhost:3001/mcp"
        issuer = "http://127.0.0.1:9000"
        prm = "http://localhost:3001/.well-known/oauth-protected-resource/mcp"
        stub_prm({ "resource" => resource, "authorization_servers" => [issuer] }, url: prm)
        stub_metadata(
          server_metadata(
            "issuer" => issuer, "authorization_endpoint" => "#{issuer}/authorize", "token_endpoint" => "#{issuer}/token",
            "registration_endpoint" => "#{issuer}/register", "revocation_endpoint" => "http://[::1]:9000/revoke",
            "client_id_metadata_document_supported" => nil
          ),
          url: "#{issuer}/.well-known/oauth-authorization-server"
        )
        stub_register(url: "#{issuer}/register")
        stub_token(url: "#{issuer}/token")
        stub_revoke(url: "http://[::1]:9000/revoke")
        stub_resource(url: resource, challenge_metadata: prm)
        local = build_client(resource_url: resource, redirect_uri: "http://localhost:4000/callback")

        error = sign_in_needed { local.fetch }
        expect(error.authorization_url).to start_with("#{issuer}/authorize?")
        local.handle_callback("code" => CODE, "state" => error.state)
        expect(local.fetch.status).to eq(200)
        expect(local.disconnect).to be(true)
        expect(requests(:post, "http://[::1]:9000/revoke").size).to eq(1)
      end

      it "C78: never follows a redirect, never turns TLS verification off, and uses a 5 second timeout for the authorization server", :aggregate_failures do
        calls = []
        %i[get post].each do |verb|
          allow(HTTParty).to receive(verb).and_wrap_original do |original, url, **options|
            calls << [verb, url, options]
            original.call(url, **options)
          end
        end

        sign_in(dcr_client)
        expire_access_token
        stub_refresh
        dcr_client.fetch(timeout: 12)
        dcr_client.disconnect

        expect(calls.map { |_, url, _| url }.uniq).to contain_exactly(PRM, METADATA, REGISTER, TOKEN, RESOURCE, REVOKE)
        calls.each do |_, url, options|
          expect(options[:follow_redirects]).to be(false), "#{url} follows redirects"
          expect(options).not_to have_key(:verify)
          expect(options).not_to have_key(:verify_peer)
          expect(options[:timeout]).to eq(url == RESOURCE ? 12 : 5)
        end

        stub_request(:get, PRM).to_return(status: 302, headers: { "Location" => "https://evil.example/prm" })
        stub_prm(url: PRM_ROOT)
        expect(cimd_client.authorization_url).to start_with(AUTHORIZE)
        stub_request(:post, TOKEN).to_return(status: 307, headers: { "Location" => "https://evil.example/token" })
        state = query_of(client.authorization_url)["state"]
        expect { client.handle_callback("code" => CODE, "state" => state) }.to raise_error(oauth_error)
        expect(requests.map { |request| request.uri.host }).not_to include("evil.example")
      end
    end

    describe "secrets" do
      it "C79: no log line, error message, inspect output or authorization URL holds a token, code, verifier or secret", :aggregate_failures do
        texts = []
        verifiers = []
        note = lambda do |&block|
          block.call
        rescue KindeSdk::Error, ArgumentError => e
          texts << e.message << e.inspect << e.full_message(highlight: false)
          texts << e.authorization_url if e.respond_to?(:authorization_url)
          e
        end
        remember_verifier = ->(state) { verifiers << store.read("pending", [state])["code_verifier"] }

        # Success path, with a registered client so a secret is in play.
        error = note.call { dcr_client.fetch }
        remember_verifier.call(error.state)
        texts << dcr_client.handle_callback("code" => CODE, "state" => error.state).inspect
        texts << dcr_client.inspect << dcr_client.config.inspect << store.inspect << dcr_client.token_info.inspect
        texts << dcr_client.fetch.inspect

        # Bad callbacks.
        note.call { dcr_client.handle_callback("code" => CODE, "state" => error.state) }
        url = dcr_client.authorization_url
        texts << url
        remember_verifier.call(query_of(url)["state"])
        note.call { dcr_client.handle_callback("code" => CODE, "state" => query_of(url)["state"], "iss" => "https://evil.example") }
        note.call { dcr_client.handle_callback("state" => query_of(url)["state"], "error" => "access_denied") }

        # A refused code.
        stub_token_error("invalid_grant")
        url = dcr_client.authorization_url
        remember_verifier.call(query_of(url)["state"])
        note.call { dcr_client.handle_callback("code" => CODE, "state" => query_of(url)["state"]) }

        # A failed refresh, a failed revocation, a refused registration, a failed discovery.
        expire_access_token
        stub_token({ "error" => "server_error" }, status: 500)
        note.call { dcr_client.fetch }
        stub_token_error("invalid_grant")
        again = note.call { dcr_client.fetch }
        remember_verifier.call(again.state)
        stub_token
        dcr_client.handle_callback("code" => CODE, "state" => again.state)
        stub_revoke(status: 503)
        dcr_client.disconnect(forget: true)
        stub_register({ "error" => "invalid_redirect_uri", "error_description" => "Host not trusted" }, status: 400)
        note.call { dcr_client.authorization_url }
        stub_prm({ "resource" => "https://other.example.com/mcp", "authorization_servers" => [ISSUER] })
        note.call { dcr_client.fetch }
        stub_request(:get, PRM).to_timeout
        note.call { dcr_client.connect }
        note.call { dcr_client.fetch("https://evil.example/?token=#{ACCESS}") }

        expect(logs.size).to be >= 2
        expect(texts.size).to be >= 20
        expect(verifiers.uniq.size).to eq(4)
        secrets = [ACCESS, NEW_ACCESS, REFRESH, CODE, DCR_SECRET, *verifiers]
        (texts + logs.map(&:last)).each do |text|
          secrets.each { |secret| expect(text.to_s).not_to include(secret), "#{text.to_s[0, 120]}... holds #{secret}" }
        end
      end

      it "C80: no request URL holds a token, a secret or a verifier", :aggregate_failures do
        url = dcr_client.authorization_url
        verifier = store.read("pending", [query_of(url)["state"]])["code_verifier"]
        dcr_client.handle_callback("code" => CODE, "state" => query_of(url)["state"])
        dcr_client.fetch("?page=1")
        expire_access_token
        stub_refresh("refresh_token" => NEW_REFRESH)
        dcr_client.fetch
        dcr_client.disconnect

        expect(requests.size).to be >= 8
        (requests.map { |request| request.uri.to_s } + [url]).each do |requested|
          [ACCESS, NEW_ACCESS, REFRESH, NEW_REFRESH, DCR_SECRET, verifier, CODE].each do |secret|
            expect(requested).not_to include(secret)
          end
        end
      end
    end

    describe "a server that is not Kinde" do
      it "C81: works with an issuer without a path, OIDC discovery, client_secret_basic and no revocation endpoint", :aggregate_failures do
        resource = "https://mcp.example.org/api"
        issuer = "https://auth.example.org"
        prm = "https://mcp.example.org/.well-known/oauth-protected-resource/api"
        stub_prm({ "resource" => resource, "authorization_servers" => [issuer] }, url: prm)
        stub_metadata({}, url: "#{issuer}/.well-known/oauth-authorization-server", status: 404)
        stub_metadata(
          {
            "issuer" => issuer, "authorization_endpoint" => "#{issuer}/protocol/auth", "token_endpoint" => "#{issuer}/protocol/token",
            "token_endpoint_auth_methods_supported" => ["client_secret_basic"], "code_challenge_methods_supported" => %w[plain S256],
            "scopes_supported" => %w[openid offline_access]
          },
          url: "#{issuer}/.well-known/openid-configuration"
        )
        stub_token(token_response("id_token" => "ignored"), url: "#{issuer}/protocol/token")
        accepted = [ACCESS]
        stub_resource(url: resource, challenge_metadata: prm, valid: accepted)
        agent = build_client(
          resource_url: resource, client_id: "my-agent", client_secret: "configured-secret-value",
          issuer: issuer, scopes: %w[openid offline_access], storage: store
        )
        basic = "Basic #{Base64.strict_encode64('my-agent:configured-secret-value')}"

        error = sign_in_needed { agent.connect }
        expect(error.authorization_url).to start_with("#{issuer}/protocol/auth?")
        expect(query_of(error.authorization_url)).to include("scope" => "openid offline_access", "client_id" => "my-agent", "resource" => resource)
        expect(agent.handle_callback("code" => CODE, "state" => error.state, "iss" => issuer).client_id).to eq("my-agent")
        expect(agent.connect.scopes).to eq(["offline"])
        expect(agent.fetch.status).to eq(200)

        accepted.replace([NEW_ACCESS])
        stub_token(token_response("access_token" => NEW_ACCESS), url: "#{issuer}/protocol/token")
        expect(agent.fetch.status).to eq(200)
        expect(agent.disconnect).to be(true)
        expect(agent.token_info).to be_nil

        sent = token_requests(url: "#{issuer}/protocol/token")
        expect(sent.map { |request| form_of(request)["grant_type"] }).to eq(%w[authorization_code refresh_token])
        sent.each do |request|
          expect(request.headers["Authorization"]).to eq(basic)
          expect(form_of(request)).not_to have_key("client_secret")
        end
        expect(requests.map { |request| request.uri.host }.uniq).to contain_exactly("mcp.example.org", "auth.example.org")
        expect(requests(:post).map { |request| request_url(request) }.uniq).to eq(["#{issuer}/protocol/token"])
      end
    end

    describe "existing behaviour" do
      it "C82: leaves the login configuration and the login URL as they were", :aggregate_failures do
        expect(KindeSdk::Configuration.new.scope).to eq("openid offline email profile")

        previous = KindeSdk.config
        begin
          KindeSdk.config = KindeSdk::Configuration.new do |c|
            c.domain = "https://login.kinde.com"
            c.client_id = "login_client_id"
            c.client_secret = "login_client_secret"
            c.callback_url = "http://localhost:3000/callback"
          end
          client.authorization_url
          login = KindeSdk.auth_url

          expect(login.keys).to eq(%i[url code_verifier])
          expect(login[:url]).to start_with("https://login.kinde.com/oauth2/auth?")
          expect(query_of(login[:url])).to include("scope" => "openid offline email profile", "client_id" => "login_client_id")
          expect(query_of(login[:url])).not_to have_key("resource")
        ensure
          KindeSdk.config = previous
        end

        expect(KindeSdk::AgentAuth.instance_method(:initialize).parameters.map(&:last)).to include(:verification)
        expect(KindeSdk::AgentAuth::UnavailableError.ancestors).not_to include(KindeSdk::AgentClient::Error)
      end
    end

    describe "documentation" do
      after { Object.send(:remove_const, :AgentController) if Object.const_defined?(:AgentController) }

      it "C84: the agent example from the README signs in through the callback and then calls the resource", :aggregate_failures do
        stub_request(:any, "#{RESOURCE}/documents").to_return do |request|
          if bearer_of(request) == ACCESS
            { status: 200, body: "your documents" }
          else
            { status: 401, headers: { "WWW-Authenticate" => %(Bearer resource_metadata="#{PRM}") } }
          end
        end
        allow(ENV).to receive(:fetch).and_call_original
        allow(ENV).to receive(:fetch).with("AGENT_RESOURCE_URL").and_return(RESOURCE)
        base = Class.new do
          attr_reader :session, :request, :answer

          def initialize(session, query = {})
            @session = session
            @request = Struct.new(:query_parameters).new(query)
          end

          def redirect_to(target, **options)
            @answer = [:redirect, target, options]
          end

          def render(**options)
            @answer = [:render, options]
          end

          def agent_path = "/agent"
          def root_path = "/"
          def agent_callback_url = AgentClientHelpers::REDIRECT
        end
        stub_const("ApplicationController", base)
        eval(readme_ruby_example(/class AgentController/), TOPLEVEL_BINDING, "README.md") # rubocop:disable Security/Eval
        session = {}

        first = AgentController.new(session)
        first.show
        kind, target, options = first.answer
        expect(kind).to eq(:redirect)
        expect(target).to start_with("#{AUTHORIZE}?")
        expect(options).to eq(allow_other_host: true)
        expect(query_of(target)).to include("scope" => "offline", "redirect_uri" => REDIRECT)

        refused = AgentController.new(session, "code" => CODE, "state" => "made-up")
        refused.callback
        expect(refused.answer.first).to eq(:render)
        expect(refused.answer.last).to include(status: :bad_request)

        callback = AgentController.new(session, "code" => CODE, "state" => query_of(target)["state"])
        callback.callback
        expect(callback.answer).to eq([:redirect, "/agent", {}])

        second = AgentController.new(session)
        second.show
        expect(second.answer).to eq([:render, { plain: "your documents", status: 200 }])

        last = AgentController.new(session)
        last.disconnect
        expect(last.answer).to eq([:redirect, "/", {}])
        expect(requests(:post, REVOKE).size).to eq(1)
        expect(session["kinde_agent_client"]["tokens"]).to be_empty
      end

      it "C84: the storage example from the README works as a store", :aggregate_failures do
        redis = Class.new do
          attr_reader :expiries

          def initialize
            @data = {}
            @expiries = {}
          end

          def get(key) = @data[key]
          def getdel(key) = @data.delete(key)

          def set(key, value, ex: nil)
            @expiries[key[/\Akinde_agent:(\w+):/, 1]] = ex
            @data[key] = value
          end
        end.new
        eval(readme_ruby_example(/class RedisAgentStore/), TOPLEVEL_BINDING, "README.md") # rubocop:disable Security/Eval
        agent = cimd_client(storage: RedisAgentStore.new(redis))

        sign_in(agent)
        expect(agent.fetch.status).to eq(200)
        expect(agent.disconnect).to be(true)
        expect(agent.token_info).to be_nil

        # Sign-in attempts expire by themselves, those of the MCP adapter too; nothing else does.
        agent.config.storage.write("mcp_pending", ["k"], { "created_at" => NOW })
        expect(redis.expiries).to eq("pending" => 600, "mcp_pending" => 600, "tokens" => nil, "issuers" => nil)
      ensure
        Object.send(:remove_const, :RedisAgentStore) if Object.const_defined?(:RedisAgentStore)
      end

      it "C84: the README says what a developer has to know", :aggregate_failures do
        readme = File.read(AgentAuthHelpers::README_PATH)
        section = readme[/^### 9\. Build an agent that signs in.*?^## Publishing/m]

        expect(section).to include("Trusted agent hosts").and include("Claude and ChatGPT are trusted already")
        expect(section).to match(/reachable from the public internet/).and match(/`localhost` cannot work/)
        expect(section).to match(/kept on the server.*or be encrypted/m).and match(/Never keep it in a plain, unencrypted cookie/)
        expect(section).to include('require "kinde_sdk/agent_client/mcp"').and include("KindeOAuthProvider")
        expect(section).to include("build_client_metadata_document").and include("client_metadata_app")
        expect(readme).to include("`KindeSdk::AgentClient` is the agent side")
        expect(section).to match(/revocation is best effort.*`true` does not confirm that the server revoked anything/m)
        expect(section).to match(/when that lookup fails the registration stays stored/)
        expect(section).to match(/built-in stores drop old attempts on the next write.*removes it without another write/m)
        expect(section).to match(/give it a `lock_scope` method/)
      end

      it "C85: every public method of the new files has a YARD comment with a tag", :aggregate_failures do
        files = Dir.glob(File.expand_path("../lib/kinde_sdk/agent_client{.rb,/*.rb}", __dir__))
        expect(files.size).to eq(12)
        checked = 0

        files.each do |file|
          lines = File.readlines(file)
          hidden = false
          lines.each_with_index do |line, index|
            hidden = false if line.match?(/^\s*(class|module)\b/)
            hidden = true if line.match?(/^\s*private\s*$/)
            next unless !hidden && line.match?(/^\s*def\s/)

            comment = []
            cursor = index - 1
            while cursor >= 0 && lines[cursor].strip.start_with?("#")
              comment << lines[cursor]
              cursor -= 1
            end
            checked += 1
            expect(comment.join).to match(/@(param|return|raise|example|yield|api)/),
                                    "#{File.basename(file)}:#{index + 1} #{line.strip} has no YARD comment"
          end
        end
        expect(checked).to be >= 50
      end
    end
  end
end
