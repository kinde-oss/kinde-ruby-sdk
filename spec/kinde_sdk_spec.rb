require 'spec_helper'
require 'jwt'
require 'openssl'
require 'webmock/rspec'
require 'rails'

# Set up a minimal Rails application for testing
class TestApplication < Rails::Application
  config.eager_load = false
  config.active_support.deprecation = :stderr
end

RSpec.describe KindeSdk do
  let(:domain) { "http://example.com" }
  let(:client_id) { "client_id" }
  let(:client_secret) { "client_secret" }
  let(:callback_url) { "http://localhost:3000/callback" }
  let(:logout_url) { "http://localhost/logout-callback" }
  let(:auto_refresh_tokens) { true }
  let(:mock_session) { {} }

  let(:optional_parameters) { { kid: 'my-kid', use: 'sig', alg: 'RS512' } }
  let(:rsa_key) { OpenSSL::PKey::RSA.new(2048) }
  let(:jwk) { JWT::JWK.new(rsa_key, optional_parameters) }
  let(:payload) { { data: 'data' } }
  let(:token) { JWT.encode(payload, jwk.signing_key, jwk[:alg], kid: jwk[:kid]) }
  let(:refresh_token) { JWT.encode(payload, jwk.signing_key, jwk[:alg], kid: jwk[:kid]) }
  let(:jwks_hash) { JWT::JWK::Set.new(jwk).export }

  before do
    KindeSdk.configure do |c|
      c.domain = domain
      c.client_id = client_id
      c.client_secret = client_secret
      c.callback_url = callback_url
      c.logout_url = logout_url
      c.auto_refresh_tokens = auto_refresh_tokens
    end

    # Stub JWKS endpoint
    stub_request(:get, "#{domain}/.well-known/jwks.json")
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(
        status: 200,
        body: jwks_hash.to_json,
        headers: { "content-type" => "application/json;charset=UTF-8" }
      )

    # Stub token refresh endpoint - match URL-encoded request
    stub_request(:post, "#{domain}/oauth2/token")
      .with(
        body: /^grant_type=refresh_token&refresh_token=/,
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Basic Y2xpZW50X2lkOmNsaWVudF9zZWNyZXQ=',
          'Content-Type' => 'application/x-www-form-urlencoded',
          'User-Agent' => "Kinde-SDK: Ruby/#{KindeSdk::VERSION}"
        }
      )
      .to_return(
        status: 200,
        body: {
          "access_token" => token,
          "refresh_token" => refresh_token,
          "expires_in" => 3600,
          "token_type" => "bearer"
        }.to_json,
        headers: { "content-type" => "application/json;charset=UTF-8" }
      )
  end

  describe "#auth_url" do
    it "returns prepared authorize url", :aggregate_failures do
      auth_obj = described_class.auth_url
      expect(auth_obj[:code_verifier]).not_to be_nil
      expect(auth_obj[:url]).to start_with("#{domain}/oauth2/auth?client_id=#{client_id}&")
      expect(auth_obj[:url]).to match(/localhost%3A3000%2Fcallback/)
    end

    it "allows override callback url" do
      auth_obj = described_class.auth_url(redirect_uri: "localhost:5000/another_callback")
      expect(auth_obj[:url]).to match(/localhost%3A5000%2Fanother_callback/)
    end
  end

  describe "#logout_url" do
    it "returns logout url" do
      expect(described_class.logout_url)
        .to eq("http://example.com/logout?redirect=http%3A%2F%2Flocalhost%2Flogout-callback")
    end

    context "when logout url not set" do
      let(:logout_url) { nil }
      it "returns logout url without redirect query" do
        expect(described_class.logout_url).to eq("http://example.com/logout")
      end
    end
  end

  describe "#api_client" do
    it "returns initialized api_client instance of KindeApi" do
      api_client = described_class.api_client("token")
      expect(api_client).to be_a(KindeApi::ApiClient)
      expect(api_client.config.access_token).to eq("token")
    end
  end

  describe "#fetch_tokens" do
    let(:mock_token) do
      double('OAuth2::AccessToken',
        token: token,
        params: {
          'id_token' => 'test',
          'refresh_token' => refresh_token,
          'scope' => '',
          'token_type' => 'bearer'
        },
        expires_at: Time.now.to_i + 86399,
        refresh_token: refresh_token
      )
    end
    let(:mock_oauth_client) { double('OAuth2::Client') }
    let(:mock_auth_code) { double('OAuth2::Strategy::AuthCode') }

    before do
      allow(OAuth2::Client).to receive(:new).and_return(mock_oauth_client)
      allow(mock_oauth_client).to receive(:auth_code).and_return(mock_auth_code)
      allow(mock_auth_code).to receive(:get_token).and_return(mock_token)
    end

    it "calls /token url with proper body and headers" do
      result = described_class.fetch_tokens("code")
      expect(result[:access_token]).to eq(token)
      expect(result[:refresh_token]).to eq(refresh_token)
    end

    context "with redefined callback_url" do
      let(:custom_callback_url) { "http://localhost:5000/callback" }

      it "calls /token url with proper body and headers" do
        result = described_class.fetch_tokens("code", redirect_uri: custom_callback_url)
        expect(result[:access_token]).to eq(token)
        expect(result[:refresh_token]).to eq(refresh_token)
      end
    end
  end

  describe "#client_credentials_access" do
    let(:mock_response) do
      double('Faraday::Response',
        body: {
          "access_token" => token,
          "expires_in" => 3600,
          "token_type" => "bearer"
        }
      )
    end
    let(:mock_connection) { double('Faraday::Connection') }

    before do
      allow(Faraday).to receive(:new).and_return(mock_connection)
      allow(mock_connection).to receive(:post).and_return(mock_response)
    end

    it "calls oauth2/token url with configured credentials" do
      result = described_class.client_credentials_access
      expect(result["access_token"]).to eq(token)
    end

    context "with params override" do
      let(:custom_client_id) { "custom_client_id" }
      let(:custom_client_secret) { "custom_client_secret" }
      let(:custom_audience) { "custom_audience" }

      it "calls oauth2/token url with passed credentials" do
        result = described_class.client_credentials_access(
          client_id: custom_client_id,
          client_secret: custom_client_secret,
          audience: custom_audience
        )
        expect(result["access_token"]).to eq(token)
      end
    end
  end

  describe "client" do
    let(:hash_to_encode) do
      { "aud" => [],
        "azp" => "19ebb687cd2f405c9f2daf645a8db895",
        "feature_flags" => {
          "asd" => { "t" => "b", "v" => true },
          "eeeeee" => { "t" => "i", "v" => 111 },
          "qqq" => { "t" => "s", "v" => "aa" }
        },
        "iat": Time.now.to_i,           # Issued at: current time
        "exp": Time.now.to_i + 3600,  # Expiration time: 1 hour from now
        "iss" => "https://example.kinde.com",
        "jti" => "22c48b2c-da46-4661-a7ff-425c23eceab5",
        "org_code" => "org_cb4544175bc",
        "permissions" => ["read:todos", "create:todos"],
        "scp" => ["openid", "offline"],
        "sub" => "kp:b17adf719f7d4b87b611d1a88a09fd15" }
    end
    let(:token) { JWT.encode(hash_to_encode, jwk.signing_key, jwk[:alg], kid: jwk[:kid]) }
    let(:expires_at) { Time.now.to_i + 10000000 }
    let(:tokens_hash) { { access_token: token, expires_at: expires_at, refresh_token: refresh_token } }
    let(:client) { described_class.client(tokens_hash, auto_refresh_tokens) }

    context "with session integration" do
      before do
        KindeSdk::Current.set_session(mock_session)
      end

      after do
        KindeSdk::Current.clear_session
      end

      it "initializes with session" do
        expect(KindeSdk::Current.session).to eq(mock_session)
      end

      it "updates session when refreshing tokens" do
        new_token = "new_token"
        new_refresh_token = "new_refresh_token"
        new_expires_at = Time.now.to_i + 7200

        stub_request(:post, "#{domain}/oauth2/token")
          .with(
            body: {
              "grant_type" => "refresh_token",
              "refresh_token" => refresh_token
            },
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization' => 'Basic Y2xpZW50X2lkOmNsaWVudF9zZWNyZXQ=',
              'Content-Type' => 'application/x-www-form-urlencoded',
              'User-Agent' => "Kinde-SDK: Ruby/#{KindeSdk::VERSION}"
            }
          )
          .to_return(
            status: 200,
            body: {
              "access_token" => new_token,
              "refresh_token" => new_refresh_token,
              "expires_in" => 7200,
              "token_type" => "bearer"
            }.to_json,
            headers: { "content-type" => "application/json;charset=UTF-8" }
          )

        allow(KindeSdk).to receive(:refresh_token).and_return(tokens_hash)
        client.refresh_token

        expect(mock_session[:kinde_token_store]).to be_present
        expect(mock_session[:kinde_token_store][:access_token]).to eq(token)
        expect(mock_session[:kinde_token_store][:refresh_token]).to eq(refresh_token)
        expect(mock_session[:kinde_token_store][:expires_at]).to eq(expires_at)
      end

      it "creates client without session" do
        KindeSdk::Current.clear_session
        client_without_session = described_class.client(tokens_hash)
        expect(KindeSdk::Current.session).to be_nil
      end
    end

    context "with expiration check" do
      it "returns true when token is expired" do
        allow(KindeSdk).to receive(:refresh_token).and_return(tokens_hash)
        allow(KindeSdk::TokenManager).to receive(:token_expired?).and_return(true)
        expect(client.token_expired?).to be true
      end

      context "when token expired" do
        before do
          allow(KindeSdk::TokenManager).to receive(:token_expired?).and_return(true)
        end

        context "with auto_refresh_tokens enabled" do
          it "attempts to refresh the token when getting a claim" do
            allow(KindeSdk).to receive(:refresh_token).and_return(tokens_hash)
            expect(client).to receive(:refresh_token)
            client.get_claim("sub")
          end
        end

        context "with auto_refresh_tokens disabled" do
          let(:auto_refresh_tokens) { false }

          it "does not attempt to refresh the token" do
            expect(client).not_to receive(:refresh_token)
            client.get_claim("sub")
          end
        end
      end
    end

    context "with feature flags" do
      it "returns existing flags" do
        expect(client.get_flag("asd")[:value]).to eq(true)
        expect(client.get_flag("eeeeee")[:value]).to eq(111)
        expect(client.get_flag("qqq")[:value]).to eq("aa")
      end

      it "behaves the same way for boolean flag wrapper getter" do
        expect { client.get_boolean_flag("eeeeee") }
          .to raise_error(ArgumentError, "Flag eeeeee value type is different from requested type")
      end

      it "behaves the same way for integer flag wrapper getter" do
        expect { client.get_integer_flag("asd") }
          .to raise_error(ArgumentError, "Flag asd value type is different from requested type")
      end

      it "behaves the same way for string flag wrapper getter" do
        expect { client.get_string_flag("asd") }
          .to raise_error(ArgumentError, "Flag asd value type is different from requested type")
      end

      it "raises argument error when no value type match" do
        expect { client.get_flag("undefined", { default_value: true }, "s") }
          .to raise_error(ArgumentError, "Flag undefined value type is different from requested type")
        expect { client.get_flag("undefined", { default_value: true }, "i") }
          .to raise_error(ArgumentError, "Flag undefined value type is different from requested type")
        expect { client.get_flag("undefined", { default_value: "true" }, "b") }
          .to raise_error(ArgumentError, "Flag undefined value type is different from requested type")
      end

      it "returns fallbacks if no flag present" do
        expect(client.get_flag("undefined", { default_value: true })[:value]).to eq(true)
        expect(client.get_flag("undefined", { default_value: 111 })[:value]).to eq(111)
        expect(client.get_flag("undefined", { default_value: "aa" })[:value]).to eq("aa")
      end
    end

    context "when initializing with expired token" do
      context "with auto_refresh_tokens enabled" do
        it "attempts to refresh the token during initialization" do
          allow(KindeSdk::TokenManager).to receive(:token_expired?).and_return(true)
          expect_any_instance_of(KindeSdk::Client).to receive(:refresh_token)
          described_class.client(tokens_hash, true)
        end
      end
    end
  end
end


