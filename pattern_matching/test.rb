require 'json'

class ExtractData
  def initialize(data)
    @response = data
  end

  def self.call(data)
    new(data).extract_data_as_hash
  end


  def extract_data_as_hash
    case JSON.parse(@response, symbolize_names: true)
    in {results: [ { statement_id: id, series: [ { name: series_one_name, tags: { tag_name: tag_one }, values: [*_rest_one, [_, value_one]] }, { name: series_two_name, tags: { tag_name: tag_two }, values: [*_rest_two, [_, value_two]] } ] } ] } 
    {
      "#{tag_one}": {
      tag: tag_one,
      count: value_one,
    },
      "#{tag_two}": {
      tag: tag_two,
      count: value_two
      }
    }
    end
  end

  def self.extract(data)
    data.dig(:foo, 0, :bar, 1)
  end

  def self.pm_extract(data)
    case data
    in { foo: [{ bar: [_, value]}, *_rest] }
      value
    end
  end
end

data =
  "{\"results\":[{\"statement_id\":0,\"series\":
[
  {\"name\":\"SeriesOne\",\"tags\":{\"tag_name\":\"123\"},\"columns\":[\"time\",\"count\"],\"values\":[
  [\"2018-07-19T18:50:04.640075045Z\",1],
  [\"2018-07-19T18:50:05.640075045Z\",2],
  [\"2018-07-19T18:50:06.640075045Z\",3]]
  },
  {\"name\":\"SeriesTwo\",\"tags\":{\"tag_name\":\"456\"},\"columns\":[\"time\",\"count\"],\"values\":[[\"2018-07-19T18:50:04.640075045Z\",189]
  ]}
]

}]}"

# result = ExtractData.call(data)
# p result
# p result == {"123"=>{:tag=>"123", :count=>3}, "456"=>{:tag=>"456", :count=>189}}

data = { foo: [{ bar: [0, 1]}, {}] }
ExtractData.extract(data)
ExtractData.pm_extract(data)

