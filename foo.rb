# for {
#   year <- start_year..end_year
#   month <- 1..12
#   date = Date.new(year, month, 1)
#   if date >= start_date && <= end_date
# } yield date


def dates(start_date, end_date)
  (start_date.year..end_date.year).map do |year|
    (1..12).filter do |month|
      date = Time.new(year, month, 1)
      date >= start_date && date <= end_date
    end.flat_map do |month|
      Time.new(year, month, 1)
    end
  end
end

puts dates(Time.new(2017, 9, 1), Time.new(2019, 3, 1))
