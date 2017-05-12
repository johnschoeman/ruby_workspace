a = Array.new(100,0)

a.each_index do |idx|
  a.each_index do |num|
    if (num+1) % (idx+1) == 0
      if a[num] == 0
        a[num] = 1
      else
        a[num] = 0
      end
    end
  end
end

p a


b = Array.new(ARGV[0].to_i,0)

ARGV[0].to_i.times do |idx|
  ARGV[0].to_i.times do |cat|
    if (cat+1) % (idx+1) == 0
      b[cat] += 1
    end
  end
end

p b
