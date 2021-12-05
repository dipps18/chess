class Bishop
  @@count = 0
	attr_accessor :pos, :sym
	
  def initialize(color)
		@@count -= 2 if @@count == 2
    @color = color
		coordinates, @sym = color == 'black' ? [[[0, 2], [0, 7]], " \u2657 "] : [[[7, 2], [7, 5]], " \u265D "]
		@pos = coordinates[@@count]
    @@count += 1
		@sym = sym
  end

	def init_next_moves(board, color)
		@next_moves = set_moves(board, color)
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
 
	def set_moves(coordinates, board)
		[board.diag_top_right(coordinates), board.diag_top_left(coordinates),
		board.diag_bottom_right(coordinates), 
		board.diag_bottom_left(coordinates)].flatten(1)
	end
end