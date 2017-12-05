# require 'rack'
# require 'bundler/setup'
# Bundler.setup

require File.join(File.dirname(__FILE__),'lib', 'brain_rack')
require File.join(File.dirname(__FILE__),'lib', 'controller')

BrainRackApplication = BrainRack.new

require File.join(File.dirname(__FILE__), 'config', 'routes')

class LoggingMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    before = Time.now.to_i
    status, headers, body = @app.call(env)
    after = Time.now.to_i
    log_message = env.to_s

    [status, headers, body << log_message]
  end
end

use LoggingMiddleware
run RequestController.new