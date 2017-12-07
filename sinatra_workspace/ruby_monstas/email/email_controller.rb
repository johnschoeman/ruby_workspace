require 'erb'

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

class MailboxErbRenderer
  def initialize(mailbox, template_file)
    @mailbox = mailbox
    @template = File.read(template_file)
  end

  def render
    emails = @mailbox.emails
    name = @mailbox.name
    ERB.new(@template).result(binding)
  end
end

emails = [
  Email.new("Homework this week", date: "2017-12-01", from: "Ferdous"),
  Email.new("Keep on coding! :)", date: "2014-12-01", from: "Dajana"),
  Email.new("Re: Homework this week", date: "2014-12-02", from: "Ariane")
]
mailbox = Mailbox.new("The best", emails)
renderer = MailboxErbRenderer.new(mailbox, "mailbox.erb")
html = renderer.render

puts html
