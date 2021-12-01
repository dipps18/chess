# require_relative 'bishop.rb'
# require_relative 'board.rb'
# require_relative 'knight.rb'
# require_relative 'king.rb'
# require_relative 'queen.rb'
# require_relative 'rook.rb'

class Pawn
  attr_accessor :pos, :sym
  attr_reader :color
  @@count = 0
  def initialize(color)
    @@count -= 8 if @@count == 8
    
    if color == 'black'
      @sym = " \u2659 "
      coordinates = [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1,5], [1, 6], [1, 7]]
    else
      @sym = " \u265F "
      coordinates = [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]]
    end
    @pos = coordinates[@@count]
    @@count += 1
    @color = color
    @sym = sym
  end

	# def init_next_moves(board, color)
	# 	@next_moves = set_moves(board, color)
	# end

  # def set_moves(board, color)

  # end
  
  # def self.valid_move?(input, color, board)
  #   pawns = color == 'white' ? board.white[pawns] : board.black[pawns]
  #   origin, destination = valid_position(input, pawns)
  #   origin && destination ? true : false
  # end

  # def valid_position(board, input, pawns)
  #   opp_pieces = color == 'white' ? board.black : board.white
  #   destination = destination(input, opp_pieces)
  #   origin = origin(destination, opp_pieces, pawns)
  # end

  # def pieces_at_position(pieces, position) #returns true if piece or any array of pieces found at particular position
  #   pieces.kind_of?(Array) ? pieces.any?{|key, value| value.any?{ |piece| piece.position == destination) } : pieces.position == destination
  # end

  # def capture?(input)
  #   input.match?('x')
  # end

  # def destination(input, opp_pieces)
  #   destination = input[-2..-1]
  #   return nil unless destination.match?(/[a-h][1-8]/)
  #   destination = coordinates(destination)
  #   return nil if capture? && !pieces_at_position?(opp_pieces, destination) && !cell_empty(destination)
  #   return nil if !capture? && board.cells[destination[0]][destination[1]] != "   "
  #   return destination
  # end

  # def origin(destination, opp_pieces, pawns)
  #   condition = capture?(input) ? proc{|pawn| pawn.position == [destination[0] - 1, input[0].ord - 97] } : proc{ |pawn| pawn.next_moves.include?(destination) }
  #   pawns.select{ |pawn| condition.call(pawn) }
  #   return pawns.position
  # end

end