foo = { a: [0, 1, 2, 3], b: { c: 3, d: 4 }, e: 1 }

class Bar
  attr_reader :a, :b

  def initialize(a, b)
    @a = a
    @b = b
  end

  def deconstruct
    [a, b]
  end
end

bar = Bar.new(1, 3)

baz = { "results" => [{ foo: "bar" }] }

case baz
in { "results" => foo }
  p foo
in {a: "Alice", children: [{name: "Bob", age: age}]}
in { e: 5, a: [0, _], b: { c: z } } # | { e: 1, b: x, a: y }
  p x
  p y
in { e: y }
  p y
end

case bar
in Bar[1, b]
  p b
end
