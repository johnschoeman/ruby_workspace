class Mailer
  def self.deliver(&block)
    mail = MailBuilder.new(&block).mail
    mail.send_mail
  end

  Mail = Struct.new(:from, :to, :subject, :body) do
    def send_mail
      fib(30)
      puts "Email from : #{from}"
      puts "Email to   : #{to}"
      puts "Subject    : #{subject}"
      puts "Body       : #{body}"
    end

    def fib(n)
      n < 2 ? n : fib(n-1) + fib(n-2)
    end
  end
  
  class MailBuilder
    def initialize(&block)
      @mail = Mail.new
      instance_eval(&block)
    end
    
    attr_reader :mail
    
    %w(from to subject body).each do |m|
      define_method(m) do |val|
        @mail.send("#{m}=", val)
      end
    end
  end
end

require 'benchmark'

POOL_SIZE = 10

jobs = Queue.new

100.times { |i| jobs.push i }
count = 0
workers = (POOL_SIZE).times.map do |i|
  Thread.new do
    begin
      pool_id = i
      while x = jobs.pop(true)
        count += 1
        puts "pool_id: #{pool_id}: #{count}"
        sleep(0.1)
        # Mailer.deliver do
        #   from "eki"
        #   to "jsk"
        #   subject "Threading and Pooling"
        #   body "some content"
        # end
      end
    rescue ThreadError
    end
  end
end

workers.map do |worker|
  p worker.methods - Object.methods
  worker.join
end