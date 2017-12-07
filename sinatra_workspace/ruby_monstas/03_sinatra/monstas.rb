require 'sinatra'
require 'sinatra/reloader'
require 'erb'

use Rack::MethodOverride

enable :sessions

get '/monstas/:name' do
  ERB.new('<h1>hello <%= params[:name] %></h1>').result(binding)
end

get '/test/:name' do
  erb "<h1>test/ <%= name %></h1>", locals: params
end

get '/layout/:name' do
  template = "<h1>Hello <%= name %></h1>"
  layout = "<html><body><%= yield %></body></html>"
  erb template, { locals: params, layout: layout}
end

get '/views/:name' do
  erb :monstas, { locals: params }
end

get '/localvariables/:name' do
  @name = params[:name]
  erb :monstas
end

get '/form' do
  @name = params["name"]
  @message = session.delete(:message)
  @names = read_names('names.txt')
  erb :form
end

post '/form' do
  @name = params["name"]
  @names = read_names('names.txt')
  validator = NameValidator.new(@name, @names)

  if validator.valid?
    save_name('names.txt', @name)
    session[:message] = "Successfully saved #{@name}"
    redirect "/form?name=#{@name}"
  else
    @message = validator.message
    erb :form
  end

end

class NameValidator
  def initialize(name, names)
    @name = name.to_s
    @names = names
  end

  def valid?
    validate
    @message.nil?
  end

  def message
    @message
  end

  private

  def validate
    if @name.empty?
      @message = "A name is needed"
    elsif @names.include?(@name)
      @message = "name already logged"
    end
  end
end

def save_name(filename, string)
  File.open(filename, 'a+') do |file|
    file.puts(string)
  end
end

def read_names(filename)
  return [] unless File.exists?(filename)
  File.read(filename).split("\n")
end