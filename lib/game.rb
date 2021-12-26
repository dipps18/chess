class Game
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def play
    id = 0
    color = 'white'

    loop do
      break if gameover?(color)
      puts "Player #{id + 1}, make your move"
      input = input(color)
      update(input, color)
      update_id(id)
      color = id == 0 ? 'white' : 'black'
      resest_enpassant(color)
    end
    puts result
  end

  def update_id(id)
    id = (id + 1) % 2
  end

  def resest_enpassant(color) #responsible for resetting the status of enpassant for pawns
    condition = proc{|pawn| pawn.enpossible = false}
    color == 'white' ? @board.white[:pawns].each{ |pawn| condition.call(pawn) } : @board.black[:pawns].each{ |pawn| condition.call(pawn) }
  end

  def result
    if @board.checkmate?('white')
      result = 'white wins the game by checkmate'
    elsif @board.checkmate?('black')
      result = 'black wins the game by checkmate'
    else
      result = 'Game is a draw'
    end
    result
  end

  def gameover?(color)
    @board.checkmate?(color) || @board.stalemate?
  end

  def update(input, color)
    origin = dest = nil
    origin, destination = extract_input(input, color)
    @board.update_pieces(origin, color) if input.include?('x')
    @board.update_position(destination, origin)
    @board.update_cells
    update_screen
  end
  
  def update_screen
    system "clear"
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
    color_pieces, opp_color = color == 'white' ? [board.white, 'black'] : [board.black, 'white']
    destination = @board.destination(input, opp_color)
    origin = Object.const_get(piece).origin(input, destination, color_pieces)
    return origin, destination
  end

  def valid_input(input, color)
    return false if /^[[NKQRB][a-h]]x?[[a-h][1-8]][a-h][1-8]$/.match(input)
    piece = piece(input)
    color_pieces, opp_color = color == 'white' ? [board.white, 'black'] : [board.black, 'white']
    !Object.const_get(piece).origin(input, color_pieces, @board) || !@board.destination(input, opp_color) ? false : true
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