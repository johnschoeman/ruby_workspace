require "json"

data = '{
  "emails": [
    {
      "subject": "Hi there, Ruby Monstas!",
      "date": "2015-01-02",
      "from": "Ferdous"
    },
    {
      "subject": "Keep on coding!",
      "date": "2015-01-03",
      "from": "Dajana"
    }
  ]
}'
data = JSON.parse(data)

p data.keys