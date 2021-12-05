class Game

  def input(color)
    loop do
      input = gets.chomp
      return valid_input(input, color) if valid_input(input, color)
    end
  end

  def valid_input(input, color)
    return false if /^[[NKQRB][a-h]]x?[[a-h][1-8]][a-h][1-8]$/.match(input)
    pawns, opp_color = color == 'white' ? [board.white[pawns], 'black'] : [board.black[pawns], 'white']
    destination = destination(input, @board, opp_color)
    Object.const_get(piece(input)).valid_move(input, pawns, @board)
  end


  def self.capture?(input)
    input.match?('x')
  end

  def destination(input, board, color)
    destination = input[-2..-1]
    return nil unless destination.match?(/[a-h][1-8]/)

    destination = board.coordinates(destination)
    return nil if Game.capture?(input) && !board.piece_in_cell?(color, destination) && !board.cell_empty?(destination)
    return nil if !Game.capture?(input) && !board.cell_empty?(destination)
    return destination
  end
end