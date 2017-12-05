class Fixnum

  def isprime?
    root = (self**(0.5)).to_i
    (2..root).each do |x|
      if self%x == 0
        puts false
        return false
      end
    end
    puts true
    return true
  end

  def isprime2?
    ones = "1"*(self)
    if ones != /^("11"+)\"1"+$/
      puts "true"
      return true
    else
      return false
    end
  end
end
