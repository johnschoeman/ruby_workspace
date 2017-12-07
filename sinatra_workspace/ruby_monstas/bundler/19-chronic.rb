require 'chronic'

time = Chronic.parse('tomorrow')
p time.class
p time
p time.month