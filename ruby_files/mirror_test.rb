require_relative 'mirror'
require_relative 'isprime'

a = 2
  (2..a).each do |b|
    x = a.to_b(b).reflect
    p x
    p x.to_i
    x.isprime?
  end

num = Array.new()
prime = Array.new()
(2..19).each do |x|
  num << x
  prime << x.to_b(10).isprimelist
end

(0..17).each do |x|
  p num[x]
  p prime[x]
end

p num
p prime
