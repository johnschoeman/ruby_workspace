require 'sinatra'
require 'sinatra/reloader'

set :number, rand(100)

def check_guess(guess)
  if guess > settings.number
    return "Guess is too high"
  elsif guess < settings.number
    return "Guess is too low"
  end
  "Correct! the secret number is: #{settings.number}"
end

get '/' do
  guess = params["guess"]
  message = check_guess(guess.to_i)
  erb :index, locals: {number: settings.number, message: message}
end