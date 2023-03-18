require 'spec_helper'

describe KindeApi do
  let(:domain) { "http://example.com" }
  let(:client_id) { "client_id" }
  let(:client_secret) { "client_secret" }
  let(:callback_url) { "http://localhost:3000/callback" }

  before do
    KindeApi.configure do |c|
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
    it "returns initialized api_client instance of KindeSdk" do
      expect(described_class.api_client("bearer-token")).to be_instance_of(KindeSdk::ApiClient)
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

  describe "api instances" do
    let(:bearer) { 'some-bearer' }
    let(:client) { described_class.client(bearer) }

    it 'initializes client by passing the bearer' do
      expect(client).to be_instance_of(KindeApi::Client)
    end

    it "initializes oauth instance api" do
      expect(client.oauth).to be_instance_of(KindeSdk::OAuthApi)
    end

    it "initializes users instance api" do
      expect(client.users).to be_instance_of(KindeSdk::UsersApi)
    end
  end
end
