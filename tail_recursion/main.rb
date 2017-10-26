# You need to require tail recursion in ruby.
RubyVM::InstructionSequence.compile_option = {
  tailcall_optimization: true,
  trace_instruction: false
}

require './fact.rb'

p fact(1000)
p tail_fact(1000)