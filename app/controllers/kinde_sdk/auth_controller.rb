require 'action_controller'
require 'uri'
require 'cgi'
require 'net/http'
require 'json'
require 'jwt'

module KindeSdk
  # AuthController handles all authentication-related actions for the Kinde SDK
  # including OAuth2 flows, token management, and session handling
  class AuthController < ActionController::Base
    include AuthHelper
    
    before_action :validate_state, only: :callback
    before_action :clear_auth_session, only: [:logout_callback, :logout]
  
    # Initiates the OAuth2 authorization flow
    # Generates a secure nonce and redirects to Kinde's authorization endpoint
    # @return [void] Redirects to Kinde's authorization URL
    def auth
      # Generate a secure random nonce for CSRF protection
      nonce = SecureRandom.urlsafe_base64(16)

      # Get authorization URL and PKCE code verifier from SDK
      auth_params = { nonce: nonce }

      # Check for invitation_code in query parameters
      # Validate to prevent injection and ensure it's a reasonable length
      if params[:invitation_code].is_a?(String) && params[:invitation_code].strip.length > 0 && params[:invitation_code].length <= 255
        auth_params[:invitation_code] = params[:invitation_code].strip
      end

      auth_data = KindeSdk.auth_url(**auth_params)
      
      # Store PKCE code verifier and nonce in session for validation
      session[:code_verifier] = auth_data[:code_verifier] if auth_data[:code_verifier].present?
      session[:auth_nonce] = nonce
      session[:auth_state] = {
        requested_at: Time.current.to_i,
        redirect_url: auth_data[:url],
        # Only allow reauth-leniency when reauth_state was provided
        supports_reauth: params[:reauth_state].present?
      }
      
      redirect_to auth_data[:url], allow_other_host: true
    rescue StandardError => e
      handle_error("Auth initialization failed", e)
    end
  
    # Handles the OAuth2 callback from Kinde
    # Validates the response, exchanges code for tokens, and sets up the session
    # @return [void] Redirects to root path on success
    def callback
      # Handle reauth errors first
      if handle_reauth_error
        return
      end

      tokens = fetch_and_validate_tokens
      return if performed?

      # Store tokens and user information in session
      set_session_tokens(tokens)
      
      # Clean up temporary auth session data
      clear_auth_session
      
      redirect_to "/"
    rescue StandardError => e
      handle_error("Authentication callback failed", e)
    end
  
    # Handles machine-to-machine (M2M) authentication using client credentials
    # Stores the access token in Redis for subsequent API calls
    # @return [void] Redirects to management path on success
    def client_credentials_auth
      result = KindeSdk.client_credentials_access(
        client_id: ENV["KINDE_MANAGEMENT_CLIENT_ID"],
        client_secret: ENV["KINDE_MANAGEMENT_CLIENT_SECRET"]
      )
  
      if result["error"].present?
        raise result["error"]
      end
  
      # Store M2M token in Redis with expiration
      $redis.set("kinde_m2m_token", result["access_token"], ex: result["expires_in"].to_i)
      redirect_to mgmt_path
    rescue StandardError => e
      handle_error("Client credentials authentication failed", e)
    end

    # Refreshes the access token using the refresh token
    # @return [void] Redirects to root path on success
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
  
    # Initiates the logout process by redirecting to Kinde's logout endpoint
    # @return [void] Redirects to Kinde's logout URL
    def logout
      # Ensure we have a valid logout URL configured
      unless KindeSdk.config.logout_url.present?
        redirect_with_error("Logout URL not configured")
        return
      end

      # Get the logout URL with our callback URL
      logout_url = KindeSdk.logout_url(
        logout_url: KindeSdk.config.logout_url,
        domain: KindeSdk.config.domain
      )

      # Clear local session before redirecting to Kinde
      session.delete(:kinde_token_store)
      session.delete(:kinde_user)
      clear_auth_session

      # Redirect to Kinde's logout endpoint
      redirect_to logout_url, allow_other_host: true
    rescue StandardError => e
      handle_error("Logout initialization failed", e)
    end
  
    # Handles the callback after successful logout
    # @return [void] Redirects to root path
    def logout_callback
      # Session is already cleared in logout method
      # Just redirect to home page
      redirect_to "/"
    end
  
    private

    def handle_reauth_error
      error_param = params[:error]
      return false unless error_param.present?
      
      if error_param.downcase == "login_link_expired"
        handle_expired_login_link
      else
        Rails.logger.warn("OAuth error received: #{error_param}")
      end
      
      true
    end

    def handle_expired_login_link
      reauth_state = params[:reauth_state]
      return unless reauth_state.present?
      
      begin
        decoded_auth_state = Base64.decode64(reauth_state)
        reauth_data = JSON.parse(decoded_auth_state)
        
        if reauth_data.present?
          redirect_to build_reauth_url(reauth_data), allow_other_host: true
        end
      rescue ArgumentError => e
        handle_error("Invalid reauth state encoding", e)
      rescue JSON::ParserError => e
        handle_error("Invalid reauth state format", e)
      end
    end

    def build_reauth_url(reauth_data)
      auth_url = "#{request.base_url}#{KindeSdk::Engine.routes.url_helpers.auth_path}"
      query_string = URI.encode_www_form(reauth_data)
      "#{auth_url}?#{query_string}"
    end

    # Fetches and validates tokens from the authorization code
    # @return [Hash] The validated tokens or nil if validation fails
    def fetch_and_validate_tokens
      begin
        tokens = KindeSdk.fetch_tokens(
          params[:code],
          code_verifier: KindeSdk.config.pkce_enabled ? session[:code_verifier] : nil,
          redirect_uri: KindeSdk.config.callback_url
        )
      rescue StandardError => e
        # Handle PKCE-related errors that might occur during token fetch
        if e.message.include?("PKCE code verifier") || e.message.include?("invalid_grant")
          # This could be a reauth scenario where session data was lost
          # Redirect back to auth to start fresh
          Rails.logger.warn("PKCE/token issue detected (#{e.message}), redirecting to re-authenticate")
          redirect_to "#{request.base_url}#{KindeSdk::Engine.routes.url_helpers.auth_path}"
          return nil
        end
        
        # Re-raise other errors
        raise e
      end

      if tokens[:error].present?
        redirect_with_error("Token exchange failed: #{tokens[:error]}")
        return nil
      end

      # Validate tokens using SDK's built-in validation
      begin
        KindeSdk.validate_jwt_token(tokens)
        
        # Validate nonce in ID token to prevent replay attacks
        # Skip nonce validation if no session nonce (could be reauth scenario)
        if session[:auth_nonce].present?
          decoded_token = JWT.decode(tokens[:id_token], nil, false)[0]
          unless decoded_token['nonce'] == session[:auth_nonce]
            redirect_with_error("Invalid authentication nonce")
            return nil
          end
        else
          Rails.logger.warn("Skipping nonce validation - no session nonce found (possible reauth scenario)")
        end

        tokens
      rescue JWT::DecodeError => e
        redirect_with_error("Token validation failed: #{e.message}")
        nil
      end
    end

    # Clears temporary authentication data from the session
    # @return [void]
    def clear_auth_session
      session.delete(:auth_nonce)
      session.delete(:auth_state)
      session.delete(:code_verifier)
    end
  
    # Validates the state parameter to prevent CSRF attacks
    # Checks state existence, matches returned state with stored state, and validates expiration
    # @return [void]
    def validate_state
      
      error_param = params[:error]
      if error_param.present?
        if error_param.downcase == "login_link_expired"
          return
        end
      end
      # Check if nonce and state exist in session
      unless session[:auth_state]
        # If no session state but we have a code, check if this could be a reauth scenario
        # In reauth scenarios, the session might be lost but we still have a valid OAuth code
        if params[:code].present?
          # Skip validation for potential reauth scenarios where session state is lost
          return
        end
        
        redirect_with_error("Invalid authentication state")
        return
      end

      # If this auth flow supports reauth, be more lenient with validation
      if session[:auth_state]["supports_reauth"]
        # Only skip when both code _and_ state are supplied
        return if params[:code].present? && params[:state].present?
      end

      # Normal state validation for non-reauth flows
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

    # Handles errors during authentication
    # @param message [String] The error message
    # @param error [Exception] The exception that occurred
    # @return [void]
    def handle_error(message, error)
      Rails.logger.error("Error: #{error.message}")
      redirect_with_error(message)
    end

    # Redirects to root path with an error message
    # @param message [String] The error message
    # @return [void]
    def redirect_with_error(message)
      Rails.logger.error("Redirecting with error: #{message}")
      redirect_to "/", alert: message
    end
  end
end