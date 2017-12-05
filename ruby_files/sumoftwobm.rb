require 'benchmark'
require 'set'

a = (1..10000000).map{ rand*3000 }.map { |x| x.round }
b = (1..10000000).map{ rand*3000 }.map { |x| x.round }
v = 3000*rand
v = v.round

def sumOfTwoA a, b, v
    a = a.uniq.sort
    b = b.uniq.sort
    a.map!{|x| v-x}
    if a & b == []
        return false
    else
        return true
    end
end

def sumOfTwoB(a, b, v)
    a = a.to_set
    b = b.to_set
    a.each do |x|
        return true if b.include?(v-x)
    end
    false
end

def sumOfTwoC(a, b, v)
    a.uniq!
    b.uniq!
    a.each do |x|
        return true if b.include?(v-x)
    end
    false
end

Benchmark.bm do |x|
  x.report("A:") { sumOfTwoA(a,b,v) }
  x.report("B:") { sumOfTwoB(a,b,v) }
  x.report("C:") { sumOfTwoC(a,b,v) }
end
