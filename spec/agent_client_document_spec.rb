require 'spec_helper'
require 'rack'
require_relative 'support/agent_client_helpers'

# The parts of the agent client that need no authorization server: the
# WWW-Authenticate parser, the client ID metadata document and its Rack app,
# and the stores. Case ids (D1-D14) are the ones in the approved plan.
module AgentClientHelpers # so the constants of the helpers are in scope below
  RSpec.describe KindeSdk::AgentClient::WwwAuthenticate do
    it "D1: reads the Bearer challenge next to another one, with commas and escaped quotes inside quoted values", :aggregate_failures do
      header = 'Basic realm="a, b", Bearer error="invalid_token", error_description="say \"hi\", ok", ' \
               'resource_metadata="https://rs.example/.well-known/x"'

      expect(described_class.bearer(header)).to eq(
        "error" => "invalid_token",
        "error_description" => 'say "hi", ok',
        "resource_metadata" => "https://rs.example/.well-known/x"
      )
      expect(described_class.parse(header).map { |challenge| challenge[:scheme] }).to eq(%w[basic bearer])
      expect(described_class.parse(header).first[:params]).to eq("realm" => "a, b")
      expect(described_class.bearer('Bearer scope="offline profile", error="insufficient_scope"'))
        .to eq("scope" => "offline profile", "error" => "insufficient_scope")
      expect(described_class.bearer('Bearer realm="back\\\\slash"')).to eq("realm" => "back\\slash")
    end

    it "D2: reads several header values, any case of scheme and parameter names, unquoted values and a token68 challenge", :aggregate_failures do
      values = ["Negotiate YWJjZA==", "Basic realm=simple , bEaReR RESOURCE_METADATA=https://rs.example/prm, Error = invalid_token"]

      expect(described_class.parse(values)).to eq(
        [
          { scheme: "negotiate", params: {}, token68: "YWJjZA==" },
          { scheme: "basic", params: { "realm" => "simple" }, token68: nil },
          { scheme: "bearer", params: { "resource_metadata" => "https://rs.example/prm", "error" => "invalid_token" }, token68: nil }
        ]
      )
      expect(described_class.bearer(values)["resource_metadata"]).to eq("https://rs.example/prm")
      expect(described_class.bearer("Negotiate abc==, Bearer")).to eq({})
      expect(described_class.bearer('Bearer a="1", Bearer a="2"')).to eq("a" => "1")
    end

    it "D3: returns nothing for garbage, empty and invalid-byte input, and never raises", :aggregate_failures do
      [nil, "", "   ", ",,,", "====", '"unterminated', "\xFF\xFE", [], [nil, ""], 42].each do |input|
        expect(described_class.bearer(input)).to be_nil, "expected no Bearer challenge in #{input.inspect}"
      end
      expect(described_class.parse(nil)).to eq([])
      expect(described_class.parse("")).to eq([])
      expect(described_class.parse(",, ,")).to eq([])

      expect { described_class.parse("Bearer \xFF=\"\xFE") }.not_to raise_error
      expect { described_class.parse("Bearer realm=\"never closed, x=y") }.not_to raise_error
      expect(described_class.bearer("Bearer realm=\"never closed")).to eq("realm" => "never closed")
      expect(described_class.bearer("\xFF, Bearer scope=\"offline\"")).to eq("scope" => "offline")
    end
  end

  RSpec.describe KindeSdk::AgentClient, "client ID metadata document" do
    include AgentClientHelpers

    let(:options) do
      { client_id: CIMD, client_name: "Example Agent", redirect_uris: ["https://agent.example.com/oauth/callback"] }
    end

    def build(overrides = {})
      described_class.build_client_metadata_document(**options.merge(overrides))
    end

    it "D4: builds the document of the feature file, leaves optional members out, and has a camelCase twin", :aggregate_failures do
      document = build(
        client_uri: "https://agent.example.com",
        logo_uri: "https://agent.example.com/logo.png",
        redirect_uris: ["https://agent.example.com/oauth/callback", "http://127.0.0.1/callback"]
      )

      expect(document).to eq(
        "client_id" => "https://agent.example.com/oauth/client-metadata.json",
        "client_name" => "Example Agent",
        "client_uri" => "https://agent.example.com",
        "logo_uri" => "https://agent.example.com/logo.png",
        "redirect_uris" => ["https://agent.example.com/oauth/callback", "http://127.0.0.1/callback"],
        "grant_types" => %w[authorization_code refresh_token],
        "response_types" => ["code"],
        "token_endpoint_auth_method" => "none"
      )
      expect(document.keys).to eq(
        %w[client_id client_name client_uri logo_uri redirect_uris grant_types response_types token_endpoint_auth_method]
      )
      expect(build.keys).to eq(%w[client_id client_name redirect_uris grant_types response_types token_endpoint_auth_method])
      expect(described_class.method(:buildClientMetadataDocument)).to eq(described_class.method(:build_client_metadata_document))
      expect(described_class.buildClientMetadataDocument(**options)).to eq(build)
    end

    it "D5: raises an ArgumentError that names the value for every refused document", :aggregate_failures do
      {
        { client_id: "http://agent.example.com/oauth/client-metadata.json" } => /client_id.*https/,
        { client_id: "https://agent.example.com" } => /client_id.*path/,
        { client_id: "https://agent.example.com/" } => /client_id.*path/,
        { client_id: "https://user@agent.example.com/doc.json" } => /client_id.*userinfo/,
        { client_id: "https://agent.example.com/doc.json?v=1" } => /client_id.*query/,
        { client_id: "https://agent.example.com/doc.json#top" } => /client_id.*fragment/,
        { client_id: nil } => /client_id/,
        { client_name: "" } => /client_name/,
        { client_name: "  " } => /client_name/,
        { redirect_uris: [] } => /redirect_uris/,
        { redirect_uris: nil } => /redirect_uris/,
        { redirect_uris: ["https://agent.example.com/cb#frag"] } => %r{agent\.example\.com/cb#frag.*fragment},
        { redirect_uris: ["https://user@agent.example.com/cb"] } => /user@agent\.example\.com.*userinfo/,
        { redirect_uris: ["https://other.example.com/cb"] } => /other\.example\.com.*Kinde drops/,
        { redirect_uris: ["myapp://cb"] } => %r{myapp://cb.*custom schemes},
        { redirect_uris: ["http://example.com/cb"] } => %r{http://example\.com/cb},
        { redirect_uris: ["http://agent.example.com/cb"] } => %r{http://agent\.example\.com/cb},
        { redirect_uris: ["https://localhost/cb"] } => %r{https://localhost/cb},
        { redirect_uris: ["http://127.0.0.2/cb"] } => /127\.0\.0\.2/,
        { redirect_uris: ["https://agent.example.com/cb", "not a url"] } => /not a url/
      }.each do |overrides, message|
        expect { build(overrides) }.to raise_error(ArgumentError, message), "expected #{overrides.inspect} to be refused"
      end
    end

    it "D6: accepts https on the host of client_id in any case, and http on the three loopback hosts with any port" do
      accepted = [
        "https://AGENT.Example.com/oauth/callback", "http://localhost:3000/cb",
        "http://127.0.0.1/cb", "http://[::1]:8080/cb"
      ]

      expect(build(redirect_uris: accepted)["redirect_uris"]).to eq(accepted)
    end

    describe "Rack app" do
      let(:app) { described_class.client_metadata_app(**options) }
      let(:request) { Rack::MockRequest.new(app) }

      it "D7: answers GET with the document, both headers and no redirect", :aggregate_failures do
        response = request.get("/oauth/client-metadata.json")

        expect(app).to be_a(KindeSdk::AgentClient::ClientMetadataApp)
        expect(response.status).to eq(200)
        expect(response.headers["content-type"]).to eq("application/json")
        expect(response.headers["cache-control"]).to eq("public, max-age=3600")
        expect(response.headers).not_to have_key("location")
        expect(JSON.parse(response.body)).to eq(build)
      end

      it "D8: answers HEAD with 200 and any other method with 405, and never checks the request path", :aggregate_failures do
        head = request.head("/oauth/client-metadata.json")
        expect(head.status).to eq(200)
        expect(head.body).to eq("")
        expect(head.headers["content-type"]).to eq("application/json")

        %i[post put patch delete options].each do |verb|
          refused = request.public_send(verb, "/oauth/client-metadata.json")
          expect(refused.status).to eq(405), "expected #{verb} to be refused"
          expect(refused.headers["allow"]).to eq("GET, HEAD")
          expect(refused.headers).not_to have_key("location")
        end

        expect(request.get("/somewhere/else").status).to eq(200)
      end

      it "D9: refuses at construction a document of 64 KiB or more, and one that fails validation", :aggregate_failures do
        expect { described_class.client_metadata_app(**options.merge(client_name: "a" * 65_536)) }
          .to raise_error(ArgumentError, /65536/)
        expect { described_class.client_metadata_app(**options.merge(client_name: "a" * 60_000)) }.not_to raise_error
        expect { described_class.client_metadata_app(**options.merge(redirect_uris: ["myapp://cb"])) }
          .to raise_error(ArgumentError, /custom schemes/)

        padding = 65_536 - JSON.generate(build(client_name: "x")).bytesize + 1
        expect(JSON.generate(build(client_name: "x" * padding)).bytesize).to eq(65_536)
        expect { described_class.client_metadata_app(**options.merge(client_name: "x" * padding)) }.to raise_error(ArgumentError)
        expect { described_class.client_metadata_app(**options.merge(client_name: "x" * (padding - 1))) }.not_to raise_error
      end

      it "D10: serves a client_id that equals the configured URL byte for byte" do
        client_id = "https://Agent.Example.com/OAuth/client-metadata.json"
        body = Rack::MockRequest.new(described_class.client_metadata_app(**options.merge(client_id: client_id))).get("/").body

        expect(JSON.parse(body)["client_id"]).to eq(client_id)
      end

      it "D14: the config.ru example from the README serves the document", :aggregate_failures do
        example = Rack::Builder.new_from_string(readme_ruby_example(/^map "\/oauth\/client-metadata\.json"/), "README.md")
        response = Rack::MockRequest.new(example).get("/oauth/client-metadata.json")

        expect(response.status).to eq(200)
        expect(response.headers["content-type"]).to eq("application/json")
        expect(JSON.parse(response.body)).to include(
          "client_id" => "https://agent.example.com/oauth/client-metadata.json",
          "client_name" => "Example Agent",
          "redirect_uris" => ["https://agent.example.com/oauth/callback"],
          "token_endpoint_auth_method" => "none"
        )
        expect(Rack::MockRequest.new(example).get("/elsewhere").status).to eq(404)
      end
    end
  end

  RSpec.describe KindeSdk::AgentClient, "storage" do
    include AgentClientHelpers

    let(:clock) { AgentAuthHelpers::FakeClock.new(NOW) }

    before do
      freeze_clock(clock)
      KindeSdk::AgentClient::Discovery.reset_cache!
    end

    shared_examples "a store" do
      it "D11: reads, writes and deletes; delete returns the value once; namespaces and keys do not collide", :aggregate_failures do
        expect(store.read("tokens", %w[a b])).to be_nil
        expect(store.delete("tokens", %w[a b])).to be_nil

        expect(store.write("tokens", %w[a b], { "access_token" => "one" })).to eq("access_token" => "one")
        store.write("tokens", %w[a c], { "access_token" => "two" })
        store.write("tokens", ["a", "b,c"], { "access_token" => "three" })
        store.write("tokens", ["a,b", "c"], { "access_token" => "four" })
        store.write("registrations", %w[a b], { "client_id" => "five" })
        store.write("issuers", %w[a b], "https://issuer.example")

        expect(store.read("tokens", %w[a b])).to eq("access_token" => "one")
        expect(store.read("tokens", %w[a c])).to eq("access_token" => "two")
        expect(store.read("tokens", ["a", "b,c"])).to eq("access_token" => "three")
        expect(store.read("tokens", ["a,b", "c"])).to eq("access_token" => "four")
        expect(store.read("registrations", %w[a b])).to eq("client_id" => "five")
        expect(store.read("issuers", %w[a b])).to eq("https://issuer.example")

        store.write("tokens", %w[a b], { "access_token" => "replaced" })
        expect(store.read("tokens", %w[a b])).to eq("access_token" => "replaced")

        expect(store.delete("tokens", %w[a b])).to eq("access_token" => "replaced")
        expect(store.delete("tokens", %w[a b])).to be_nil
        expect(store.read("tokens", %w[a b])).to be_nil
        expect(store.read("tokens", %w[a c])).to eq("access_token" => "two")
        expect(store.read("registrations", %w[a b])).to eq("client_id" => "five")
      end

      it "D11: drops sign-in attempts older than ten minutes at the next write, and nothing else", :aggregate_failures do
        store.write("pending", ["old"], { "code_verifier" => "v1", "created_at" => NOW })
        store.write("mcp_pending", ["old"], { "code_verifier" => "v2", "created_at" => NOW })
        store.write("tokens", ["old"], { "access_token" => "t", "created_at" => NOW })

        clock.advance(600)
        store.write("pending", ["fresh"], { "code_verifier" => "v3", "created_at" => clock.now })
        expect(store.read("pending", ["old"])).not_to be_nil

        clock.advance(1)
        store.write("issuers", ["x"], "y")
        expect(store.read("pending", ["old"])).to be_nil
        expect(store.read("mcp_pending", ["old"])).to be_nil
        expect(store.read("pending", ["fresh"])).not_to be_nil
        expect(store.read("tokens", ["old"])).not_to be_nil
      end

      it "D11: shows no stored value when inspected" do
        store.write("tokens", %w[a b], { "access_token" => ACCESS, "refresh_token" => REFRESH })
        store.write("pending", ["state-value"], { "code_verifier" => "verifier-value", "created_at" => NOW })
        store.write("registrations", %w[a b], { "client_secret" => DCR_SECRET })

        expect(store.inspect).not_to match(/#{ACCESS}|#{REFRESH}|verifier-value|state-value|#{DCR_SECRET}/)
        expect(store.inspect).to include("tokens=1")
      end
    end

    describe KindeSdk::AgentClient::MemoryStore do
      let(:store) { described_class.new }

      it_behaves_like "a store"

      it "D11: keeps two stores apart" do
        store.write("tokens", ["a"], { "access_token" => "one" })

        expect(described_class.new.read("tokens", ["a"])).to be_nil
      end
    end

    describe KindeSdk::AgentClient::SessionStore do
      let(:session) { {} }
      let(:store) { described_class.new(session) }

      it_behaves_like "a store"

      it "D12: keeps everything under its one session key, as values that survive JSON, and assigns the key on every change", :aggregate_failures do
        assignments = []
        recording = Class.new do
          define_method(:initialize) { @data = {} }
          define_method(:[]) { |key| @data[key] }
          define_method(:[]=) do |key, value|
            assignments << key
            @data[key] = value
          end
          define_method(:to_h) { @data }
        end.new
        recorded = described_class.new(recording, key: "my_agent")

        recorded.write("tokens", [ISSUER, RESOURCE, "default"], { "access_token" => ACCESS, "expires_at" => NOW })
        recorded.write("pending", ["s"], { "code_verifier" => "v", "created_at" => NOW })
        recorded.delete("pending", ["s"])
        recorded.delete("pending", ["s"])

        expect(assignments).to eq(%w[my_agent my_agent my_agent])
        expect(recording.to_h.keys).to eq(["my_agent"])
        expect(JSON.parse(JSON.generate(recording.to_h))).to eq(recording.to_h)
        expect(recording.to_h["my_agent"]["tokens"].values).to eq([{ "access_token" => ACCESS, "expires_at" => NOW }])

        store.write("tokens", ["a"], { "access_token" => "one" })
        expect(session.keys).to eq(["kinde_agent_client"])
        expect(described_class.new(session).read("tokens", ["a"])).to eq("access_token" => "one")
        expect(described_class.new(session, key: "other").read("tokens", ["a"])).to be_nil
        expect { described_class.new(nil) }.to raise_error(ArgumentError, /session/)
      end

      it "D13: carries a whole sign-in, a call and a disconnect, under the three key shapes", :aggregate_failures do
        stub_kinde
        client = build_client(storage: store)

        url = client.authorization_url
        state = query_of(url)["state"]
        expect(store.read("pending", [state])).to include("code_verifier" => match(/\A[A-Za-z0-9\-._~]{43,128}\z/))

        # A second process: only the session is shared.
        later = build_client(storage: described_class.new(JSON.parse(JSON.generate(session))))
        later.handle_callback("code" => CODE, "state" => state)
        later_store = later.config.storage

        expect(later_store.read("pending", [state])).to be_nil
        expect(later_store.read("tokens", [ISSUER, RESOURCE, "default"])).to include("access_token" => ACCESS, "refresh_token" => REFRESH)
        expect(later_store.read("registrations", [ISSUER, REDIRECT])).to include("client_id" => DCR_ID)
        expect(later_store.read("issuers", [RESOURCE, "default"])).to eq(ISSUER)
        expect(later.fetch.status).to eq(200)

        expect(later.disconnect).to be(true)
        expect(later_store.read("tokens", [ISSUER, RESOURCE, "default"])).to be_nil
        expect(later.token_info).to be_nil
      end
    end
  end
end
