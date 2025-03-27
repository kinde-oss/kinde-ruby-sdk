Rails.application.routes.draw do
  mount KindeSdk::Engine => "/kinde-sdk"
end
