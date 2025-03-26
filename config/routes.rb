KindeSdk::Engine.routes.draw do
    get "callback" => "auth#callback"
    get "auth" => "auth#auth"
    get "logout" => "auth#logout"
    get "logout_callback" => "auth#logout_callback"
    get "client_credentials_auth" => "auth#client_credentials_auth"
end