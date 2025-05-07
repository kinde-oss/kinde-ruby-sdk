module AuthHelper
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
    user_info = client.oauth.get_user.to_hash
    session[:kinde_user] = {
      id: user_info[:id],
      email: user_info[:preferred_email],
      first_name: user_info[:first_name],
      last_name: user_info[:last_name]
    }
  end
  
  def logged_in?
    session[:kinde_token_store].present?
  end

  def token_expired?
    return false unless session[:kinde_token_store].present?
    expires_at = session[:kinde_token_store][:expires_at]
    return false if expires_at.nil?
    expires_at.to_i > 0 && (expires_at <= Time.now.to_i)
  end

  def refresh_session_tokens
    return unless session[:kinde_token_store].present?
    
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
  end

  def get_client
    return nil unless session[:kinde_token_store].present?
    KindeSdk.client(session[:kinde_token_store])
  end
end
