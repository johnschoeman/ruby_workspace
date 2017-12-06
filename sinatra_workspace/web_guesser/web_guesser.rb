require 'sinatra'
require 'sinatra/reloader'

def reset_game!
  @@guess_count = 5
  @@secret_number = rand(100)
end

reset_game!

def check_guess(guess)
  if guess > @@secret_number + 5
    return ["Guess is way too high", 'red']
  elsif guess > @@secret_number
    return ["Guess is too high", '#33AAFF']
  elsif guess < @@secret_number - 5
    return ["Guess is way too low", 'blue'];
  elsif guess < @@secret_number
    return ["Guess is too low", '#AA33AA']
  end
  result = ["Correct! the secret number is: #{@@secret_number}.  The game has been reset.", 'green']
  reset_game!
  result
end

get '/' do
  guess = params["guess"]
  message, background_color = check_guess(guess.to_i) unless guess.nil?
  @@guess_count -= 1
  if @@guess_count == 0
    message = "you've run out of guesses. The correct guess was #{@@secret_number}. The number has been reset"
    reset_game!
  end
  erb :index, locals: {
    number: @@secret_number, 
    message: message, 
    background_color: background_color
  }
end