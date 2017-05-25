class Player
  attr_reader :name, :color
  attr_accessor :pieces, :pieces_lost, :cards
  def initialize(name, color)
    @name = name
    @color = color
    @pieces = {
      1 => Piece.new(self, 1),
      2 => Piece.new(self, 2),
      3 => Piece.new(self, 3),
      4 => Piece.new(self, 4),
      5 => Piece.new(self, 5)
    }
    @pieces_lost = []
    @cards = {}
  end

  def remove_piece(piece)
    puts "#{@name} has lost #{piece.print_piece}"
    @pieces_lost << piece
    @pieces.delete(piece)
  end

  def get_piece_by_num(num)
    @pieces[num]
  end

  def get_card_by_num(num)
    @cards[num]
  end

  def get_piece_by_name(name)
    case name
      when "1","2","3","4"
        return @pieces[name.to_i]
      when "s","S"
        return @pieces[0]
      else
        return choice_error(name)
    end
  end

  def available_pieces
    res = {}
    @pieces.each { |k, piece| res[k] = piece.print_piece }
    res
  end

  def available_cards
    res = {}
    @cards.each {|k, card| res[k] = card.print_card}
    res
  end

  def available_cards_with_moves(piece)
    pos = piece.position
    res = {}
    @cards.each {|k, card| res[k] = card.print_card + ": #{piece.available_moves_as_array(card)}"}
    res
  end

  def print_cards
    res = "\t#{@name}'s Cards: \n"
    @cards.each {|k, card| res += "\t{#{card.card_name}: #{card.moves}} \n"}
    puts res
  end

  def choice_error(choice)
    "#{choice} is not a vaild choice"
  end
end

class AI < Player
end
