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
      resest_enpassant(color)
      break if gameover?(color)
    end
    puts result
  end

  def update_id(id)
    (id + 1) % 2
  end

  def resest_enpassant(color) #responsible for resetting the status of enpassant for pawns
    @board.black[:pawns]
    if color == 'white'
      @board.white[:pawns].each{ |pawn| pawn.enpossible = false } 
    else
      @board.black[:pawns].each{ |pawn| pawn.enpossible = false }
    end
  end

  def result
    if @board.checkmate?('white')
      return 'white wins the game by checkmate'
    elsif @board.checkmate?('black')
      return 'black wins the game by checkmate'
    else
      return 'Game is a draw'
    end
  end

  def gameover?(color)
    @board.checkmate?(color) || @board.stalemate?
  end

  def update(input, color)
    board.update_next_moves
    if input == 'O-O-O' || input == 'O-O'
      castle(input, color)
    elsif Game.promotion?(input)
      promote_piece(input, color)
    else
      normal_move(input, color)
    end
    @board.update_cells
    update_screen
  end

  def promote_piece(input, color)
    color_pieces, opp_color = color == 'white' ? [@board.white, 'black'] : [@board.black, 'white']
    new_piece_str = piece(input[-1])
    new_piece_pos = @board.destination(input[0...-2], opp_color)
    new_piece = Object.const_get(new_piece_str).new(color, new_piece_pos)
    pawn_pos = Pawn.origin(input[0...-2], new_piece_pos, color_pieces)
    @board.remove_piece(pawn_pos)
    @board.add_piece(color, new_piece)
  end

  def normal_move(input, color)
    opp_color = color == 'white' ? 'black' : 'white'
    old_pos, new_pos = extract_input(input, color)
    if Game.capture?(input)
      pos = board.enpassant?(new_pos, input, opp_color) ? Game.enpassant_captured_pos(opp_color, new_pos) : new_pos
      @board.remove_piece(pos)
    end
      @board.update_position(new_pos, old_pos)
  end

  def self.enpassant_captured_pos(color, capturing_pos) #returns the position of the captured pawn given the color and position of the capturing pawn
    offset_y = color == 'white' ? -1 : 1
    [capturing_pos[0] + offset_y, capturing_pos[1]]
  end
  
  def update_screen
    # system "clear"
    board.display_board
  end

  def input(color)
    loop do
      input = gets.chomp
      return input if valid_input(input, color)
      puts "Wrong input, try again"
    end
  end

  def extract_input(input, color)
    piece = piece(input[0])
    color_pieces, opp_color = color == 'white' ? [@board.white, 'black'] : [@board.black, 'white']
    destination = @board.destination(input, opp_color)
    origin = Object.const_get(piece).origin(input, destination, color_pieces)
    return origin, destination
  end

  def valid_input(input, color)
    return true if Game.castle?(input) && can_castle?(input, color)
    return false unless Game.pawn_move?(input) || Game.king_move?(input) || Game.piece_move?(input) || Game.promotion?(input) 
    piece_string = piece(input[0])
    color_pieces, opp_color = color == 'white' ? [@board.white, 'black'] : [@board.black, 'white']
    new_pos = @board.destination(input, opp_color)
    old_pos = Object.const_get(piece_string).origin(input,  new_pos, color_pieces)
    piece = @board.pieces.select{|piece| piece.pos == old_pos}[0]
    capture = Game.capture?(input)
    old_pos && new_pos && @board.valid_move?(new_pos, old_pos, color, capture, piece, input)
  end

  def castle(input, color)
    king = color == 'white' ? @board.white[:king][0]: @board.black[:king][0]
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
    @board.piece_in_pos(Board.coordinates(rook_pos))
  end

  def squares_check?(pieces, coordinates)
    pieces.values.flatten.any? do |piece|
      (piece.next_moves - coordinates).length < piece.next_moves.length
    end
  end

  def can_castle?(input, color)
    opp_pieces = color == 'black' ? @board.white : @board.black
    king = color == 'black' ? @board.black[:king][0] : @board.white[:king][0] 
    rook = castling_rooks(input, color)
    squares = castling_squares(input, color)
    sq_coord = Board.coordinates(squares)
    return false if @board.check?(color)
    return false if squares_check?(opp_pieces, sq_coord)
    return false if rook.moved == true || king.moved == true
    return false unless board.squares_empty?(sq_coord)
    return true
  end

  def self.capture?(input)
    input.match?('x')
  end

  def self.promotion?(input)
    capture_promotion =  Regexp.new(/^[a-h]x[a-h]8=[RQBN][+#]{,1}$/)
    move_promotion =  Regexp.new(/^[a-h]8=[RQBN][+#]{,1}$/)
    capture_promotion.match?(input) || move_promotion.match?(input)
  end

  def self.pawn_move?(input)
    pawn_capture = Regexp.new(/^[a-h]x[a-h][1-8][+#]{,1}$/)
    pawn_move = Regexp.new(/^[a-h][1-8][+#]{,1}$/)
    pawn_capture.match?(input) || pawn_move.match?(input)
  end

  def self.castle?(input)
    king_side = Regexp.new(/^O-O[+#]{,1}$/)
    queen_side = Regexp.new(/^O-O-O[+#]{,1}$/)
    king_side.match?(input) || queen_side.match?(input)
  end

  def self.king_move?(input)
    /^Kx{,1}[a-h][1-8][+#]{,1}$/.match?(input)
  end

  def self.piece_move?(input) # checks if the piece intended to move is a queen, bishop, rook or knight
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

# game = Game.new
# game.play