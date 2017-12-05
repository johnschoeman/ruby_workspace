require_relative 'bot'

bot = Bot.new(:name => ARGV[0], :data_file => ARGV[1])
f = File.new(ARGV[2])
user_lines = f.readlines

puts "#{bot.name} says: " + bot.greeting

user_lines.each do |line|
  puts "You say: " + line
  puts "#{bot.name} says: " + bot.response_to(line)
end
