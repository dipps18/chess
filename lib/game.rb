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
      byebug if input == 'Bxa2'
      # byebug if input == 'O-O'
      update(input, color)
      id = update_id(id)
      color = id == 0 ? 'white' : 'black'
      resest_enpassant(color) #resets enpossible for previous color
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
    else
      origin, destination = extract_input(input, color)
      @board.remove_piece(destination, color) if input.include?('x')
      @board.update_position(destination, origin)
    end
    @board.update_cells
    update_screen
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
    return true if castle?(input) && can_castle?(input, color)
    return false unless pawn_move?(input) || king_move?(input) || piece_move?(input)
    piece_string = piece(input)
    color_pieces, opp_color = color == 'white' ? [@board.white, 'black'] : [@board.black, 'white']
    destination = @board.destination(input, opp_color)
    origin = Object.const_get(piece_string).origin(input,  destination, color_pieces)
    piece = @board.pieces.select{|piece| piece.pos == origin}[0]
    origin && destination && @board.valid_move?(destination, origin, color, Board.capture?(input), piece)
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
      rooks = @board.black[:rooks]
      rook_pos = input == 'O-O' ? 'h8' : 'a8'
    elsif color == 'white'
      rooks = @board.white[:rooks]
      rook_pos = input == 'O-O' ? 'h1' : 'a1'
    end
    @board.pieces_in_pos(rooks, Board.coordinates(rook_pos))
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

  def pawn_move?(input)
    /^[a-h][1-8]$/.match?(input) || /^[a-h]x[a-h][1-8]$/.match?(input)
  end

  def castle?(input)
    /^O-O$|^O-O-O$/.match?(input)
  end

  def king_move?(input)
    /^Kx{,1}[a-h][1-8]$/.match?(input)
  end

  def piece_move?(input) # checks if the piece intended to move is a queen, bishop, rook or knight
    /^[QRNB][[a-h][1-8]]{,1}x{,1}[a-h][1-8]$/.match?(input)
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

# game = Game.new
# game.play