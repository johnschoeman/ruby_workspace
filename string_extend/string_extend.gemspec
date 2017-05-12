require 'rubygems'

spec = Gem::Specification.new do |s|
  s.name = 'string_extend'
  s.version = '0.0.1'
  s.summary = "StringExtend adds useful features to the String Class"
  s.files = Dir.glob("**/**/**")
  s.test_files = Dir.glob("test/*_test.rb")
  s.author = "John Schoeman"
  s.email = "your-email-address@gmail.com"
  s.has_rdoc = false
  s.required_ruby_version = '> 1.8.2'
end
