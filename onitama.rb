#A ruby file that plays the boardgame Onitama.

class Onitama
  attr_reader :board, :players
  def initialize
    @players = [Player.new("player1","white"), Player.new("player2","black")]
    @board = Board.new
    @current_player = 0
  end

  def play
    initialize_pieces
    game_start
    play_next_turn
    #@board.move_piece(@players[@current_player].get_piece(0),[2,2])
    @board.print_board
  end

  def initialize_pieces
    @board.place_piece(@players[0].get_piece(0),[0,2])
    @board.place_piece(@players[1].get_piece(0),[4,2])
    (1..4).each do |n|
      if n==1||n==2
        @board.place_piece(@players[0].get_piece(n),[0,n-1])
        @board.place_piece(@players[1].get_piece(n),[4,n-1])
      else
        @board.place_piece(@players[0].get_piece(n),[0,n])
        @board.place_piece(@players[1].get_piece(n),[4,n])
      end
    end
  end



  def game_start
    puts "Welcome to Onitama!"
    @board.print_board
  end

  def play_next_turn
    puts "#{@players[@current_player].name}, it's your turn!"
    puts "Chose which piece you'd like to move: "
    puts "Availabe Pieces: #{@players[@current_player].available_pieces}"
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
  def initialize
    @board = Array.new(5){Array.new(5){Piece.new()}}
  end

  def print_board
    puts "-"*23
    @board.each do |row|
      temp = "| "
      row.each do |col|
        temp += "#{col.print_piece} "
      end
      temp += "|"
      puts temp
    end
    puts "-"*23
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

end

class Player
  attr_reader :name, :color, :pieces, :pieces_lost, :gamesWon
  def initialize(name, color)
    @name = name
    @color = color
    @gamesWon = 0
    @pieces = []
    (1..4).each {|n| @pieces << Piece.new(self, n)}
    @pieces << Piece.new(self, 0)
    @pieces_lost = []
  end

  def wonAGame
    @gamesWon += 1
  end

  def get_turn_choice(moves)
    puts "enter your choice"
    gets.chomp
  end

  def get_piece(num)
    @pieces.select {|n| n.number == num }[0]
  end

  def available_pieces
    @pieces.map { |piece| piece.print_piece }
  end
end

class AI < Player
  def get_turn_choice(moves)
    moves[rand(0...moves.length)].to_s
  end

end

game = Onitama.new
game.play

s1 = game.players[1].get_piece(0)
s2 = game.players[0].get_piece(0)
game.board.move_piece(s2,[1,1])
game.board.print_board
game.board.move_piece(s1, [2,3])
game.board.print_board
game.board.move_piece(s2, [2,3])
game.board.print_board

# player = Player.new("player1", "white")
# player.pieces.each {|piece| p piece.number}
# p player.get_piece(0).print_piece
# p player.get_piece(1).print_piece
