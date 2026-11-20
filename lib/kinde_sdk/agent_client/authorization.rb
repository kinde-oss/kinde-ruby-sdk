# frozen_string_literal: true

require "securerandom"
require "uri"
require "pkce_challenge"

module KindeSdk
  class AgentClient
    # One sign-in attempt: builds the authorization URL (PKCE S256, always)
    # and checks the callback against the attempt it stored.
    #
    # @api private
    class Authorization
      NAMESPACE = "pending"
      MAX_AGE_SECONDS = Storage::PENDING_MAX_AGE
      OWN_PARAMETERS = %w[response_type client_id redirect_uri scope state code_challenge code_challenge_method resource].freeze

      # @param config [Config]
      def initialize(config)
        @config = config
      end

      # The scopes that will be asked for: +openid+ is removed when the server
      # lists its scopes and +openid+ is not one of them.
      #
      # @param metadata [Hash] validated authorization server metadata
      # @param scopes [Array<String>]
      # @return [Array<String>]
      def effective_scopes(metadata, scopes)
        supported = metadata["scopes_supported"]
        scopes = scopes.uniq
        supported.is_a?(Array) && !supported.include?("openid") ? scopes - ["openid"] : scopes
      end

      # Stores a new attempt and returns where to send the user.
      #
      # @param metadata [Hash] validated authorization server metadata
      # @param identity [Hash] the client identity (see {Registration})
      # @param scopes [Array<String>]
      # @param reregistered [Boolean] whether the client was just registered again after +invalid_client+
      # @return [Array(String, String)] the authorization URL and the +state+
      # @raise [DiscoveryError] when the authorization endpoint may not be used
      def start(metadata, identity, scopes:, reregistered: false)
        endpoint = Discovery.endpoint(metadata, "authorization_endpoint", loopback: @config.loopback_resource?)
        token_endpoint = Discovery.endpoint(metadata, "token_endpoint", loopback: @config.loopback_resource?)
        scopes = effective_scopes(metadata, scopes)
        pkce = PkceChallenge.challenge(char_length: 64)
        state = SecureRandom.urlsafe_base64(32)

        record = {
          "code_verifier" => pkce.code_verifier, "issuer" => metadata["issuer"], "token_endpoint" => token_endpoint,
          "client_id" => identity["client_id"], "redirect_uri" => @config.redirect_uri,
          "resource_url" => @config.resource_url, "account" => @config.account,
          "scopes" => scopes, "created_at" => Clock.now
        }
        record["reregistered"] = true if reregistered
        @config.storage.write(NAMESPACE, [state], record)

        [authorization_url(endpoint, identity["client_id"], scopes, state, pkce.code_challenge), state]
      end

      # Checks a callback and consumes its attempt. Nothing is retried.
      #
      # @param params [Hash] the query parameters of the redirect, String or Symbol keys
      # @return [Array(Hash, String)] the attempt and the authorization code
      # @raise [CallbackError] for a missing, unknown, reused or expired +state+,
      #   a different +iss+, or a missing +code+
      # @raise [OAuthError] when the redirect carries +error+
      def consume(params)
        state = param(params, "state")
        raise CallbackError, "The callback has no state" if state.nil?

        record = @config.storage.read(NAMESPACE, [state])
        raise CallbackError, unknown_state unless mine?(record)

        if Clock.now - record["created_at"].to_i > MAX_AGE_SECONDS
          @config.storage.delete(NAMESPACE, [state])
          raise CallbackError, "The sign-in attempt has expired; start again"
        end

        iss = param(params, "iss")
        if iss && iss != record["issuer"]
          raise CallbackError, "The callback came from another authorization server than the one the sign-in started at"
        end

        raise CallbackError, unknown_state unless @config.storage.delete(NAMESPACE, [state]).is_a?(Hash)

        if (error = param(params, "error"))
          description = param(params, "error_description")
          raise OAuthError.new(["The authorization server refused the sign-in", error, description].compact.join(": "),
                               error: error, error_description: description)
        end

        code = param(params, "code")
        raise CallbackError, "The callback has no authorization code" if code.nil?

        [record, code]
      end

      private

      def unknown_state
        "The callback state matches no sign-in attempt: it is unknown, already used or expired"
      end

      # An attempt this client started: same resource, account and redirect URI.
      def mine?(record)
        record.is_a?(Hash) &&
          record["resource_url"] == @config.resource_url &&
          record["account"] == @config.account &&
          record["redirect_uri"] == @config.redirect_uri
      end

      # Only a non-empty String counts as a parameter.
      def param(params, name)
        return nil unless params.respond_to?(:[])

        value = params[name] || params[name.to_sym]
        value.is_a?(String) && !value.empty? ? value : nil
      rescue TypeError, ArgumentError
        nil
      end

      def authorization_url(endpoint, client_id, scopes, state, code_challenge)
        uri = URI.parse(endpoint)
        query = URI.decode_www_form(uri.query.to_s).reject { |name, _| OWN_PARAMETERS.include?(name) }
        query << ["response_type", "code"] << ["client_id", client_id] << ["redirect_uri", @config.redirect_uri]
        query << ["scope", scopes.join(" ")] unless scopes.empty?
        query << ["state", state] << ["code_challenge", code_challenge] << ["code_challenge_method", "S256"]
        query << ["resource", @config.resource_url]
        uri.query = URI.encode_www_form(query)
        uri.fragment = nil
        uri.to_s
      end
    end
  end
end
