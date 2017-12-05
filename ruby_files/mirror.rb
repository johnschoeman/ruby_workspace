# Class of numbers which can be of any base.
#* Holds an Array = @digits and a Fixnum = @base such that the sum_of (@digits[i]*(@base**i)) as i goes from 0 to @digits.length equals the value of the Fixnum
#* e.g. [3,2,1] base 4 = 3*(4**0) + 2*(4**1) + 1*(4**2) = 27
#* note that it's backwards from the typical number format to make it fit better with ruby's iterators
class Mirrornum
  #digits is an Array, base is a Fixnum
  attr_accessor :digits, :base

  # Defines a new Mirrornum
  def initialize(digits, base)
    self.digits = digits
    self.base = base
  end

  # Reflect the digits of Mirrornum
  def reflect
    @digits = @digits.reverse
    return self
  end

  # Change given Mirrornum(with a given base) to a new Mirrornum with a new user-inputed base.
  def to_b(base)
    self.to_i.to_b(base)
  end

  # Turns Mirrornum to Fixnum in base 10
  def to_i
    value = 0
    idx = 0
    while idx < @digits.length
      value = value + (@digits[idx.to_i])*(@base**idx)
      idx += 1
    end
    return value
  end

  # Turns Mirrornum into a string with digits in the typical order.
  def read
    @digits.reflect.join
  end

  # Returns true if Mirrornum is prime
  def isprime?
    return self.to_i.isprime?
  end

  # Returns an array of mirrornum in all bases from 2 to its base 10 value
  def baselist
    val = self.to_i
    list = Array.new(val-2,0)
    (2..val).each do |x|
      list[x-2] = self.to_b(x)
    end
    return list
  end

  # Returns an array of mirrornum in all its bases and reflected
  def mirrorlist
    val = self.to_i
    list = Array.new(val-2,0)
    (2..val).each do |x|
      list[x-2] = self.to_b(x).reflect
    end
    return list
  end

  # Returns array of mirrornum.relfect.isprime? for all its bases
  def isprimelist
    mlist = self.mirrorlist
    val = self.to_i
    list = Array.new()
    mlist.each do |x|
      if x.isprime?
        list << 1
      else
        list << 0
      end
    end
    return list
  end



end

# Added stuff to mesh with Mirrornum
class Fixnum

  # Takes Fixnum and puts it in an array form.  e.g. 123 => [1,2,3]
  def to_a
    arr = Array.new
    self.to_s.each_char { |d| arr << d.to_i}
    return arr
  end

  # Reverses a Fixnum, use 'reflect' cause i like it.
  def reflect
    self.to_s.reverse.to_i
  end

  # Function to change a Fixnum into a Mirrornum with a new user-inputed base
  def to_b(base)
    value = self
    degree = 0

    #find degree(higest power of base for leading digit)
    while value / base**(degree) > 1
    degree += 1
    end

    #popluates an array to house coresponding digits.
    digits = Array.new
    idx = 0
    while idx <= degree
    digit = (value / (base**(degree - idx)))
    digits.unshift(digit)
    value = value - (digit*(base**(degree - idx)))
    idx += 1
    end

    #returns a Mrrornum object with value arr based on given base and the base itself
    #*note that the order of arr is reversed from the typical format, so that the index value of the array is the same as the degree vaule of the particular digit at that index.
    return Mirrornum.new(digits, base)
  end

  def isprime?
    root = (self**(0.5)).to_i
    (2..root).each do |x|
      if self%x == 0
        return false
      end
    end
    return true
  end

end

# Added stuff to mesh with Mirrornum
class Array

  # Reverses the array.  using reflect cause i like it
  def reflect
    self.reverse
  end

end
