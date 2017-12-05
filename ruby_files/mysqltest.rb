require 'rubygems'
require 'mysql'

db = Mysql.connect('localhost', 'root', '', 'test')

db.query("INSERT INTO people (name, age) VALUES('Chris', 25)")

begin
  query = db.query('SELECT * FROM people')

  puts "There were #{query.num_rows} rows returned"

  query.each_hash do |h|
    puts h.inspect
  end
rescue
  puts db.errno
  puts db.error
end

db.close
