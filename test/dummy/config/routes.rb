Rails.application.routes.draw do
  mount Kinde::Ruby::Sdk::Engine => "/kinde-ruby-sdk"
end
