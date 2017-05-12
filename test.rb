class String
  def is_number?
    true if Float(self) rescue false
  end
end

t = "(0(5(6()())(14()(9()())))(7(1()())(23()())))"

arr = []

t.size.times do |x|
  if t[x].is_number? then
    if t[x-1].is_number? then
      next
    end
    temp = x
    4.times do
      temp += 1
      if !t[temp].is_number? then
        arr << t[x..temp-1]
        break
      end
    end
  else
    arr << t[x]
  end
end

p arr
