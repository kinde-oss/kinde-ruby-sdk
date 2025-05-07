module KindeSdk
  class Current < ActiveSupport::CurrentAttributes
    attribute :session
    attribute :token_store

    def self.set_session(session)
      self.session = session
      self.token_store = TokenStore.from_session(session[:kinde_token_store]) if session[:kinde_token_store]
    end

    def self.clear_session
      self.session = nil
      self.token_store = nil
    end
  end
end 