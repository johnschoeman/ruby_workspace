class TicTacToe

  def initialize
    @players = [Player.new("player1","X"), AI.new("AI","O")]
    @board = Board.new
    @current_player = 0
  end

  def play
    game_start
    play_next_turn
    game_end
  end

  def game_start
    puts "Welcome to Tic Tac Toe!"
    puts "Here is the game board position key: "
    @board.print_board_key
    puts "type: 'exit' to leave game"
    puts "type: 'show' to show board position key"
    puts " "
    @board.print_board
  end

  def play_next_turn
    while (@board.winner == nil && @board.isFull? == false)
      puts "#{@players[@current_player].name}, it's your turn! select a position 1 through 9 "
      p "available_moves: #{@board.available_moves}"
      input = @players[@current_player].get_turn_choice(@board.available_moves)

      case input
      when "1","2","3","4","5","6","7","8","9"
          puts "You have choosen #{input}"
          next unless @board.place_piece(@players[@current_player].mark, input.to_sym)
        when "show"
          @board.print_place_board
          next
        when "exit"
          break
        else
          puts input_error(input)
      end

      @board.print_board
      player_switch
    end
  end

  def player_switch
    @current_player = (@current_player + 1) % 2
  end

  def game_end
    @board.print_board
    if @board.winner
      puts "Game Over! #{@board.winner} has won!"
    elsif @board.isFull?
      puts "Cat's Game, It's a Tie!"
    else
      puts "Exiting Game"
    end
  end

  def input_error(input)
    return "#{input} is not a valid input"
  end
end

class Board

  @@pos_dic = {
    "1": [0,0],
    "2": [0,1],
    "3": [0,2],
    "4": [1,0],
    "5": [1,1],
    "6": [1,2],
    "7": [2,0],
    "8": [2,1],
    "9": [2,2]
  }

  def initialize
    @board = Array.new(3){Array.new(3){"-"}}
  end

  def print_board
    puts "------"
    @board.each do |row|
      temp = ""
      row.each do |col|
        temp += "#{col} "
      end
      puts temp
    end
    puts "------"
  end

  def print_board_key
    puts "-----"
    puts "1 2 3"
    puts "4 5 6"
    puts "7 8 9"
    puts "-----"
  end

  def place_piece(mark,pos)
    pos = @@pos_dic[pos]
    if @board[pos[0]][pos[1]] == "-"
      @board[pos[0]][pos[1]] = mark
    else
      puts place_error(pos)
      return false
    end
  end

  def winner
    @board.each do |row|
      return row[0] if row.uniq.length == 1 && row[0] != "-"
    end
    @board.transpose.each do |col|
      return col[0] if col.uniq.length == 1 && col[0] != "-"
    end
    return @board[0][0] if [@board[0][0],@board[1][1],@board[2][2]].uniq.length == 1 && @board[0][0] != "-"
    return @board[0][2] if [@board[0][2],@board[1][1],@board[2][0]].uniq.length == 1 && @board[0][2] != "-"
    nil
  end

  def isFull?
    @board.flatten.none?{|el| el == "-"}
  end

  def available_moves
    res = []
    @board.flatten.each_with_index { |pos, i| res << i+1 if pos == "-"}
    res
  end

  def place_error(pos)
    return "spot already taken by #{@board[pos[0]][pos[1]]}"
  end

end

class Player
  attr_reader :name, :mark, :gamesWon
  def initialize(name, mark)
    @name = name
    @mark = mark
    @gamesWon = 0
  end

  def wonAGame
    @gamesWon += 1
  end

  def get_turn_choice(moves)
    puts "enter your choice"
    gets.chomp
  end
end

class AI < Player
  def get_turn_choice(moves)
    moves[rand(0...moves.length)].to_s
  end
end

game = TicTacToe.new
game.play
