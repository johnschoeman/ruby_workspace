class String
  def vowels
    self.scan(/[aeiou]/i)
  end
end

p "this is a test".vowels
