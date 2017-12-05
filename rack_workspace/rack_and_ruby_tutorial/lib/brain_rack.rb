require File.join(File.dirname(__FILE__), 'router.rb')

class BrainRack
  attr_reader :router

  def initialize
    @router = Router.new
  end
end

# require 'rack'
# require_relative 'controller'

# Rack::Handler::WEBrick.run(
#   RequestController.new,
#   :Port => 9000
# )
