require 'action_controller'
require 'uri'
require 'cgi'
require 'net/http'
require 'json'
require 'jwt'

module KindeSdk
  class AuthController < ActionController::Base
    # Add before_action to validate nonce in callback
    before_action :validate_state, only: :callback
  
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
    end
  
    def callback
      tokens = KindeSdk.fetch_tokens(
        params[:code],
        code_verifier: KindeSdk.config.pkce_enabled ? session[:code_verifier] : nil
      ).slice(:access_token, :refresh_token, :expires_at)
  

      # Validate nonce in ID token
      Rails.logger.info("The tokens are: #{tokens}")
      id_token = tokens[:id_token]
      Rails.logger.info("The id token is: #{id_token}")
      issuer = KindeSdk.config.domain
      client_id = KindeSdk.config.client_id
      original_nonce = session[:auth_nonce]
      unless validate_nonce(id_token, original_nonce, issuer, client_id)
        Rails.logger.warn("Nonce validation failed")
        redirect_to "/", alert: "Invalid authentication nonce"
        return
      end

      # Store tokens and user in session
      session[:kinde_auth] = tokens
      session[:kinde_user] = KindeSdk.client(tokens).oauth.get_user.to_hash
      
      # Clear nonce and state after successful authentication
      session.delete(:auth_nonce)
      session.delete(:auth_state)
      session.delete(:code_verifier)
  
      redirect_to main_app.root_path
    rescue StandardError => e
      Rails.logger.error("Authentication callback failed: #{e.message}")
      redirect_to "/", alert: "Authentication failed"
    end
  
    def client_credentials_auth
      result = KindeSdk.client_credentials_access(
        client_id: ENV["KINDE_MANAGEMENT_CLIENT_ID"],
        client_secret: ENV["KINDE_MANAGEMENT_CLIENT_SECRET"]
      )
  
      if result["error"].present?
        Rails.logger.error("Client credentials auth failed: #{result['error']}")
        raise result["error"]
      end
  
      $redis.set("kinde_m2m_token", result["access_token"], ex: result["expires_in"].to_i)
      redirect_to mgmt_path
    end
  
    def logout
      redirect_to KindeSdk.logout_url, allow_other_host: true
    end
  
    def logout_callback
      Rails.logger.info("Logout callback successfully received")
      reset_session
      redirect_to "/"
    end
  
    private
  
    def validate_state
      # Check if nonce and state exist in session
      unless session[:auth_nonce] && session[:auth_state]
        Rails.logger.warn("Missing session state or nonce")
        redirect_to "/", alert: "Invalid authentication state"
        return
      end
  
      # Verify nonce returned matches stored nonce
      returned_state = params[:state]
      stored_state = session[:auth_state]
      stored_url = stored_state["redirect_url"]
  
      # Extract the state from the stored redirect_url
      Rails.logger.info("The uri is : [#{stored_url}]")
      parsed_url = URI.parse(stored_url)
      query_params = CGI.parse(parsed_url.query || "")
      stored_state_from_url = query_params["state"]&.first

      # Verify returned state matches the state extracted from the redirect_url
      unless returned_state.present? && returned_state == stored_state_from_url
        Rails.logger.warn("State validation failed: returned=#{returned_state}, expected=#{stored_state_from_url}")
        redirect_to "/", alert: "Invalid authentication state"
        return
      end

      # Optional: Check state age (e.g., expires after 15 minutes)
      if Time.current.to_i - stored_state["requested_at"] > 900
        Rails.logger.warn("Authentication state expired")
        redirect_to "/", alert: "Authentication session expired"
        return
      end
    end


    def validate_nonce(id_token, original_nonce, issuer, client_id)
      jwks_uri = URI.parse("#{issuer}/.well-known/jwks.json")
      jwks_response = Net::HTTP.get(jwks_uri)
      jwks = JSON.parse(jwks_response)
    
      decoded_token = JWT.decode(
        id_token,
        nil,
        true,
        algorithm: 'RS256',
        iss: issuer,
        aud: client_id,
        verify_iss: true,
        verify_aud: true,
        jwks: { keys: jwks['keys'] }
      )
    
      payload = decoded_token[0]
      nonce_from_token = payload['nonce']
      
      Rails.logger.info("The nonce from the token is: #{nonce_from_token}")
      Rails.logger.info("The original nonce is: #{original_nonce}")
      nonce_from_token == original_nonce
    rescue StandardError => e
      puts "Error: #{e.message}"
      false
    end
    
    
  end
end