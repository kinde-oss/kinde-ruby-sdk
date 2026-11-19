require 'json'
require 'uri'
require 'base64'
require 'digest'
require_relative 'agent_auth_helpers'

# Shared helpers for the AgentClient specs (spec/agent_client*_spec.rb): a
# fake resource server and a fake authorization server made of WebMock stubs,
# and a clock the specs move by hand.
# Not a spec file: each spec loads it with require_relative.
module AgentClientHelpers
  include AgentAuthHelpers

  RESOURCE = "https://api.example.com/mcp".freeze
  PRM = "https://api.example.com/.well-known/oauth-protected-resource/mcp".freeze
  PRM_ROOT = "https://api.example.com/.well-known/oauth-protected-resource".freeze
  KINDE = "https://yourbiz.kinde.com".freeze
  ISSUER = "#{KINDE}/oauth2/agents/app_id".freeze
  METADATA = "#{KINDE}/.well-known/oauth-authorization-server/oauth2/agents/app_id".freeze
  AUTHORIZE = "#{ISSUER}/authorize".freeze
  TOKEN = "#{ISSUER}/token".freeze
  REGISTER = "#{ISSUER}/register".freeze
  REVOKE = "#{ISSUER}/revoke".freeze
  REDIRECT = "https://agent.example.com/oauth/callback".freeze
  CIMD = "https://agent.example.com/oauth/client-metadata.json".freeze

  # Placeholder credentials. Every spec that checks for leaks looks for these.
  ACCESS = "access-token-one".freeze
  NEW_ACCESS = "access-token-two".freeze
  REFRESH = "refresh-token-one".freeze
  NEW_REFRESH = "refresh-token-two".freeze
  CODE = "authorization-code-one".freeze
  DCR_ID = "dcr-client-id-one".freeze
  DCR_SECRET = "dcr-client-secret-one".freeze
  NOW = 1_800_000_000

  JSON_HEADERS = { "content-type" => "application/json" }.freeze

  # The authorization server metadata Kinde serves for the scoped issuer.
  def server_metadata(overrides = {})
    {
      "issuer" => ISSUER,
      "authorization_endpoint" => AUTHORIZE,
      "token_endpoint" => TOKEN,
      "registration_endpoint" => REGISTER,
      "revocation_endpoint" => REVOKE,
      "token_endpoint_auth_methods_supported" => %w[client_secret_post none],
      "code_challenge_methods_supported" => ["S256"],
      "scopes_supported" => %w[offline profile email],
      "client_id_metadata_document_supported" => true
    }.merge(overrides).compact
  end

  def json_response(body, status: 200)
    { status: status, body: body.is_a?(String) ? body : JSON.generate(body), headers: JSON_HEADERS }
  end

  def stub_prm(body = { "resource" => RESOURCE, "authorization_servers" => [ISSUER] }, url: PRM, status: 200)
    stub_request(:get, url).to_return(json_response(body, status: status))
  end

  def stub_metadata(body = server_metadata, url: METADATA, status: 200)
    stub_request(:get, url).to_return(json_response(body, status: status))
  end

  def registration_response(overrides = {})
    {
      "client_id" => DCR_ID,
      "client_secret" => DCR_SECRET,
      "client_secret_expires_at" => NOW + (30 * 86_400),
      "token_endpoint_auth_method" => "client_secret_post"
    }.merge(overrides).compact
  end

  def stub_register(body = registration_response, status: 201, url: REGISTER)
    stub_request(:post, url).to_return(json_response(body, status: status))
  end

  def token_response(overrides = {})
    {
      "access_token" => ACCESS, "token_type" => "bearer", "expires_in" => 86_400,
      "scope" => "offline", "refresh_token" => REFRESH
    }.merge(overrides).compact
  end

  def stub_token(body = token_response, status: 200, url: TOKEN)
    stub_request(:post, url).to_return(json_response(body, status: status))
  end

  def stub_token_error(error, status: 400, url: TOKEN)
    stub_token({ "error" => error, "error_description" => "The server said #{error}" }, status: status, url: url)
  end

  def stub_revoke(status: 200, url: REVOKE)
    stub_request(:post, url).to_return(status: status, body: "")
  end

  # The protected resource and everything under it: 200 for a token in
  # +valid+, else the 401 challenge.
  def stub_resource(valid: [ACCESS], url: RESOURCE, challenge_metadata: PRM)
    stub_request(:any, %r{\A#{Regexp.escape(url)}(?:[/?].*)?\z}).to_return do |request|
      token = request.headers["Authorization"].to_s[/\ABearer (.+)\z/, 1]
      if valid.include?(token)
        { status: 200, body: "resource says hello", headers: { "content-type" => "text/plain" } }
      else
        parts = []
        parts << 'error="invalid_token"' if token
        parts << %(resource_metadata="#{challenge_metadata}") if challenge_metadata
        { status: 401, body: "", headers: { "WWW-Authenticate" => "Bearer #{parts.join(', ')}".strip } }
      end
    end
  end

  # Kinde with everything in place: metadata documents, endpoints, resource.
  def stub_kinde(metadata: server_metadata, valid: [ACCESS])
    stub_prm
    stub_metadata(metadata)
    stub_register
    stub_token
    stub_revoke
    stub_resource(valid: valid)
  end

  def build_client(overrides = {})
    KindeSdk::AgentClient.new(**{ resource_url: RESOURCE, redirect_uri: REDIRECT }.merge(overrides))
  end

  # A client that uses a client ID metadata document: no registration call.
  def cimd_client(overrides = {})
    build_client({ client_metadata_url: CIMD }.merge(overrides))
  end

  def query_of(url)
    URI.decode_www_form(URI.parse(url).query.to_s).to_h
  end

  def form_of(request)
    URI.decode_www_form(request.body.to_s).to_h
  end

  # Runs the browser step by hand: start an attempt, come back with a code.
  def sign_in(client, code: CODE, scopes: nil)
    state = query_of(client.authorization_url(scopes: scopes))["state"]
    client.handle_callback("code" => code, "state" => state)
  end

  # Every request made so far, in the order each distinct request was first made.
  def requests(method = nil, url = nil)
    made = WebMock::RequestRegistry.instance.requested_signatures.hash.flat_map { |signature, count| [signature] * count }
    made.select do |signature|
      (method.nil? || signature.method == method) && (url.nil? || request_url(signature) == url)
    end
  end

  # The URL of a request without its query and without the default port.
  def request_url(signature)
    uri = signature.uri
    port = uri.port.nil? || uri.port == uri.default_port ? "" : ":#{uri.port}"
    "#{uri.scheme}://#{uri.host}#{port}#{uri.path}"
  end

  def requested_urls(method = nil)
    requests(method).map { |signature| request_url(signature) }.uniq
  end

  def stored_tokens(store, issuer: ISSUER, resource: RESOURCE, account: "default")
    store.read("tokens", [issuer, resource, account])
  end

  def stored_registration(store, issuer: ISSUER, redirect_uri: REDIRECT)
    store.read("registrations", [issuer, redirect_uri])
  end

  # Moves the client's clock; the stores and the metadata cache read the same one.
  def freeze_clock(clock)
    allow(KindeSdk::AgentClient::Clock).to receive(:now) { clock.now.to_i }
  end
end
