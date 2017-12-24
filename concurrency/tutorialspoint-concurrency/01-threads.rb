def func1
  i = 0
  while i < 3
    puts "func1 at: #{Time.now}"
    sleep(2)
    i += 1
  end
end

def func2
  i = 0
  while i < 3
    puts "func2 at: #{Time.now}"
    sleep(1)
    i += 1
  end
end

puts "Started at #{Time.now}"
t1 = Thread.new { func1() }
t2 = Thread.new { func2() }
t1.join
t2.join
puts "End at #{Time.now}"