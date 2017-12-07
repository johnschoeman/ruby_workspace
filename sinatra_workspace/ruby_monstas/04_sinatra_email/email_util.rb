require 'csv'

class Email
  attr_reader :subject

  def initialize(subject, headers)
    @subject = subject
    @headers = headers
  end

  def date
    @headers[:date]
  end

  def from
    @headers[:from]
  end
end

class Mailbox
  attr_reader :name, :emails

  def initialize(name, emails)
    @name = name
    @emails = emails
  end
end

class EmailsCsvStore
  def initialize(filename)
    @csv = CSV.new(File.read(filename), headers: true)
  end

  def read
    emails = []
    @csv.map do |row|
      Email.new(row['Subject'], {from: row['From'], date: row['Date']})
    end
  end
end
