KindeSdk::Engine.routes.draw do
    get "callback" => "auth#callback"
    get "auth" => "auth#auth"
    get "logout" => "auth#logout"
    get "logout_callback" => "auth#logout_callback"
    get "client_credentials_auth" => "auth#client_credentials_auth"
    get "refresh_token" => "auth#refresh_token"
end