Thread.abort_on_exception = true
t = Thread.new { raise 'hell' }
t.join