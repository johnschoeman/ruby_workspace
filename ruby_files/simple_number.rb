class SimpleNumber

  def initialize(n)
    raise unless n.is_a?(Numeric)
    @n = n
  end

  def add(x)
    @n + x
  end

  def multiply(x)
    @n*x
  end

end
