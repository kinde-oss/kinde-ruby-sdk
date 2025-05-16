KindeSdk::Engine.routes.draw do
    # Authentication routes
    get "auth" => "auth#auth"
    get "callback" => "auth#callback"
    get "logout" => "auth#logout"
    get "logout_callback" => "auth#logout_callback"
    get "refresh_token" => "auth#refresh_token"
    get "client_credentials_auth" => "auth#client_credentials_auth"
end