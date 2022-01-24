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
    opp_color = color == 'white' ? 'black' : 'white'
    board.update_next_moves
    if input == 'O-O-O' || input == 'O-O'
      castle(input, color)
    else
      origin, dest = extract_input(input, color)
      if Game.capture?(input)
        pos = board.enpassant?(dest, input, opp_color) ? Game.enpassant_captured_pos(opp_color, dest) : dest
        @board.remove_piece(pos, color)
      end
        @board.update_position(dest, origin)
    end
    @board.update_cells
    update_screen
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
    piece = piece(input)
    color_pieces, opp_color = color == 'white' ? [@board.white, 'black'] : [@board.black, 'white']
    destination = @board.destination(input, opp_color)
    origin = Object.const_get(piece).origin(input, destination, color_pieces)
    return origin, destination
  end

  def valid_input(input, color)
    return true if Game.castle?(input) && can_castle?(input, color)
    return false unless Game.pawn_move?(input) || Game.king_move?(input) || Game.piece_move?(input)
    piece_string = piece(input)
    color_pieces, opp_color = color == 'white' ? [@board.white, 'black'] : [@board.black, 'white']
    dest = @board.destination(input, opp_color)
    origin = Object.const_get(piece_string).origin(input,  dest, color_pieces)
    piece = @board.pieces.select{|piece| piece.pos == origin}[0]
    capture = Game.capture?(input)
    origin && dest && @board.valid_move?(dest, origin, color, capture, piece, input)
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
    return "Pawn" if input[0].match?(/[a-h]/)
    return "Queen" if input[0] == 'Q'
    return "King" if input[0] == 'K'
    return "Rook" if input[0] == 'R'
    return "Bishop" if input[0] == 'B'
    return "Knight" if input[0] == 'N'
  end
end

game = Game.new
game.play