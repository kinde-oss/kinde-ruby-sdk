require "logger"

# Rails is optional - SDK works in non-Rails Ruby applications
begin
  require "rails"
rescue LoadError
  # Rails not available, that's fine
end

require "kinde_sdk/version"
require "kinde_sdk/configuration"
require "kinde_sdk/logging"
require "kinde_sdk/client/feature_flags"
require "kinde_sdk/client/permissions"
require "kinde_sdk/client"
require "kinde_sdk/current"
require "kinde_sdk/errors"
require 'securerandom'
require 'oauth2'
require 'pkce_challenge'
require 'faraday/follow_redirects'
require 'uri'
require 'httparty'
require 'jwt'
require 'openssl'
require 'base64'



module KindeSdk


  
  class << self
    attr_accessor :config

    if defined?(Rails)
      require "kinde_sdk/engine"
    end

    def configure
      if block_given?
        yield(Configuration.default)
      else
        Configuration.default
      end

      @config = Configuration.default
    end

    # receive url for authorization in Kinde itself
    #
    # @return [Hash]
    def auth_url(
      client_id: @config.client_id,
      client_secret: @config.client_secret,
      domain: @config.domain,
      redirect_uri: @config.callback_url,
       **kwargs)
      params = {
        redirect_uri: redirect_uri,
        state: SecureRandom.hex,
        scope: @config.scope,
        supports_reauth: "true"
      }.merge(**kwargs)
      return { url: @config.oauth_client(
        client_id: client_id,
        client_secret: client_secret,
        domain: domain,
        authorize_url: "#{domain}/oauth2/auth",
        token_url: "#{domain}/oauth2/token").auth_code.authorize_url(params) } unless @config.pkce_enabled

      pkce_challenge = PkceChallenge.challenge(char_length: 128)
      params.merge!(code_challenge_method: 'S256', code_challenge: pkce_challenge.code_challenge)
      {
        url: @config.oauth_client(
          client_id: client_id,
          client_secret: client_secret,
          domain: domain,
          authorize_url: "#{domain}/oauth2/auth",
          token_url: "#{domain}/oauth2/token").auth_code.authorize_url(params),
        code_verifier: pkce_challenge.code_verifier
      }
    end

    # when callback processor receives code, it needs to be used for fetching bearer token
    #
    # @return [Hash]
    def fetch_tokens(
      params_or_code, 
      client_id: @config.client_id,
      client_secret: @config.client_secret,
      domain: @config.domain,
      code_verifier: nil,
      redirect_uri: @config.callback_url)
      code = params_or_code.kind_of?(Hash) ? params_or_code.fetch("code") : params_or_code
      params = {
        redirect_uri: redirect_uri,
        headers: { 'User-Agent' => "Kinde-SDK: Ruby/#{KindeSdk::VERSION}" }
      }
      params[:code_verifier] = code_verifier if code_verifier
      token = @config.oauth_client(
        client_id: client_id,
        client_secret: client_secret,
        domain: domain,
        authorize_url: "#{domain}/oauth2/auth",
        token_url: "#{domain}/oauth2/token").auth_code.get_token(code.to_s, params)

      {
        access_token: token.token,           # The access token
        id_token: token.params['id_token'],  # The ID token from params
        expires_at: token.expires_at,        # Optional: expiration time
        refresh_token: token.refresh_token,   # Optional: if present
        scope: token.params['scope'],        # The scopes requested
        token_type: token.params['token_type'] # The token type
      }.compact
    end

    # tokens_hash #=>
    # {"access_token"=>"eyJhbGciOiJSUzI1NiIsIm...",
    #  "expires_in"=>86399,
    #  "id_token"=>"eyJhbGciOiJSUz",
    #  "refresh_token"=>"eyJhbGciOiJSUz",
    #  "scope"=>"openid offline email profile",
    #  "token_type"=>"bearer"}
    #
    # @return [KindeSdk::Client]
    def client(tokens_hash, auto_refresh_tokens = @config.auto_refresh_tokens, force_api = @config.force_api)
      sdk_api_client = api_client(tokens_hash[:access_token] || tokens_hash["access_token"])
      KindeSdk::Client.new(sdk_api_client, tokens_hash, auto_refresh_tokens, force_api)
    end

    def logout_url(logout_url: @config.logout_url, domain: @config.domain)
      query = logout_url ? URI.encode_www_form(redirect: logout_url) : nil
      
      # Handle domains without scheme by prepending https://
      normalized_domain = domain.to_s
      normalized_domain = "https://#{normalized_domain}" unless normalized_domain.match?(%r{\A\w+://})
      
      parsed = URI.parse(normalized_domain)
      scheme = parsed.scheme || 'https'
      host_with_port = parsed.port && ![80, 443].include?(parsed.port) ? "#{parsed.host}:#{parsed.port}" : parsed.host
      
      "#{scheme}://#{host_with_port}/logout#{query ? "?#{query}" : ''}"
    end

    def client_credentials_access(
      client_id: @config.client_id,
      client_secret: @config.client_secret,
      audience: "#{@config.domain}/api",
      domain: @config.domain
    )
      Faraday.new(url: domain) do |faraday|
        faraday.response :json
        faraday.use Faraday::FollowRedirects::Middleware
      end
        .post("#{domain}/oauth2/token") do |req|
        req.headers[:content_type] = 'application/x-www-form-urlencoded'
        req.body =
          "grant_type=client_credentials&client_id=#{client_id}&client_secret=#{client_secret}&audience=#{audience}"
      end.body
    end

    def token_expired?(hash,
      client_id: @config.client_id,
      client_secret: @config.client_secret,
      audience: "#{@config.domain}/api",
      domain: @config.domain
    )
      begin
        validate_jwt_token(hash)
        OAuth2::AccessToken.from_hash(@config.oauth_client(
          client_id: client_id, 
          client_secret: client_secret,
          domain: domain,
          authorize_url: "#{domain}/oauth2/auth",
          token_url: "#{domain}/oauth2/token"), hash).expired?
      rescue JWT::DecodeError, OAuth2::Error => e
        sdk_log_error("Error checking token expiration: #{e.message}")
        true
      end
    end

    # @return [Hash]
    def refresh_token(hash,
      client_id: @config.client_id,
      client_secret: @config.client_secret,
      audience: "#{@config.domain}/api",
      domain: @config.domain
    )
      OAuth2::AccessToken.from_hash(@config.oauth_client(
        client_id: client_id, 
        client_secret: client_secret,
        domain: domain,
        authorize_url: "#{domain}/oauth2/auth",
        token_url: "#{domain}/oauth2/token"), hash).refresh.to_hash
    end

    # init sdk api client by bearer token
    #
    # @return [KindeApi::ApiClient]
    def api_client(bearer_token)
      config = KindeApi::Configuration.new  # Create a new instance instead of using default
      config.configure do |c|
        c.access_token = bearer_token
        c.host = URI.parse(@config.domain).host
        c.scheme = url_scheme(c.scheme)
        c.base_path = ''  # Set empty base path since we're using the root
        c.debugging = @config.debugging
        c.logger = @config.logger
        # Set server configuration
        c.server_index = nil  # Force direct URL construction
        c.server_variables = { 'subdomain' => URI.parse(@config.domain).host.split('.').first }
      end
      KindeApi::ApiClient.new(config)
    end

    def validate_jwt_token(token_hash)
      token_hash.each do |key, token|
        next unless %w[access_token id_token].include?(key.to_s.downcase)
        begin
          jwt_validation(token, "#{@config.domain}#{@config.jwks_url}", @config.expected_issuer, @config.expected_audience)
        rescue JWT::DecodeError
          sdk_log_error("Invalid JWT token: #{key}")
          raise JWT::DecodeError, "Invalid #{key.to_s.capitalize.gsub('_', ' ')}"
        end
      end
    end

    private

    def url_scheme(default_scheme)
      parsed_url = URI.parse(@config.domain.to_s)
      parsed_url.scheme || default_scheme
    rescue URI::InvalidURIError
      default_scheme
    end

    # Method to validate a JWT token with caching for JWKS
    def jwt_validation(jwt_token, jwks_url, expected_issuer, expected_audience)
      @cached_jwks ||= fetch_jwks(jwks_url)

      begin
        validate_token(jwt_token, @cached_jwks, expected_issuer, expected_audience)
      rescue JWT::DecodeError, StandardError
        # If validation fails, fetch JWKS again and retry validation
        @cached_jwks = fetch_jwks(jwks_url)
        validate_token(jwt_token, @cached_jwks, expected_issuer, expected_audience)
      end
    end

    # Fetch JWKS from the URL
    def fetch_jwks(jwks_url)
      jwks_response = HTTParty.get(jwks_url)
      JSON.parse(jwks_response.body)
    end

    # Validate the JWT token using the provided JWKS
    def validate_token(jwt_token, jwks_hash, expected_issuer, expected_audience)
      # Decode token header to get 'kid'
      decoded_token = JWT.decode(jwt_token, nil, false) # [payload, header]
      header = decoded_token[1]
      kid = header['kid']

      # Find the matching JWK
      jwks = JWT::JWK::Set.new(jwks_hash)
      jwks.filter! {|key| key[:use] == 'sig' }
      algorithms = jwks.map { |key| key[:alg] }.compact.uniq
      payload, _header = JWT.decode(jwt_token, nil, true, algorithms: algorithms, jwks: jwks)
      { valid: true, payload: payload }
    rescue JWT::DecodeError => e
      sdk_log_error("Token validation failed: #{e.message}")
      raise JWT::DecodeError, "Token validation failed: #{e.message}"
    rescue StandardError => e
      sdk_log_error("Unexpected error: #{e.message}")
      raise StandardError, "Unexpected error: #{e.message}"
    end

    # Helper for logging in class methods (works with or without Rails)
    def sdk_log_error(message)
      formatted_message = "[KindeSdk] #{message}"
      if defined?(Rails) && Rails.respond_to?(:logger) && Rails.logger
        Rails.logger.error(formatted_message)
      else
        $stderr.puts formatted_message
      end
    end

  end
end
