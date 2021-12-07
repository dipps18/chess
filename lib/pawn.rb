# require_relative 'bishop.rb'
# require_relative 'board.rb'
# require_relative 'knight.rb'
# require_relative 'king.rb'
# require_relative 'queen.rb'
# require_relative 'rook.rb'

class Pawn
  attr_accessor :pos, :sym
  attr_reader :color, :enpossible, :next_moves
  @@count = 0

  def initialize(color)
    @@count -= 8 if @@count == 8

    if color == 'black'
      @sym = " \u2659 "
      coordinates = [[1, 0], [1, 1], [1, 2], [1, 3],
                     [1, 4], [1,5], [1, 6], [1, 7]]
    else
      @sym = " \u265F "
      coordinates = [[6, 0], [6, 1], [6, 2], [6, 3],
                     [6, 4], [6, 5], [6, 6], [6, 7]]
    end
    @pos = coordinates[@@count]
    @@count += 1
    @color = color
    @sym = sym
    @enpossible = false
  end

	def init_next_moves(board)
    @next_moves = set_moves(board)
	end

  def enpassant?(position, pawns)
    pawns.any?{ |pawn| pawn.enpossible if pawn.pos == position }
  end

  def set_moves(board)
    moves = []
    origin, offset_y, opp_pawns, opp_color = (@color == 'black') ? [1, 1, board.white[:pawns], 'white'] : [6, -1, board.black[:pawns], 'black']
    if board.cell_empty?([@pos[0] + offset_y, @pos[1]])
      moves.push([@pos[0] + offset_y, @pos[1]]) 
      moves.push([@pos[0] + (2 * offset_y) , @pos[1]]) if @pos[0] == origin && board.cell_empty?([@pos[0] + 2 * offset_y, @pos[1]])
    end
    [1, -1].each do |offset_x|
      diagonal = [@pos[0] + offset_y, @pos[1] + offset_x]
      moves << diagonal if !board.out_of_bounds?(diagonal) && (board.piece_in_cell?(opp_color, diagonal) || enpassant?(diagonal, opp_pawns))
    end
    moves.empty? ? nil : moves	
  end


  def self.origin(input, destination, pieces)
    pawns = pieces[:pawns]
    condition = Board.capture?(input) ? proc{|pawn| pawn.pos == [destination[0] - 1, input[0].ord - 97] } : proc{ |pawn| pawn.next_moves.include?(destination) }
    pawns = pawns.select{ |pawn| condition.call(pawn) }
    return pawns[0].pos unless pawns.length > 1 || pawns.length == 0
  end
end
