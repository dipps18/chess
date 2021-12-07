class Bishop
  @@count = 0
	attr_accessor :pos, :sym
	attr_reader :next_moves
	
  def initialize(color, pos = nil)
		@@count -= 2 if @@count == 2
    @color = color
		coordinates, @sym = color == 'black' ? [[[0, 2], [0, 5]], " \u2657 "] : [[[7, 2], [7, 5]], " \u265D "]
		@pos = pos ? pos : coordinates[@@count]
    @@count += 1
  end

	def init_next_moves(board)
		@next_moves = moves(board)
	end
	
	# def valid_move?(dest, board)
	# 	dest = coordinate(dest)
	# 	(next_moves.include?(dest) && board.cell_empty(dest)
	# end

	# def valid_capture?(color, dest, board)
	# 	dest = coordinate(dest)
	# 	opp_pieces = color == 'white' ? black_pieces : white_pieces
	# 	(next_moves1.include?(dest) && opp_pieces.include?(board.cells[dest[0]][dest[1]])
	# end

	def self.origin(input, destination, pieces)
    bishops = pieces[:bishops].select{ |bishop| bishop.next_moves.include?(destination) }
		if bishops.length > 1 # only possible when pawn has been promoted to bishop
			if input[1].match?(/[a-h]/)
				condition = proc{ |bishop| bishop.pos[1] == Board.column(input[1]) }
			elsif input[1].match?(/[1-8]/)
				condition = proc{ |bishop| bishop.pos if bishop.pos[0] == Board.row(input[1]) }
			end
			return bishops.select{ |bishop| condition.call(bishop) }[0].pos if input[1].match?(/[a-h1-8]/)
		end
		return bishops[0].pos if bishops[0].next_moves.include?(destination)
  end
 
	def moves(board)
		[board.diag_top_right(@pos, @color), board.diag_top_left(@pos, @color),
		 board.diag_bottom_right(@pos, @color), board.diag_bottom_left(@pos, @color)].flatten(1)
	end
end