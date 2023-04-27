require 'spec_helper'

describe KindeSdk do
  let(:domain) { "http://example.com" }
  let(:client_id) { "client_id" }
  let(:client_secret) { "client_secret" }
  let(:callback_url) { "http://localhost:3000/callback" }

  before do
    KindeSdk.configure do |c|
      c.domain = domain
      c.client_id = client_id
      c.client_secret = client_secret
      c.callback_url = callback_url
    end
  end

  describe "#auth_url" do
    it "returns prepared authorize url", :aggregate_failures do
      auth_obj = described_class.auth_url
      expect(auth_obj[:code_verifier]).not_to be_nil
      expect(auth_obj[:url]).to start_with("#{domain}/oauth2/auth?client_id=#{client_id}&")
    end
  end

  describe "#api_client" do
    it "returns initialized api_client instance of KindeApi" do
      expect(described_class.api_client("bearer-token")).to be_instance_of(KindeApi::ApiClient)
    end
  end

  describe "#client_credentials_access" do
    let(:audience) { "#{domain}/api" }
    let(:request_body) do
      "grant_type=client_credentials&client_id=#{client_id}&client_secret=#{client_secret}&audience=#{audience}"
    end
    let(:response_body) do
      { "access_token" => "eyJhbGciO", "expires_in" => 86399, "scope" => "", "token_type" => "bearer" }.to_json
    end
    before { stub_request(:post, "#{domain}/oauth2/token").with(body: request_body).to_return(body: response_body) }

    it "calls oauth2/token url with configured credentials" do
      expect(described_class.client_credentials_access).to eq(response_body)
    end

    context "with params override" do
      let(:client_id) { 'other_id' }
      let(:client_secret) { 'other_secret' }
      let(:audience) { 'some-audience' }

      it "calls oauth2/token url with passed credentials" do
        expect(described_class.client_credentials_access(
                 client_id: client_id, client_secret: client_secret, audience: audience
        )).to eq(response_body)
      end
    end
  end

  describe "client" do
    let(:hash_to_encode) do
      { "aud" => [],
       "azp" => "19ebb687cd2f405c9f2daf645a8db895",
       "exp" => 1679600554,
       "feature_flags" => nil,
       "iat" => 1679514154,
       "iss" => "https://example.kinde.com",
       "jti" => "22c48b2c-da46-4661-a7ff-425c23eceab5",
       "org_code" => "org_cb4544175bc",
       "permissions" => ["read:todos", "create:todos"],
       "scp" => ["openid", "offline"],
       "sub" => "kp:b17adf719f7d4b87b611d1a88a09fd15" }
    end
    let(:token) { JWT.encode(hash_to_encode, nil, "none") }
    let(:client) { described_class.client(token) }

    it "returns requested claim from bearer", :aggregate_failures do
      expect(client.get_claim("scp")).to eq(hash_to_encode["scp"])
      expect(client.get_claim("aaa")).to be_nil
    end

    it "returns permissions from bearer", :aggregate_failures do
      expect(client.get_permissions).to eq(hash_to_encode["permissions"])
      expect(client.get_permission(hash_to_encode["permissions"][0]))
        .to eq({ org_code: hash_to_encode["org_code"], is_granted: true })
      expect(client.permission_granted?(hash_to_encode["permissions"][0])).to be(true)
      expect(client.get_permission("asd"))
        .to eq({ org_code: hash_to_encode["org_code"], is_granted: false })
      expect(client.permission_granted?("asd")).to be(false)
    end

    describe "api instances" do
      it 'initializes client by passing the bearer' do
        expect(client).to be_instance_of(KindeSdk::Client)
      end

      it "initializes oauth instance api" do
        expect(client.oauth).to be_instance_of(KindeApi::OAuthApi)
      end

      it "initializes users instance api" do
        expect(client.users).to be_instance_of(KindeApi::UsersApi)
      end
    end
  end
end
