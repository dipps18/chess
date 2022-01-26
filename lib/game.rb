require 'byebug'
require_relative '../lib/board'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def play
    id = 0
    color = 'white'
    loop do
      puts "Player #{id + 1}, make your move"
      input = input(color)
      update(input, color)
      id = update_id(id)
      color = id == 0 ? 'white' : 'black'
      reset_enpassant(color)
      break if gameover?(color)
    end
    puts result
  end

  def input(color)
    loop do
      input = gets.chomp
      return input if valid_input?(input, color)
      puts "Wrong input, try again"
    end
  end

  def valid_input?(input, color)
    return true if castle?(input) && can_castle?(input, color)
    return false unless valid_move_input?(input)
    new_pos = destination(input, opp_color(color))
    old_pos = extract_position(input, new_pos, color)
    return false unless old_pos && new_pos
    piece = piece_in_pos(old_pos)
    capture = capture?(input)
    valid_move?(new_pos, old_pos, color, capture, piece, input)
  end

  def extract_position(input, new_pos, color)
    piece_str = piece(input[0])
    color_pieces = color_pieces(color)
    Object.const_get(piece_str).origin(input, new_pos, color_pieces)
  end

  def valid_move_input?(input)
    pawn_move?(input) || king_move?(input) || piece_move?(input) || promotion?(input)
  end

  def valid_move?(new_pos, old_pos, color, capture = false, piece = nil, input = nil)
		return false if piece && !piece.next_moves.include?(new_pos)
		if capture == true
			captured_piece = captured_piece(opp_color(color), input, new_pos)
			remove_piece(new_pos)
		end
		change_position(piece, new_pos)
		valid_move = valid_notation?(input, opp_color(color)) && !check?(color)
		add_piece(opp_color(color), captured_piece) if capture
		change_position(piece, old_pos)
		valid_move
	end

  def extract_input(input, color)
    piece = piece(input[0])
    color_pieces, opp_color = color == 'white' ? [@board.white, 'black'] : [@board.black, 'white']
    destination = destination(input, opp_color)
    origin = Object.const_get(piece).origin(input, destination, color_pieces)
    return origin, destination
  end

  def update(input, color)
    update_next_moves
    if input == 'O-O-O' || input == 'O-O'
      castle(input, color)
    elsif promotion?(input)
      promote_piece(input, color)
    else
      normal_move(input, color)
    end
    @board.update_cells
    update_screen
  end

  # responsible for resetting the status of enpassant for pawns
  def reset_enpassant(color)
    @board.black[:pawns]
    if color == 'white'
      @board.white[:pawns].each{ |pawn| pawn.enpossible = false } 
    else
      @board.black[:pawns].each{ |pawn| pawn.enpossible = false }
    end
  end

  def result
    if checkmate?('white')
      return 'white wins the game by checkmate'
    elsif checkmate?('black')
      return 'black wins the game by checkmate'
    else
      return 'Game is a draw'
    end
  end

  def gameover?(color)
    checkmate?(color) || stalemate?
  end

  def update_id(id)
    (id + 1) % 2
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

	def remove_piece(position)
		color = @board.pieces.map do |piece|
			piece.color if piece.pos == position 
		end.compact[0]
		color_pieces(color).each do |piece_type, pieces| 
      pieces.delete_if{ |piece| piece.pos == position }
    end
		@board.pieces.delete_if{ |piece| piece.pos == position }
	end

  def add_piece(color, piece)
		pieces = color == 'white' ? @board.white : @board.black
		pieces[piece_type(piece)].push(piece)
		@board.pieces.push(piece)
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

   #returns true if piece symbol is in the position
  def piece_in_cell?(piece_sym, pos)
    board.cells[pos[0]][pos[1]] == piece_sym
  end
	
  def enpassant?(dest, input, opp_color)
    passed_pawn_pos = passed_pawn_pos(opp_color, dest)
    pawn_sym = opp_color == 'white' ? " \u265F " : " \u2659 "
    pawn_capture = Regexp.new(/^[a-h]x[a-h][1-8][+#]{,1}$/)
    if pawn_capture.match?(input)
      return piece_in_cell?(pawn_sym, passed_pawn_pos)
    end
    false
	end

  # returns the position of the captured pawn given the color and position of the capturing pawn
  def passed_pawn_pos(color, capturing_pos)
    offset_y = color == 'white' ? -1 : 1
    [capturing_pos[0] + offset_y, capturing_pos[1]]
  end

  # returns the piece at a particular position
	def piece_in_pos(pos)
		@board.pieces.select{|piece| piece.pos == pos}[0]
	end

  def color_pieces(color)
    color == 'white' ? @board.white : @board.black
  end

  def opp_color(color)
		color == 'white' ? 'black' : 'white'
	end

	def piece_type(piece)
		return :king if piece.kind_of?(King)
		return :queen if piece.kind_of?(Queen)
		return :rooks if piece.kind_of?(Rook)
		return :bishops if piece.kind_of?(Bishop)
		return :knights if piece.kind_of?(Knight)
		return :pawns if piece.kind_of?(Pawn)
	end

  def change_position(piece, position)
		piece.pos = position
		@board.update_cells
		@board.update_all_moves
	end

  def valid_notation?(input, color)
		return true unless input && input.match?(/[+#]/)
		return false if input.include?('+') && !check?(color)
		return false if !input.include?('+') && check?(color)
		return false if input.include?('#') && !checkmate?(color)
		return false if !input.include?('#') && checkmate?(color)
		return true
	end

  def stalemate?
		@board.pieces.all?{ |piece| piece.next_moves.empty? }
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
				valid_move?(move, piece.pos, piece.color, false, piece)
			end
		end
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

  def update_position(new_pos, old_pos)
		piece = @board.pieces.select{ |piece| piece.pos == old_pos }[0]
		piece.moved = true if piece.kind_of?(King) || piece.kind_of?(Rook)
		piece.pos = new_pos
	end
  
  def update_screen
    # system "clear"
    board.display_board
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
  
  def castling_squares(input, color)
    if input == 'O-O'
      return color == 'black' ? ['f8', 'g8'] : ['f1', 'g1']
    elsif input == 'O-O-O'
      return color == 'black' ? ['b8', 'c8', 'd8'] : ['b1', 'c1', 'd1']
    end
  end

  def castling_rooks(input, color)
    if color == 'black' 
      rook_pos = input == 'O-O' ? 'h8' : 'a8'
    elsif color == 'white'
      rook_pos = input == 'O-O' ? 'h1' : 'a1'
    end
    piece_in_pos(Board.coordinates(rook_pos))
  end

  def extract_destination(input)
		if promotion?(input)
			return input[-4..-3]
		elsif input[-1].match?(/[#+]/) 
			return input[-3..-2]
		else
			return input[-2..-1]
		end
	end

	def destination(input, opp_color)
		destination = extract_destination(input)
    return nil unless destination.match?(/[a-h][1-8]/)
    destination = Board.coordinates(destination)
    return nil if capture?(input) && !@board.color_in_cell?(opp_color, destination) && !enpassant?(destination, input, opp_color) 
    return nil if !capture?(input) && !@board.squares_empty?(destination)
		return destination
  end

  def squares_check?(pieces, coordinates)
    pieces.values.flatten.any? do |piece|
      (piece.next_moves - coordinates).length < piece.next_moves.length
    end
  end

  def can_castle?(input, color)
    opp_pieces = color_pieces(opp_color(color))
    king = color == 'black' ? @board.black[:king][0] : @board.white[:king][0] 
    rook = castling_rooks(input, color)
    squares = castling_squares(input, color)
    sq_coord = Board.coordinates(squares)
    return false if check?(color)
    return false if squares_check?(opp_pieces, sq_coord)
    return false if rook.moved == true || king.moved == true
    return false unless board.squares_empty?(sq_coord)
    return true
  end

  def capture?(input)
    input.match?('x')
  end

  def promotion?(input)
    capture_promotion =  Regexp.new(/^[a-h]x[a-h]8=[RQBN][+#]{,1}$/)
    move_promotion =  Regexp.new(/^[a-h]8=[RQBN][+#]{,1}$/)
    capture_promotion.match?(input) || move_promotion.match?(input)
  end

  def pawn_move?(input)
    pawn_capture = Regexp.new(/^[a-h]x[a-h][1-8][+#]{,1}$/)
    pawn_move = Regexp.new(/^[a-h][1-8][+#]{,1}$/)
    pawn_capture.match?(input) || pawn_move.match?(input)
  end

  def castle?(input)
    king_side = Regexp.new(/^O-O[+#]{,1}$/)
    queen_side = Regexp.new(/^O-O-O[+#]{,1}$/)
    king_side.match?(input) || queen_side.match?(input)
  end

  def king_move?(input)
    /^Kx{,1}[a-h][1-8][+#]{,1}$/.match?(input)
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
end

game = Game.new
game.play