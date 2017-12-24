threads = []

10.times {
  threads << Thread.new { puts 1}
}

threads.each(&:join)