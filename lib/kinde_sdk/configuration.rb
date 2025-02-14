module KindeSdk
  class Configuration
    attr_accessor :domain
    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :callback_url
    attr_accessor :logout_url
    attr_accessor :scope

    attr_accessor :authorize_url
    attr_accessor :token_url

    attr_accessor :logger
    attr_accessor :debugging
    attr_accessor :oauth_client
    attr_accessor :pkce_enabled
    attr_accessor :auto_refresh_tokens

    def initialize
      @authorize_url = '/oauth2/auth'
      @token_url = '/oauth2/token'
      @debugging = false
      @logger = defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
      @scope = 'openid offline email profile'
      @pkce_enabled = true
      @auto_refresh_tokens = true

      yield(self) if block_given?
    end

    def self.default
      @@default ||= Configuration.new
    end

    def configure
      yield(self) if block_given?
    end

    def oauth_client(client_id: @client_id, client_secret: @client_secret, domain: @domain, authorize_url: @authorize_url, token_url: @token_url )
      ::OAuth2::Client.new(
        client_id,
        client_secret,
        site: domain,
        authorize_url: authorize_url,
        token_url: token_url,
        logger: logger
      )
    end
  end
end
