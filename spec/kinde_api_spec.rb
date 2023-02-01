require 'spec_helper'

describe KindeApi do
  let(:domain) { "http://example.com" }
  let(:client_id) { "client_id" }
  let(:callback_url) { "http://localhost:3000/callback" }

  before do
    KindeApi.configure do |c|
      c.domain = domain
      c.client_id = client_id
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
