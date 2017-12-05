require 'rubygems'
require 'bundler'
Bundler.require

require_relative 'app'

class LoggingMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    puts "##############"
    puts '---respose headers start---'
    p headers
    puts '---response headers end---'
    puts "---respose body start---"
    p body
    puts "---response body end---"
    puts "##############"
    [status, headers, body]
  end
end

use LoggingMiddleware
run App.new