def fact(n)
  return 1 if n <= 1
  n * fact(n-1)
end

fact(4)
#=> 4 * fact(3)
#=> 4 * ( 3 * fact(2) )
#=> 4 * ( 3 * ( 2 * fact(1) ) )
#=> 4 * ( 3 * ( 2 * 1 ) )
#=> 4 * ( 3 * 2 )
#=> 4 * 6
#=> 24

def fact(n, acc=1)
  return acc if n <= 1
  fact(n-1, n*acc)
end

fact(4)
#=> fact(4, 1)
#=> fact(3, 4)
#=> fact(2, 12)
#=> fact(1, 24)
#=> 24

RubyVM::InstructionSequence.compile_option = {
  tailcall_optimization: true,
  trace_instruction: false
}

require './fact.rb'

fact(1000)

class Calculator
  extend TailCallOptimization

  tail_recursive def fact(n)
    # ...
  end
end

require 'method_source'

module TailCallOptimization
  def tail_recursive(name)
    fn = instance_method(name)

    RubyVM::InstructionSequence.compile_option = {
      tailcall_optimization: true,
      trace_instruction: false
    }

    RubyVM::InstructionSequence.new(<<-EOS).eval
      class #{to_s}
        #{fn.source}
      end
    EOS
  end
end