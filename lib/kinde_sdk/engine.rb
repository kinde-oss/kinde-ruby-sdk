module KindeSdk
  class Engine < ::Rails::Engine
    isolate_namespace KindeSdk # Optional, for mountable engines
  end
end