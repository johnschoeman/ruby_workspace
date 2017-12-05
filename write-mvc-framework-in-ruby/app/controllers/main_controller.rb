class MainController < Controller
  def index
    @test = "some test text here"
    @arr = %w(one two three)
  end
end