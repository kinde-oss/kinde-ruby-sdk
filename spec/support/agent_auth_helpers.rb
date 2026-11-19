require 'jwt'
require 'json'
require 'openssl'

# Shared helpers for the AgentAuth specs (spec/agent_auth*_spec.rb).
# Not a spec file: each spec loads it with require_relative.
module AgentAuthHelpers
  DOMAIN = "https://yourbiz.kinde.com".freeze
  CLIENT_ID = "app_id".freeze
  CLIENT_SECRET = "app_secret".freeze
  RESOURCE_URL = "https://api.example.com/mcp".freeze
  ISSUER = "#{DOMAIN}/oauth2/agents/#{CLIENT_ID}".freeze
  INTROSPECT_URL = "#{ISSUER}/introspect".freeze
  REVOKE_URL = "#{ISSUER}/revoke".freeze
  JWKS_URL = "#{DOMAIN}/.well-known/jwks".freeze
  AS_METADATA_URL = "#{DOMAIN}/.well-known/oauth-authorization-server/oauth2/agents/#{CLIENT_ID}".freeze
  PRM_PATH = "/.well-known/oauth-protected-resource/mcp".freeze
  PRM_URL = "https://api.example.com#{PRM_PATH}".freeze
  # base64("app_id:app_secret")
  BASIC_HEADER = "Basic YXBwX2lkOmFwcF9zZWNyZXQ=".freeze
  KID = "kinde-key-1".freeze

  # One RSA key for the whole run: generating a key per example is slow.
  RSA_KEY = OpenSSL::PKey::RSA.new(2048)
  # A second key, for "signed by someone else" and key-rotation cases.
  OTHER_RSA_KEY = OpenSSL::PKey::RSA.new(2048)

  # A clock the specs move by hand, injected in place of the monotonic clock.
  class FakeClock
    attr_accessor :now

    def initialize(now = 1_000.0)
      @now = now
    end

    def call
      now
    end

    def advance(seconds)
      @now += seconds
    end
  end

  def agent_auth_options(overrides = {})
    {
      domain: DOMAIN,
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      resource_url: RESOURCE_URL
    }.merge(overrides)
  end

  def build_agent_auth(overrides = {})
    KindeSdk::AgentAuth.new(**agent_auth_options(overrides))
  end

  def jwks_document(key: RSA_KEY, kid: KID)
    { keys: [JWT::JWK.new(key, kid: kid, use: "sig", alg: "RS256").export] }
  end

  def stub_jwks(key: RSA_KEY, kid: KID)
    stub_request(:get, JWKS_URL).to_return(
      status: 200,
      body: jwks_document(key: key, kid: kid).to_json,
      headers: { "content-type" => "application/json" }
    )
  end

  # The claims of a Kinde access token issued through the scoped issuer.
  def token_claims(overrides = {})
    now = Time.now.to_i
    {
      "iss" => DOMAIN,
      "aud" => [RESOURCE_URL],
      "sub" => "kp_user_1",
      "azp" => "https://claude.ai/oauth/claude-code-client-metadata",
      "scp" => ["offline"],
      "org_code" => "org_123",
      "permissions" => ["read:docs"],
      "roles" => [{ "id" => "role_1", "key" => "admin", "name" => "Admin" }],
      "email" => "user@example.com",
      "iat" => now - 60,
      "exp" => now + 3600,
      "jti" => "jti_1"
    }.merge(overrides)
  end

  def sign_token(claims = token_claims, kid: KID, alg: "RS256", key: RSA_KEY)
    JWT.encode(claims, key, alg, { kid: kid })
  end

  # A token whose header says alg=none and that has an empty signature.
  def unsigned_token(claims = token_claims)
    segments = [{ "alg" => "none", "typ" => "JWT", "kid" => KID }, claims].map do |part|
      Base64.urlsafe_encode64(part.to_json, padding: false)
    end
    "#{segments.join('.')}."
  end

  def introspection_body(overrides = {})
    {
      "active" => true,
      "aud" => [RESOURCE_URL],
      "sub" => "kp_user_1",
      "scope" => "offline",
      "client_id" => "https://claude.ai/oauth/claude-code-client-metadata",
      "exp" => Time.now.to_i + 3600
    }.merge(overrides)
  end

  def stub_introspection(body = introspection_body, status: 200)
    stub_request(:post, INTROSPECT_URL).to_return(
      status: status,
      body: body.is_a?(String) ? body : body.to_json,
      headers: { "content-type" => "application/json" }
    )
  end

  # Records what the SDK logs instead of printing it.
  def capture_logs
    lines = []
    allow(KindeSdk::Logging).to receive(:write_log) { |level, message| lines << [level, message] }
    lines
  end

  README_PATH = File.expand_path("../../README.md", __dir__)

  # The one ```ruby block of the README that matches +pattern+, so a spec can
  # run the example a reader would copy instead of a second copy of it.
  def readme_ruby_example(pattern)
    blocks = File.read(README_PATH).scan(/^```ruby\n(.*?)^```/m).flatten
    matches = blocks.grep(pattern)
    raise "expected one README ruby example matching #{pattern.inspect}, found #{matches.size}" unless matches.size == 1

    matches.first
  end

  # The environment variables the README examples read.
  def stub_readme_environment
    allow(ENV).to receive(:fetch).and_call_original
    {
      "KINDE_DOMAIN" => DOMAIN,
      "KINDE_AGENTS_CLIENT_ID" => CLIENT_ID,
      "KINDE_AGENTS_CLIENT_SECRET" => CLIENT_SECRET,
      "KINDE_AGENTS_RESOURCE_URL" => RESOURCE_URL
    }.each { |name, value| allow(ENV).to receive(:fetch).with(name).and_return(value) }
  end
end
