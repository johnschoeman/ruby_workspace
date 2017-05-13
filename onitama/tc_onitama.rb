require_relative "onitama"
require "test/unit"

class TestOnitama < Test::Unit::TestCase

  def setup
    @game = Onitama.new()
  end

  def teardown

  end

  def test_setup_players
    assert_not_nil(@game.players)
  end

end
