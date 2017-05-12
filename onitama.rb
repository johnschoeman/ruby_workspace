# A ruby file that plays the boardgame Onitama.
#
# Conventions: white is at top of board.

class Onitama

  @@card_list = [ :tiger, :dragon, :crab, :elephant, :monkey,
                  :mantis, :crane, :boar, :frog, :rabbit,
                  :goose, :rooster, :horse, :ox, :eel, :cobra]

  attr_reader :board, :players, :cards

  def initialize
    @players = [Player.new("player1","white"), Player.new("player2","black")]
    @board = Board.new
    @cards = []
    @current_player = 0
  end

  def play
    setup_game
    game_start
    play_next_turn
    @board.print_board
  end

  def setup_game
    setup_pieces
    setup_cards
  end

  def setup_pieces
    @board.place_piece(@players[0].get_piece_by_num(0),[0,2])
    @board.place_piece(@players[1].get_piece_by_num(0),[4,2])
    (1..4).each do |n|
      if n==1||n==2
        @board.place_piece(@players[0].get_piece_by_num(n),[0,n-1])
        @board.place_piece(@players[1].get_piece_by_num(n),[4,n-1])
      else
        @board.place_piece(@players[0].get_piece_by_num(n),[0,n])
        @board.place_piece(@players[1].get_piece_by_num(n),[4,n])
      end
    end
  end

  def setup_cards
    while @cards.length < 5
      card = random_card
      @cards << card if !@cards.any? {|c| c.card_name == card.card_name }
    end
    @players[0].cards << @cards.shift << @cards.shift
    @players[1].cards << @cards.shift << @cards.shift
    @board.card << @cards.shift
  end

  def random_card
    Card.new(@@card_list[rand(0..15)])
  end

  def game_start
    puts "Welcome to Onitama!"
    puts "Type 'cards' to you your available cards"
    puts "Type 'exit' to exit"
    puts "Type 'help' for help"
    @board.print_board
  end

  def play_next_turn
    #need to write code to handle bad choices here.
    while true
      puts "#{@players[@current_player].name}, it's your turn!"
      @board.print_board
      choice_piece = get_piece_choice
      choice_card = get_card_choice
      choice_move = get_move_choice(choice_piece)
      puts "You have chosen to move #{choice_piece.print_piece} to #{choice_move} continue? (y/n)"
      input = gets.chomp
      if input.downcase == "y"
        @board.move_piece(choice_piece, choice_move)
      elsif input == "exit"
        break
      else
        next
      end
      player_switch
    end

  end

  def get_piece_choice
    puts "Chose which piece you'd like to move: "
    puts "Availabe Pieces: #{@players[@current_player].available_pieces}"
    input = gets.chomp
    res = @players[@current_player].get_piece_by_name(input)
    puts "You have chosen #{res.print_piece}"
    return res
  end

  def get_card_choice
    puts "Chose which card to base your move on: #{@players[@current_player].print_cards}"
  end

  def get_move_choice(choice_piece)
    puts "Chose which spot to move #{choice_piece.print_piece} to:"
    puts "Current Position: #{choice_piece.position}"
    puts "Availabe Moves: #{choice_piece.available_moves}"
    input = gets.chomp
    res = choice_piece.available_moves[input.to_i]
    puts "You have chosen #{res}"
    return res
  end

  def isMoveValid?(piece,to_pos)

  end

  def player_switch
    @current_player = (@current_player + 1) % 2
  end

  def game_end
    @board.print_board
    if @board.winner
      puts "Game Over! #{@board.winner} has won!"
    else
      puts "Exiting Game"
    end
  end

  def input_error(input)
    return "#{input} is not a valid input"
  end
end

class Board
  attr_reader :board
  attr_accessor :card
  def initialize
    @board = Array.new(5){Array.new(5){Piece.new()}}
    @card = []
  end

  def print_board
    puts "  |  0   1   2   3   4  |  "
    puts "-"*27
    @board.each_with_index do |row, i|
      temp = "#{i} | "
      row.each do |col|
        temp += "#{col.print_piece} "
      end
      temp += "| #{i}"
      puts temp
    end
    puts "-"*27
    puts "  |  0   1   2   3   4  |  "
  end

  def place_piece(piece,to_pos)
    @board[to_pos[0]][to_pos[1]] = piece
    piece.position = to_pos
  end

  def remove_piece(pos)
    @board[pos[0]][pos[1]] = Piece.new()
  end

  def move_piece(piece,to_pos)
    remove_piece(piece.position)
    place_piece(piece,to_pos)
  end

  def winner

  end

  def place_error(pos)

  end

end

class Card

  @@card_dic = {
    tiger:    [[2,0],[-1,0]],
    dragon:   [[0,-2],[0,2],[-1,1],[-1,-1]],
    crab:     [[1,0],[0,2],[0,-2]],
    elephant: [[1,-1],[1,1],[0,-1],[0,1]],
    monkey:   [[1,-1],[1,1],[-1,1],[-1,-1]],
    mantis:   [[1,-1],[1,1],[-1,0]],
    crane:    [[1,0],[-1,1],[-1,-1]],
    boar:     [[1,0],[0,-1],[0,1]],
    frog:     [[0,-2],[1,-1],[-1,1]],
    rabbit:   [[-1,-1],[1,1],[0,2]],
    goose:    [[1,-1],[0,-1],[0,1],[-1,1]],
    rooster:  [[-1,-1],[0,-1],[0,1],[1,-1]],
    horse:    [[1,0],[0,-1],[-1,0]],
    ox:       [[1,0],[0,1],[-1,0]],
    eel:      [[1,-1],[0,1],[-1,-1]],
    cobra:    [[0,-1],[1,1],[1,-1]]
  }

  attr_reader :card_name, :moves

  def initialize(card_name)
    @card_name = card_name
    @moves = @@card_dic[@card_name]
  end
end

class Piece
  attr_reader :owner, :color, :number
  attr_accessor :position
  #if @number == 0 the piece is a Sensei(King Piece)
  #if @number is 1,2,3 or 4 the piece is a pawn
  def initialize(owner=nil, number=0, color="white")
    @owner = owner
    @color = @owner.color if @owner
    @number = number
  end

  def print_piece
    return "---" unless @owner
    if @color == "white"
      return @number == 0 ? ">S<" : ">#{@number}<"
    else
      return @number == 0 ? "<S>" : "<#{@number}>"
    end
  end

  def print_name
    return @number == 0 ? "S" : "#{@number}"
  end

  def available_moves

  end

  #returns valid moves of piece at current position, selects only those that fall onto board.
  def get_valid_moves(card)
    if @color == "white"
      res = card.moves.map { |move| [@position[0] + move[0], @position[1] + move[1]] }
      return res.select { |move| (0..4).include?(move[0]) && (0..4).include?(move[1]) }
    else
      res = card.moves.map { |move| [@position[0] - move[0], @position[1] - move[1]] }
      return res.select { |move| (0..4).include?(move[0]) && (0..4).include?(move[1]) }
    end
  end

  def choice_error
    "Not a valid choice"
  end
end

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
      0 => Piece.new(self, 0)
    }
    @pieces_lost = []
    @cards = []
  end

  def get_piece_by_num(num)
    @pieces[num]
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
    res = []
    @pieces.each {|_,v| res << v.print_name}
    res
  end

  def print_cards
    res = "Cards: "
    @cards.each {|card| res += "#{card.card_name}: #{card.moves}"}
    puts res
  end

  def choice_error(choice)
    "#{choice} is not a vaild choice"
  end
end

class AI < Player
end

game = Onitama.new
game.play
