require 'celluloid/current'

class Worker
  include Celluloid

  def process_page(url)
    puts self
    puts url
  end
end

pages_to_crawl = %w(index about contact products create new update edit)

worker_pool = Worker.pool(size: 3)

pages_to_crawl.each do |page|
  worker_pool.process_page(page)
end