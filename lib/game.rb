class Game

  def play
    id = 0
    color = 'white'
    loop do
      break if gameover?(color)
      puts "Player #{id + 1}, make your move"
      input = input(color)
      update(input, color)
      id = (id + 1) % 2
      color = id == 0 ? 'white' : 'black'
      color == 'white' ? @white[:pawns].map!{|pawn| pawn.enpossible = false} : @black[:pawns].map!{|pawn| pawn.enpossible = false}
    end
    puts result
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
    loop do
      break if valid_input(input, color)
      puts "Wrong input, try again"
      input = gets.chomp
    end
    origin, dest = extract_input(input, color)
    @board.update_pieces(origin, color) if input.include?('x')
    @board.update_position(origin, destination)
    update_screen
  end
  
  def update_screen
    system "clear"
    board.display_board
  end

  def input(color)
    loop do
      input = gets.chomp
      return valid_input(input, color) if valid_input(input, color)
    end
  end

  def extract_input(input, color)
    piece = piece(input)
    color_pieces, opp_color = color == 'white' ? [board.white, 'black'] : [board.black, 'white']
    destination = @board.destination(input, opp_color)
    origin = Object.const_get(piece).origin(input, color_pieces, @board)
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