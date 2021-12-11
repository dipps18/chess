class Game

  def input(color)
    loop do
      input = gets.chomp
      return valid_input(input, color) if valid_input(input, color)
    end
  end


  def valid_input(input, color)
    return false if /^[[NKQRB][a-h]]x?[[a-h][1-8]][a-h][1-8]$/.match(input)
    piece = piece(input)
    color_pieces, opp_color = color == 'white' ? [board.white, 'black'] : [board.black, 'white']
    destination = @board.destination(input, opp_color)
    origin = Object.const_get(piece).origin(input, color_pieces, @board)
    return !origin || !@board.destination ? nil : origin, destination
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