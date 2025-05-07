require "kinde_sdk/version"
require "kinde_sdk/configuration"
require "kinde_sdk/current"
require "kinde_sdk/middleware"

module KindeSdk
  class Engine < ::Rails::Engine
    isolate_namespace KindeSdk # Optional, for mountable engines
    config.app_middleware.use KindeSdk::Middleware
  end
end