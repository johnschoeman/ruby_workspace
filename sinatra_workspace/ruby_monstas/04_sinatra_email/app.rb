require 'sinatra'
require 'sinatra/reloader'

require_relative 'email_util'

get '/emails' do
  store = EmailsCsvStore.new('emails.csv')
  @emails = store.read
  @mailbox_name = "My Man"
  erb :mailbox
end