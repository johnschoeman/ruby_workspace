require 'sinatra'
require 'sinatra/reloader'

require_relative 'utils/validators_util'
require_relative 'utils/file_io_util'

enable :sessions

get '/members' do
  @message = session.delete(:message)
  @members = File.read('members.txt').split("\n")
  erb :index
end

get '/members/new' do
  erb :new
end

get '/members/:name' do
  @message = session.delete(:message)
  @member = params["name"]
  erb :show
end

post '/members' do
  @name = params["name"]
  @names = read_names('members.txt')
  validator = NameValidator.new(@name, @names)

  if validator.valid?
    save_name('members.txt', @name)
    session[:message] = "Successfully saved #{@name}"
    redirect "/members/#{@name}"
  else
    @message = validator.message
    erb :new
  end
end

get '/members/:name/edit' do
  @name = params[:name]
  erb :edit
end

put '/members/:name/edit' do
  @name = params["name"]
  @new_name = params["new_name"]
  @names = read_names('members.txt')
  validator = NameValidator.new(@new_name, @names)

  if validator.valid?
    update_name('members.txt', @name, @new_name)
    session[:message] = "Successfully updated #{@name} to #{@new_name}"
    redirect "/members/#{@new_name}"
  else
    @message = validator.message
    erb :edit
  end
end

get '/members/:name/delete' do
  @name = params[:name]
  erb :destroy
end

delete '/members/:name' do
  @name = params[:name]
  remove_name('members.txt', @name)
  session[:message] = "#{@name} has been deleted"
  redirect '/members'
end
