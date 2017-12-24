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

require "benchmark"
require "celluloid"

class MailWorker
  include Celluloid

  def send_email(id)
    Mailer.deliver do 
      from    "eki_#{id}@eqbalq.com"
      to      "jill_#{id}@example.com"
      subject "Threading and Forking (#{id})"
      body    "Some content"
    end       
  end
end

mailer_pool = MailWorker.pool(size: 10)

10_000.times do |i|
  mailer_pool.async.send_email(i)
end