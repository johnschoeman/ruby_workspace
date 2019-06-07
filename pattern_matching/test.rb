require 'json'

class ExtractData
  def initialize(data)
    @response = data
  end

  def self.call(data)
    new(data).extract_data_as_hash
  end

  def extract_data_as_hash
    series.
      map { |single_series| extract_tag_one_data(single_series) }.
      map { |tag_data| [tag_data[:tag], tag_data] }.
      to_h
  end

  def extract_tag_one_data(single_series)
    {
      tag: get_tag_one_from_series(single_series),
      count: get_count_from_series(single_series),
    }
  end

  def get_tag_one_from_series(series)
    series.dig("tags", "tag_one")
  end

  def get_count_from_series(series)
    series.dig("values").map(&:last).max
  end

  def series
    @_series ||= JSON.parse(@response).dig("results", 0, "series")
  end
end

data =
  "{\"results\":[{\"statement_id\":0,\"series\":[
{\"name\":\"SeriesOne\",\"tags\":{\"tag_one\":\"123\"},\"columns\":[\"time\",\"count\"],\"values\":[
[\"2018-07-19T18:50:04.640075045Z\",1],
[\"2018-07-19T18:50:05.640075045Z\",2],
[\"2018-07-19T18:50:06.640075045Z\",3]
]},
{\"name\":\"SeriesTwo\",\"tags\":{\"tag_one\":\"456\"},\"columns\":[\"time\",\"count\"],\"values\":[[\"2018-07-19T18:50:04.640075045Z\",189]]}

]}]}"

result = ExtractData.call(data)
p result
p result == {"123"=>{:tag=>"123", :count=>189}, "456"=>{:tag=>"456", :count=>189}}
