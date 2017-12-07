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

class MailboxHtmlFormatter
  def initialize(mailbox)
    @mailbox = mailbox
  end

  def format
    html = 
  "<html>
    <head>
      <style>
        table {
          border-collapse: collapse;
        }
        td, th {
          border: 1px solid black;
          padding: 1em;
        }
      </style>
    </head>
    <body>
      <h1>#{@mailbox.name}</h1>
      <table>
        <thead>
          <tr>
            <th>Date</th>
            <th>From</th>
            <th>Subject</th>
          </tr>
        </thead>
        <tbody>
          #{table_rows(@mailbox.emails)}
        </tbody>
      </table>
    </body>
  </html>"

    return html
  end

  def table_rows(emails)
    emails.map { |email| table_row(email) }.join("\n")
  end

  def table_row(email)
    %(            <tr>
            <td>#{email.date}</td>
            <td>#{email.from}</td>
            <td>#{email.subject}</td>
          </tr>)
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

store = EmailsCsvStore.new('emails.csv')
emails = store.read
mailbox = Mailbox.new("Ruby Study Group", emails)
formatter = MailboxHtmlFormatter.new(mailbox)

puts formatter.format