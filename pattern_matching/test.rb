require 'json'

class PatternMatchTester
  def initialize(data)
    @response = data
  end

  # rubocop:disable Metrics/LineLength
  #
  # InfluxDB returns a json formated resonse as string
  #
  # if there are hits from the count_query, a result will look like:
  # "{\"results\":[{\"statement_id\":0,\"series\":[{\"name\":\"Vorro Hits\",\"tags\":{\"mds_npi\":\"123\"},\"columns\":[\"time\",\"count\"],\"values\":[[\"2018-07-19T18:50:04.640075045Z\",189]]}]}]}"
  #
  # if there are no hits, the reslut will look like:
  # "{\"results\":[{\"statement_id\":0}]}"
  #
  # rubocop:enable Metrics/LineLength

  def extract_npi_data_from_response
    extract_data_as_hash
  end

  def extract_data_as_hash
    series.
      map { |single_series| extract_single_npi_data(single_series) }.
      map { |npi_data| [npi_data[:npi], npi_data] }.
      to_h
  end

  def extract_single_npi_data(single_series)
    {
      npi: get_npi_from_series(single_series),
      count: get_count_from_series(single_series),
      duration: @duration
    }
  end

  # rubocop:disable Metrics/LineLength
  # {"name"=>"Vorro Hits", "tags"=>{"mds_npi"=>"121"}, "columns"=>["time", "count"], "values"=>[["2018-07-29T17:52:46.177038916Z", 0], ["2018-07-29T17:52:46.177038916Z", 20]}
  # rubocop:enable Metrics/LineLength
  def get_npi_from_series(series)
    series.dig("tags", "mds_npi")
  end

  def get_count_from_series(series)
    series.dig("values").map(&:last).max
  end

  def series
    @_series ||= JSON.parse(@response).dig("results", 0, "series")
  end
end

data =
  "{\"results\":[{\"statement_id\":0,\"series\":[{\"name\":\"Vorro Hits\",\"tags\":{\"mds_npi\":\"123\"},\"columns\":[\"time\",\"count\"],\"values\":[[\"2018-07-19T18:50:04.640075045Z\",189]]}]}]}"

service = PatternMatchTester.new(data)
result = service.extract_npi_data_from_response
p result
p result == {"123"=>{:npi=>"123", :count=>189, :duration=>nil}}
