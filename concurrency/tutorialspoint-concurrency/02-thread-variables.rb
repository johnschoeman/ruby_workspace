count = 0
threads = []

10.times do 
  threads << Thread.new do
    sleep(rand(0)/10.0)
    Thread.current["mycount"] = count
    count += 1
  end
end

threads.each do |t|
  t.join
  puts t, t["mycount"]
end
puts "count = #{count}"