# A ruby file that plays the boardgame Onitama, see README.

class Onitama

  @@card_list = [ :tiger, :dragon, :crab, :elephant, :monkey,
                  :mantis, :crane, :boar, :frog, :rabbit,
                  :goose, :rooster, :horse, :ox, :eel, :cobra]

  @@help_message = "\tType 'board' or 'b' to show the board
  \tType 'cards' or 'c' to show your available cards
  \tType 'quit' or 'q' to exit
  \tType 'help' or 'h' for help"

  attr_reader :board, :players, :cards

  def initialize
    @players = []
    @board = Board.new
    @cards = []
    @current_player = 0
    setup_game
  end

  def setup_game
    setup_players
    setup_pieces
    setup_cards
  end

  def setup_players
    @players = [Player.new("player1","white"), Player.new("player2","black")]
  end

  # Get pieces from players and place on board
  def setup_pieces
    @board.place_piece(@players[0].get_piece_by_num(5),[0,2])
    @board.place_piece(@players[1].get_piece_by_num(5),[4,2])
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

  # Choose 5 cards at random and assign 2 to each player and 1 to the board.
  def setup_cards
    while @cards.length < 5
      card = random_card
      @cards << card if !@cards.any? {|c| c.card_name == card.card_name }
    end
    @players[0].cards[1] = @cards.shift
    @players[0].cards[2] = @cards.shift
    @players[1].cards[1] = @cards.shift
    @players[1].cards[2] = @cards.shift
    @board.card << @cards.shift
  end

  def random_card
    Card.new(@@card_list[rand(0..15)])
  end

  def play
    game_start
    play_turn
  end

  def game_start
    puts "--Welcome to Onitama!--"
    puts ""
    puts @@help_message
    puts ""
  end

  def play_turn
    while true
      puts "#{@players[@current_player].name} it's your turn!"
      @board.print_board
      piece, card, to_pos = get_player_move
      move_piece(piece, to_pos)
      update_cards(card)
      switch_players
    end
  end

  def get_player_move
    piece_num = get_piece_selection
    piece = @players[@current_player].get_piece_by_num(piece_num.to_i)
    card_num = get_card_selection(piece)
    card = @players[@current_player].get_card_by_num(card_num.to_i)
    to_pos_num = get_move_selection(piece, card)
    to_pos = piece.available_moves_as_hash(card)[to_pos_num.to_i]

    return [piece, card, to_pos]
  end

  def get_piece_selection
    get_selection("Choose piece: ", @players[@current_player].available_pieces)
  end

  def get_card_selection(piece)
    get_selection("Choose card: ", @players[@current_player].available_cards_with_moves(piece))
  end

  def get_move_selection(piece, card)
    get_selection("Choose move: ", piece.available_moves_as_hash(card))
  end

  # input must be a hash.
  def get_selection(message, options)

    while true
      puts "#{message}#{options}"
      user_input = gets.chomp.downcase

      if options.keys.include?(user_input.to_i)
        puts "you chose #{options[user_input.to_i]}"
        return user_input
      else

        case user_input
          when "back", "restart", "r"
            #code to get to start of input
          when "exit", "quit", "q"
            quit_game
          when "cards", "card", "c"
            @players[@current_player].print_cards
            @board.print_card
            @players[(@current_player+1)%2].print_cards
          when "board", "b"
            @board.print_board
          when "help", "h"
            puts @@help_message
          else
            puts input_error(user_input)
          end

        end

      end

  end

  def move_piece(piece, to_pos)
    check_to_pos(piece, to_pos)
    @board.move_piece(piece, to_pos)
  end

  def check_to_pos(piece, to_pos)
    piece_at_pos = @board.board[to_pos[0]][to_pos[1]]
    owner = piece_at_pos.owner
    case owner
      when @players[@current_player]
        puts "You can't take your own piece."
        play_turn
      when @players[(@current_player+1)%2]
        if piece_at_pos.number == 5
          @board.move_piece(piece, to_pos)
          declare_winner(@players[@current_player].name)
        end
        owner.remove_piece(piece_at_pos)
      else
        if to_pos == [0,2] && @players[@current_player].color == "black" && piece.number == 5
          @board.move_piece(piece, to_pos)
          declare_winner(@players[@current_player].name)
        elsif to_pos == [4,5] && @players[@current_player].color == "white" && piece.number == 5
          @board.move_piece(piece, to_pos)
          delcare_winner(@players[@current_player].name)
        end
        return
    end
  end

  def update_cards(card)
    new_card = @board.card.shift
    @board.card << card
    @players[@current_player].cards.each_key do |k|
      @players[@current_player].cards[k] = new_card if @players[@current_player].cards[k] == card
    end
  end

  def switch_players
    @current_player = (@current_player + 1) % 2
  end

  def declare_winner(player)
    puts "Game Over."
    puts "#{player} has Won!"
    exit
  end

  # def game_end
  #   @board.print_board
  #   if @board.winner
  #     puts "Game Over! #{@board.winner} has won!"
  #   else
  #     puts "Exiting Game"
  #   end
  # end

  def quit_game
    puts "Exiting Game."
    exit
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
    puts ""
    puts "     |  0   1   2   3   4  |  "
    puts "   "+"-"*27
    @board.each_with_index do |row, i|
      temp = "   #{i} | "
      row.each do |col|
        temp += "#{col.print_piece} "
      end
      temp += "| #{i}"
      puts temp
    end
    puts "   "+"-"*27
    puts "     |  0   1   2   3   4  |  "
    puts ""
  end

  def print_card
    res = "\tBoard Card: \n"
    res += "\t{#{@card[0].card_name}: #{@card[0].moves}} \n"
    puts res
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

  def print_card
    @card_name.to_s
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
      return @number == 5 ? ">*<" : ">#{@number}<"
    else
      return @number == 5 ? "<*>" : "<#{@number}>"
    end
  end

  def print_name
    return @number == 5 ? "*" : "#{@number}"
  end

  # returns valid moves of piece at current position as array, selects only those that fall onto board.
  def available_moves_as_array(card)
    if @color == "white"
      res = card.moves.map { |move| [@position[0] + move[0], @position[1] + move[1]] }
      return res.select { |move| (0..4).include?(move[0]) && (0..4).include?(move[1]) }
    else
      res = card.moves.map { |move| [@position[0] - move[0], @position[1] - move[1]] }
      return res.select { |move| (0..4).include?(move[0]) && (0..4).include?(move[1]) }
    end
  end

  # returns valid moves of piece at current position as hash, selects only those that fall onto board.
  def available_moves_as_hash(card)
    res = {}
    if @color == "white"
      all_moves = card.moves.map { |move| [@position[0] + move[0], @position[1] + move[1]] }
      moves_on_board = all_moves.select { |move| (0..4).include?(move[0]) && (0..4).include?(move[1]) }
      moves_on_board.each_with_index { |move, i| res[i+1] = move}
      return res
    else
      all_moves = card.moves.map { |move| [@position[0] - move[0], @position[1] - move[1]] }
      moves_on_board = all_moves.select { |move| (0..4).include?(move[0]) && (0..4).include?(move[1]) }
      moves_on_board.each_with_index { |move, i| res[i+1] = move}
      return res
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
