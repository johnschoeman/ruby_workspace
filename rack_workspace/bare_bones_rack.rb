require 'rack'
require 'thin'

# using class
class HelloWorld
  def call(env)
    [200, {"Content-Type" => "text/plain"}, env]
  end
end

# using lambda
app = -> (env) {
  sleep 3
  [200, {"Content-Type" => "text/plain"}, ["hello world\n"]]
}

class LoggingMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    before = Time.now.to_i
    status, headers, body = @app.call(env)
    after = Time.now.to_i
    log_message = "App took #{after - before} seconds."

    [status, headers, body << log_message]
  end
end

# Rack::Handler::Thin.run HelloWorld.new
# Rack::Handler::Thin.run app
Rack::Handler::Thin.run LoggingMiddleware.new(app)