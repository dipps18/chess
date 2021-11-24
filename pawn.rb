# require_relative 'bishop.rb'
# require_relative 'board.rb'
# require_relative 'knight.rb'
# require_relative 'king.rb'
# require_relative 'queen.rb'
# require_relative 'rook.rb'

class Pawn
  attr_accessor :pos, :sym
  @@count = 0
  def initialize(color, sym)
    @@count -= 8 if @@count == 8
    
    if color == 'black'
      coordinate = [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1,5], [1, 6], [1, 7]]
    else
      coordinate = [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]]
    end
    @pos = coordinate[@@count]
    @@count += 1
    @color = color
    @sym = sym
  end
end