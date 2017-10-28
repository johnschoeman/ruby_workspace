require 'rack'
require 'bundler/setup'
Bundler.setup

require File.join(File.dirname(__FILE__),'lib', 'brain_rack')
# require File.join(File.dirname(__FILE__),'lib', 'controller.rb')
# require_relative 'lib/brain_rack.ru'
require_relative 'lib/controller'

BrainRackApplication = BrainRack.new

require File.join(File.dirname(__FILE__), 'config', 'routes')

run RequestController.new