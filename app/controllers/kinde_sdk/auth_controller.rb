require 'action_controller'
require 'uri'
require 'cgi'
require 'net/http'
require 'json'
require 'jwt'

module KindeSdk
  class AuthController < ActionController::Base
    include AuthHelper
    
    before_action :validate_state, only: :callback
    before_action :clear_auth_session, only: [:logout_callback, :logout]
  
    def auth
      # Generate a secure random nonce
      nonce = SecureRandom.urlsafe_base64(16)
      
      # Call KindeSdk.auth_url with nonce
      auth_data = KindeSdk.auth_url(nonce: nonce)
      
      # Store in session
      session[:code_verifier] = auth_data[:code_verifier] if auth_data[:code_verifier].present?
      session[:auth_nonce] = nonce
      session[:auth_state] = {
        requested_at: Time.current.to_i,
        redirect_url: auth_data[:url]
      }
      
      redirect_to auth_data[:url], allow_other_host: true
    rescue StandardError => e
      handle_error("Auth initialization failed", e)
    end
  
    def callback
      tokens = fetch_and_validate_tokens
      return if performed?

      # Store tokens and user in session
      set_session_tokens(tokens)
      
      # Clear auth session data
      clear_auth_session
      
      redirect_to "/"
    rescue StandardError => e
      handle_error("Authentication callback failed", e)
    end
  
    def client_credentials_auth
      result = KindeSdk.client_credentials_access(
        client_id: ENV["KINDE_MANAGEMENT_CLIENT_ID"],
        client_secret: ENV["KINDE_MANAGEMENT_CLIENT_SECRET"]
      )
  
      if result["error"].present?
        raise result["error"]
      end
  
      $redis.set("kinde_m2m_token", result["access_token"], ex: result["expires_in"].to_i)
      redirect_to mgmt_path
    rescue StandardError => e
      handle_error("Client credentials authentication failed", e)
    end

    def refresh_token
      return redirect_with_error("No valid session found") unless session[:kinde_token_store].present?

      if refresh_session_tokens
        redirect_to "/"
      else
        redirect_with_error("Failed to refresh token")
      end
    rescue StandardError => e
      handle_error("Token refresh failed", e)
    end
  
    def logout
      redirect_to KindeSdk.logout_url, allow_other_host: true
    end
  
    def logout_callback
      redirect_to "/"
    end
  
    private

    def fetch_and_validate_tokens
      tokens = KindeSdk.fetch_tokens(
        params[:code],
        code_verifier: KindeSdk.config.pkce_enabled ? session[:code_verifier] : nil,
        redirect_uri: KindeSdk.config.callback_url
      )

      # Validate nonce in ID token
      unless validate_nonce(tokens[:id_token], session[:auth_nonce], KindeSdk.config.domain, KindeSdk.config.client_id)
        redirect_with_error("Invalid authentication nonce")
        return nil
      end

      tokens
    end

    def clear_auth_session
      session.delete(:auth_nonce)
      session.delete(:auth_state)
      session.delete(:code_verifier)
    end
  
    def validate_state
      # Check if nonce and state exist in session
      unless session[:auth_state]
        redirect_with_error("Invalid authentication state")
        return
      end
  
      # Verify nonce returned matches stored nonce
      returned_state = params[:state]
      stored_state = session[:auth_state]
      stored_url = stored_state["redirect_url"]
  
      # Extract the state from the stored redirect_url
      parsed_url = URI.parse(stored_url)
      query_params = CGI.parse(parsed_url.query || "")
      stored_state_from_url = query_params["state"]&.first

      # Verify returned state matches the state extracted from the redirect_url
      unless returned_state.present? && returned_state == stored_state_from_url
        redirect_with_error("Invalid authentication state")
        return
      end

      # Check state age (expires after 15 minutes)
      if Time.current.to_i - stored_state["requested_at"] > 900
        redirect_with_error("Authentication session expired")
        return
      end
    end

    def validate_nonce(id_token, original_nonce, issuer, client_id)
      return false unless id_token && original_nonce && issuer && client_id

      decoded_token = decode_jwt_token(id_token, issuer, client_id)
      return false unless decoded_token

      payload = decoded_token[0]
      nonce_from_token = payload['nonce']
      
      nonce_from_token == original_nonce
    rescue StandardError => e
      false
    end

    def decode_jwt_token(token, issuer, client_id)
      jwks = fetch_jwks(issuer)
      return nil unless jwks

      JWT.decode(
        token,
        nil,
        true,
        algorithm: 'RS256',
        iss: issuer,
        aud: client_id,
        verify_iss: true,
        verify_aud: true,
        jwks: { keys: jwks['keys'] }
      )
    rescue StandardError => e
      nil
    end

    def fetch_jwks(issuer)
      jwks_uri = URI.parse("#{issuer}/.well-known/jwks.json")
      jwks_response = Net::HTTP.get(jwks_uri)
      JSON.parse(jwks_response)
    rescue StandardError => e
      nil
    end

    def handle_error(message, error)
      redirect_with_error(message)
    end

    def redirect_with_error(message)
      redirect_to "/", alert: message
    end
  end
end