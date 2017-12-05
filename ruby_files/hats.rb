t = Array.new(100,0)

(0..99).each do |x|
  (0..99).each do |y|
    if (y+1)%(x+1) == 0
      if t[y] == 0
        t[y] = 1
      else
        t[y] = 0
      end
    end
  end
end

(0..99).each do |x|
  if t[x] == 1
    puts "Cat " + (x+1).to_s + " is in a hat."
  end
end

p "Cheers and thank you!"
