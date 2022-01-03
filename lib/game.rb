
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
    origin, destination = extract_input(input, color)
    @board.update_pieces(destination, color) if input.include?('x')
    @board.update_position(destination, origin)
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
    return false unless pawn_move?(input) || king_move?(input) || piece_move?(input)
    piece_string = piece(input)
    color_pieces, opp_color = color == 'white' ? [@board.white, 'black'] : [@board.black, 'white']
    destination = @board.destination(input, opp_color)
    origin = Object.const_get(piece_string).origin(input, destination, color_pieces)
    origin && destination && @board.valid_move?(destination, origin, color, Board.capture?(input))
  end

  def pawn_move?(input)
    /^[a-h][1-8]$/.match?(input) || /^[a-h]x[a-h][1-8]$/.match?(input)
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