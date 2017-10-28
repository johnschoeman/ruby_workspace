require File.join(File.dirname(FILE), '..', '..', 'lib', 'response')

class BaseController
  attr_reader :env

  def initialize env
    @env = env
  end
end