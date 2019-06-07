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
    in {
      results: [
        {
          statement_id: id,
          series: [
            { 
              name: series_one_name,
              tags: { tag_name: tag_one },
              values: [*rest_one, [_, value_one]]
            },
            {
              name: series_two_name,
              tags: { tag_name: tag_two },
              values: [*rest_two, [_, value_two]]
            }
          ]
        }
      ]
    }

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

  def extract_tag_one_data(single_series)
    {
      tag: get_tag_one_from_series(single_series),
      count: get_count_from_series(single_series),
    }
  end

  def get_tag_one_from_series(series)
    case series
    in { tags: { tag_one: tag }}
      tag
    end
  end

  def get_count_from_series(series)
    case series
    in { values: values }
      values.map(&:last).max
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

result = ExtractData.call(data)
p result
p result == {"123"=>{:tag=>"123", :count=>3}, "456"=>{:tag=>"456", :count=>189}}
