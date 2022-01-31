require 'byebug'
require 'yaml'
require_relative '../lib/board'

class Game
  attr_reader :board

  def initialize(board = Board.new)
    @board = board
  end

  def play(id_= 0)
    id, color = [id_, color(id_)]
    input = ''
    update_screen
    loop do
      input = input(id)
      update(input, color) unless save?(input) || load?(input) || resign?(input)
      break if gameover?(input, color) 
      id, color = update_id_and_color(id)
      reset_enpassant(color)
    end
    result(input, id)
  end

  def add_piece(color, piece)
		pieces = color_pieces(color)
		pieces[piece_type(piece)].push(piece)
		@board.pieces.push(piece)
	end

  def color(id)
    id == 0 ? 'white' : 'black'
  end

  def can_castle?(input, color)
    return false unless castle?(input)
    opp_pieces = color_pieces(opp_color(color))
    squares_notation = castling_squares(input, color)
    squares = Board.coordinates(squares_notation)
    castling_conditions_met?(input, squares, color)
  end

  def capture?(input)
    input.match?('x')
  end

  # returns the captured piece based on the move input given by the player
  def captured_piece(color, input, dest)
    if input && enpassant?(dest, input, color)
      piece_pos = passed_pawn_pos(color, dest)
      piece_in_pos(piece_pos)
    else
      piece_in_pos(dest)
    end
  end

  def castle(input, color)
    if color == 'white'
      king = @board.white[:king][0]
    else
      king = @board.black[:king][0]
    end
    rook = castling_rooks(input, color)
    squares = Board.coordinates(castling_squares(input, color))
    king.pos = squares[1]
    rook.pos = input == 'O-O' ? squares[0] : squares[2]
  end

  def castle?(input)
    king_side = Regexp.new(/^O-O[+#]{,1}$/)
    queen_side = Regexp.new(/^O-O-O[+#]{,1}$/)
    king_side.match?(input) || queen_side.match?(input)
  end

  def castling_conditions_met?(input, squares, color)
    opp_pieces = color_pieces(opp_color(color))
    rook = castling_rooks(input, color)
    king = color == 'black' ? @board.black[:king][0] : @board.white[:king][0] 
    !check?(color) && !squares_check?(opp_pieces, squares) &&
    !rook.moved && !king.moved && board.squares_empty?(squares)
  end

  def castling_rooks(input, color)
    if color == 'black' 
      rook_pos = input == 'O-O' ? 'h8' : 'a8'
    elsif color == 'white'
      rook_pos = input == 'O-O' ? 'h1' : 'a1'
    end
    piece_in_pos(Board.coordinates(rook_pos))
  end

  def castling_squares(input, color)
    if input == 'O-O'
      return color == 'black' ? ['f8', 'g8'] : ['f1', 'g1']
    elsif input == 'O-O-O'
      return color == 'black' ? ['b8', 'c8', 'd8'] : ['b1', 'c1', 'd1']
    end
  end

  def check?(color)
    opp_pieces = color_pieces(opp_color(color)).values.flatten
		if color == 'white'
			king_pos = @board.white[:king][0].pos
		else
			king_pos = @board.black[:king][0].pos
		end
		opp_pieces.any? do |piece|
      piece if piece.next_moves.include?(king_pos)
    end
  end

	def checkmate?(color)
		pieces = color_pieces(color)
		pieces.values.flatten.none? do |piece|
			piece.next_moves.any? do |move|
        capture = !@board.squares_empty?(move)
				valid_move?(move, piece.pos, piece.color, capture, piece)
			end
		end
	end

  def checkmate_input?(input)
    input.match?(/#/)
  end

  def change_position(piece, position)
		piece.pos = position
		@board.update_cells
		@board.update_all_moves
	end

  def checkmate_or_check?(input)
    input[-1].match?(/[#+]/) 
  end

  def color_pieces(color)
    color == 'white' ? @board.white : @board.black
  end

  def declare_winner(color)
    puts "#{color} wins!"
  end

  def destination(input, opp_color)
		destination = extract_destination(input)
    return nil unless destination.match?(/[a-h][1-8]/)
    destination = Board.coordinates(destination)
    return nil if capture?(input) && !@board.color_in_cell?(opp_color, destination) && !enpassant?(destination, input, opp_color) 
    return nil if !capture?(input) && !@board.squares_empty?(destination)
		return destination
  end

  def display_saved_games
    saved_game_list.each_with_index{|name, idx| puts "#{idx + 1}.#{name}"}
  end

  def extract_destination(input)
		if promotion?(input)
			return input[-4..-3]
		elsif checkmate_or_check?(input)
			return input[-3..-2]
		else
			return input[-2..-1]
		end
	end

  def extract_input(input, color)
    piece = piece(input[0])
    pieces = color_pieces(color)
    opp_color = opp_color(color)
    new_pos = destination(input, opp_color)
    old_pos = Object.const_get(piece).origin(input, new_pos, pieces)
    return old_pos, new_pos
  end

  def enpassant?(dest, input, opp_color)
    passed_pawn_pos = passed_pawn_pos(opp_color, dest)
    pawn_sym = opp_color == 'white' ? " \u265F " : " \u2659 "
    piece_found = piece_in_cell?(pawn_sym, passed_pawn_pos)
    pawn_capture?(input) ? piece_found : false 
	end

  def extract_position(input, new_pos, color)
    piece_str = piece(input[0])
    color_pieces = color_pieces(color)
    Object.const_get(piece_str).origin(input, new_pos, color_pieces)
  end

  def from_yaml(filename)
    data = YAML.load(File.open(filename).read)
    [data[:id], data[:board]]
  end

  def gameover?(input, color)
    opp_color = opp_color(color)
    resign?(input) || checkmate?(opp_color) ||
    stalemate?(opp_color) || save?(input) || load?(input)
  end

  def input(id)
    puts "   Player #{id + 1}, make your move"
    loop do
      input = gets.chomp
      return input if valid_input?(input, color(id))
      puts "Wrong input, try again"
    end
  end

  def king_move?(input)
    /^Kx{,1}[a-h][1-8][+#]{,1}$/.match?(input)
  end

  def load?(input)
    input.match?(/^load$/)
  end

  def load_game(id)
    puts "loading game..."
    display_saved_games
    saved_games = saved_game_list
    if saved_game_list.length >= 1
      puts "Enter index of saved game"
      index = gets.chomp.to_i
      if index.between?(1, saved_games.length)
        filename = saved_games[index - 1]
        id, @board = from_yaml(filename)
        play(id)
      else
        puts "incorrect index, enter again"
        load_game
      end
    else
      no_load_game_found(id)
    end
  end

  def normal_move(input, color)
    old_pos, new_pos = extract_input(input, color)
    opp_color = opp_color(color)
    if capture?(input)
      if enpassant?(new_pos, input, opp_color)
        pos = passed_pawn_pos(opp_color, new_pos)
      else
        pos = new_pos
      end
      remove_piece(pos)
    end
    update_position(new_pos, old_pos)
  end

  def no_load_game_found(id)
    puts "No load game found, starting new game..."
    play(id)
  end


  def opp_color(color)
		color == 'white' ? 'black' : 'white'
	end

  def overwrite?(id, filename)
    puts "#{filename} already exists, do you wish to overwrite ?"
    ans = gets.chomp
    if yes?(ans)
      to_yaml(id, filename)
    else
      save_game(id)
    end
  end

  # returns the position of the captured pawn given
  # the color and position of the capturing pawn
  def passed_pawn_pos(color, capturing_pos)
    offset_y = color == 'white' ? -1 : 1
    [capturing_pos[0] + offset_y, capturing_pos[1]]
  end

  # returns true if piece symbol is in the position
  def piece_in_cell?(piece_sym, pos)
    board.cells[pos[0]][pos[1]] == piece_sym
  end

  # returns the piece at a particular position
  def piece_in_pos(pos)
    @board.pieces.select{|piece| piece.pos == pos}[0]
  end

  def piece_type(piece)
    return :king if piece.kind_of?(King)
    return :queen if piece.kind_of?(Queen)
    return :rooks if piece.kind_of?(Rook)
    return :bishops if piece.kind_of?(Bishop)
    return :knights if piece.kind_of?(Knight)
    return :pawns if piece.kind_of?(Pawn)
  end

  def promotion?(input)
    capture_promotion =  Regexp.new(/^[a-h]x[a-h]8=[RQBN][+#]{,1}$/)
    move_promotion =  Regexp.new(/^[a-h]8=[RQBN][+#]{,1}$/)
    capture_promotion.match?(input) || move_promotion.match?(input)
  end

  def pawn_move?(input)
    pawn_move = Regexp.new(/^[a-h][1-8][+#]{,1}$/)
    pawn_capture?(input) || pawn_move.match?(input)
  end

  def pawn_capture?(input)
    input.match?(/^[a-h]x[a-h][1-8][+#]{,1}$/)
  end
  
  # checks if the piece intended to move is a queen, bishop, rook or knight
  def piece_move?(input) 
    /^[QRNB][[a-h][1-8]]{,1}x{,1}[a-h][1-8][+#]{,1}$/.match?(input)
  end

  def piece(input)
    return "Pawn" if input.match?(/[a-h]/)
    return "Queen" if input == 'Q'
    return "King" if input == 'K'
    return "Rook" if input == 'R'
    return "Bishop" if input == 'B'
    return "Knight" if input == 'N'
  end

  def promote_piece(input, color)
    color_pieces = color_pieces(color)
    new_piece_str = piece(input[-1])
    new_piece_pos = destination(input[0...-2], opp_color(color))
    new_piece = Object.const_get(new_piece_str).new(color, new_piece_pos)
    pawn_pos = Pawn.origin(input[0...-2], new_piece_pos, color_pieces)
    remove_piece(pawn_pos)
    add_piece(color, new_piece)
  end

  def remove_piece(position)
		color = @board.pieces.map do |piece|
			piece.color if piece.pos == position 
		end.compact[0]
		color_pieces(color).each do |piece_type, pieces| 
      pieces.delete_if{ |piece| piece.pos == position }
    end
		@board.pieces.delete_if{ |piece| piece.pos == position }
	end

  def resign?(input)
    input == "resign"
  end

  # responsible for resetting the status of enpassant for pawns
  def reset_enpassant(color)
    if color == 'white'
      pawns = @board.white[:pawns]
    else
      pawns = @board.black[:pawns]
    end
    pawns.each{ |pawn| pawn.enpossible = false } 
  end

  def result(input, id)
    if save?(input)
      save_game(id)
    elsif load?(input)
      load_game
    elsif stalemate?(color(id))
      puts "Draw by stalemate"
    elsif resign?(input)
      declare_winner(opp_color(color(id)))
    else
      declare_winner(color(id))
    end
  end

  def remove_ext(filename)
    filename[0...filename.index('.')]
  end

  def save?(input)
    input.downcase.match?(/^save$/)
  end

  def save_file(id, filename)
    saved_games = saved_game_list
    if saved_games.include?(filename)
      overwrite?(id, filename)
    else
      to_yaml(id, filename)
    end
  end

  def save_game(id)
    puts "Saving game..."
    puts 'Enter a name for your saved game'
    filename = gets.chomp
    filename = remove_ext(filename).concat('.yaml')
    save_file(id, filename)
    puts 'Game saved'
  end

  def saved_game_list
    Dir.glob('*.yaml')
  end

  def stalemate?(color)
    pieces = color_pieces(color).values.flatten
		pieces.all?{ |piece| piece.next_moves.empty? }
	end

  def squares_check?(pieces, coordinates)
    pieces.values.flatten.any? do |piece|
      (piece.next_moves - coordinates).length < piece.next_moves.length
    end
  end

  def to_yaml(id, filename)
    file = File.open(filename, 'w')
    file.puts YAML.dump({ board: @board, id: id })
  end

  def update(input, color)
    if input == 'O-O-O' || input == 'O-O'
      castle(input, color)
    elsif promotion?(input)
      promote_piece(input, color)
    else
      normal_move(input, color)
    end
    @board.update_cells
    update_next_moves
    update_screen
  end

  def update_id_and_color(id)
    return (id + 1) % 2, color((id + 1) % 2)
  end

  # updates next moves for each piece with only valid moves
	def update_next_moves
		@board.pieces.each do |piece|
			piece.next_moves = piece.all_moves(@board).select do |move|
				capture = !@board.squares_empty?(move)
				valid_move?(move, piece.pos, piece.color, capture, piece)
			end
		end
	end

  def update_position(new_pos, old_pos)
		piece = @board.pieces.select{ |piece| piece.pos == old_pos }[0]
		piece.moved = true if piece.kind_of?(King) || piece.kind_of?(Rook)
		piece.pos = new_pos
	end
  
  def update_screen
    system "clear"
    board.display_board
  end
  
  def valid_input?(input, color)
    return true if resign?(input) || save?(input) ||
                   can_castle?(input, color) || load?(input)
    return false unless valid_move_input?(input)
    new_pos = destination(input, opp_color(color))
    old_pos = extract_position(input, new_pos, color)
    return false unless old_pos && new_pos
    piece = piece_in_pos(old_pos)
    capture = capture?(input)
    valid_move?(new_pos, old_pos, color, capture, piece, input)
  end

  def valid_move?(new_pos, old_pos, color, capture = false, piece = nil, input = nil)
    return false if piece && !piece.next_moves.include?(new_pos)
    opp_color = opp_color(color)
		if capture == true
			captured_piece = captured_piece(opp_color, input, new_pos)
			remove_piece(new_pos)
		end
		change_position(piece, new_pos)
		valid_move = valid_notation?(input, opp_color) && !check?(color)
		add_piece(opp_color, captured_piece) if capture
		change_position(piece, old_pos)
		valid_move
	end

  def valid_move_input?(input)
    pawn_move?(input) || king_move?(input) ||
    piece_move?(input) || promotion?(input)
  end

  def valid_notation?(input, color)
		return true unless input && input.match?(/[+#]/)
    return false if input.match?(/#/) && !checkmate?(color)
		return false if !input.match?(/#/) && checkmate?(color)
		return false if input.match?(/[#+]/) && !check?(color)
		return false if !input.match?(/[#+]/) && check?(color)
		return true
	end

  def yes?(input)
    input.downcase.match(/y|^yes$|^yep$|^yeppers$|^yippity$/)
  end
end

game = Game.new
game.play