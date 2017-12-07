class Email
  attr_reader :subject

  def initialize(subject, email_headers)
    @subject = subject
    @email_headers = email_headers
  end

  def date
    @email_headers[:date]
  end

  def from
    @email_headers[:from]
  end
end

class Mailbox
  attr_reader :name, :emails

  def initialize(name, emails)
    @name = name
    @emails = emails
  end
end

class MailboxTextFormatter
  def initialize(mailbox)
    @mailbox = mailbox
  end

  def format
    lines = [
      separator,
      format_row(["Date", "From", "Subject"]),
      separator,
      rows.collect { |row| format_row(row) },
      separator,
    ]
    lines.join("\n")
  end

  def separator
    "+#{column_widths.map { |width| '-' * (width + 2) }.join("+")}+"
  end

  def format_row(row)
    cells = 0.upto(row.length - 1).map do |ix|
      row[ix].ljust(column_widths[ix])
    end
    "| #{cells.join(" | ")} |"
  end

  def emails
    @mailbox.emails
  end

  def column_widths
    columns.map { |column| column.max_by { |cell| cell.length }.length }
  end

  def columns
    rows.transpose
  end

  def rows
    emails.collect { |email| [email.date, email.from, email.subject] }
  end
end

email = Email.new("Keep on coding! :)", { :date => "2014-12-01", :from => "Ferdous" })

puts "Date:    #{email.date}"
puts "From:    #{email.from}"
puts "Subject: #{email.subject}"

emails = [
  Email.new("Homework this week", { :date => "2014-12-01", :from => "Ferdous" }),
  Email.new("Keep on coding! :)", { :date => "2014-12-01", :from => "Dajana" }),
  Email.new("Re: Homework this week", { :date => "2014-12-02", :from => "Ariane" })
]
mailbox = Mailbox.new("Ruby Study Group", emails)

mailbox.emails.each do |email|
  puts "Date:    #{email.date}"
  puts "From:    #{email.from}"
  puts "Subject: #{email.subject}"
  puts
end

emails = [
  Email.new("Homework this week", { :date => "2014-12-01", :from => "Ferdous" }),
  Email.new("Keep on coding! :)", { :date => "2014-12-01", :from => "Dajana" }),
  Email.new("Re: Homework this week", { :date => "2014-12-02", :from => "Ariane" })
]
mailbox = Mailbox.new("Ruby Study Group", emails)
formatter = MailboxTextFormatter.new(mailbox)

puts formatter.format