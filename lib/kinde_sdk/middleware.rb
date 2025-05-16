module KindeSdk
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = ActionDispatch::Request.new(env)
      Current.set_session(request.session)
      
      @app.call(env)
    ensure
      Current.clear_session
    end
  end
end 