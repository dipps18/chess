class Game

  def input(color)
    loop do
      input = gets.chomp
      return valid_input(input, color) if valid_input(input, color)
    end
  end


  def valid_input(input, color)
    return false if /^[[NKQRB][a-h]]x?[[a-h][1-8]][a-h][1-8]$/.match(input)
    color_pieces, opp_color = color == 'white' ? [board.white, 'black'] : [board.black, 'white']
    destination = @board.destination(input, opp_color)
    origin = Object.const_get(piece(input)).origin(input, color_pieces, @board)
    return !origin || !@board.destination ? nil : origin, destination
  end

end