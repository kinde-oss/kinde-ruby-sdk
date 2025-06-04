module AuthHelper
  # Sets up session tokens and user information after successful authentication
  # @param tokens [Hash] The authentication tokens received from Kinde
  # @return [void]
  def set_session_tokens(tokens)
    # Create token store from tokens
    token_store = KindeSdk::TokenManager.create_store(tokens)
    
    # Store minimal token data in session
    session[:kinde_token_store] = {
      access_token: token_store.bearer_token,
      refresh_token: token_store.tokens[:refresh_token],
      expires_at: token_store.expires_at
    }
    
    # Get and store minimal user info
    client = KindeSdk.client(tokens)
    user_info = client.oauth.get_user_profile_v2.to_hash
    
    # Validate user info before storing
    raise ArgumentError, "Invalid user info received" unless user_info[:id].present?
    
    session[:kinde_user] = {
      id: user_info[:id],
      email: user_info[:email],
      first_name: user_info[:given_name],
      last_name: user_info[:family_name]
    }
  end
  
  # Checks if the user is currently logged in
  # @return [Boolean] true if the user is logged in and token is valid
  def logged_in?
    !token_expired?
  end

  # Checks if the session contains token data
  # @return [Boolean] true if session contains token data
  def session_present_in?
    session[:kinde_token_store].present?
  end

  # Checks if the current token has expired
  # @return [Boolean] true if token is expired or invalid
  def token_expired?
    return true unless session[:kinde_token_store].present?
    
    client = get_client
    return true unless client
    
    client.token_expired?
  rescue JWT::DecodeError => e
    Rails.logger.error("JWT decode error: #{e.message}")
    true
  rescue StandardError => e
    Rails.logger.error("Error checking token expiration: #{e.message}")
    true
  end

  # Attempts to refresh the session tokens
  # @return [Boolean] true if refresh was successful
  def refresh_session_tokens
    return false unless session[:kinde_token_store].present?
    
    # Create token store from session data
    token_store = KindeSdk::TokenStore.new(session[:kinde_token_store])
    
    # Attempt to refresh tokens
    new_tokens = KindeSdk::TokenManager.refresh_tokens(token_store, session)
    if new_tokens
      set_session_tokens(new_tokens)
      true
    else
      false
    end
  rescue StandardError => e
    Rails.logger.error("Error refreshing tokens: #{e.message}")
    session.delete(:kinde_token_store)
    false
  end

  # Gets a Kinde client instance for the current session
  # @return [KindeSdk::Client, nil] The client instance or nil if no valid session
  def get_client
    return nil unless session[:kinde_token_store].present?
    KindeSdk.client(session[:kinde_token_store])
  end
end
