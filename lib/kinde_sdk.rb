require "kinde_sdk/version"
require "kinde_sdk/configuration"
require "kinde_sdk/client/feature_flags"
require "kinde_sdk/client/permissions"
require "kinde_sdk/client"

require 'securerandom'
require 'oauth2'
require 'pkce_challenge'
require 'faraday/follow_redirects'
require 'uri'

module KindeSdk
  class << self
    attr_accessor :config

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
        authorize_url: "#{domain}/oauth2/auth",
        token_url: "#{domain}/oauth2/token",
        scope: @config.scope
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
      @config.oauth_client(
        client_id: client_id,
        client_secret: client_secret,
        domain: domain,
        authorize_url: "#{domain}/oauth2/auth",
        token_url: "#{domain}/oauth2/token").auth_code.get_token(code.to_s, params).to_hash
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
    def client(tokens_hash)
      sdk_api_client = api_client(tokens_hash["access_token"])
      KindeSdk::Client.new(sdk_api_client, tokens_hash, @config.auto_refresh_tokens)
    end

    def logout_url(logout_url: @config.logout_url, domain: @config.domain)
      query = logout_url ? URI.encode_www_form(redirect: logout_url) : nil
      host = URI::parse(domain).host
      URI::HTTP.build(host: host, path: '/logout', query: query).to_s
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
      OAuth2::AccessToken.from_hash(@config.oauth_client(
        client_id: client_id, 
        client_secret: client_secret,
        domain: domain,
        authorize_url: "#{domain}/oauth2/auth",
        token_url: "#{domain}/oauth2/token"), hash).expired?
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
      config = KindeApi::Configuration.default
      config.configure do |c|
        c.access_token = bearer_token
        c.host = @config.domain
        c.debugging = @config.debugging
        c.logger = @config.logger
        c.scheme = url_scheme(c.scheme)
      end

      KindeApi::ApiClient.new(config)
    end

    private

    def url_scheme(default_scheme)
      parsed_url = URI.parse(@config.domain.to_s)
      parsed_url.scheme || default_scheme
    rescue URI::InvalidURIError
      default_scheme
    end
  end
end
