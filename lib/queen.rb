class Queen
  attr_accessor :pos, :sym
  def initialize(color)
		@sym = sym
		@color = color
		@pos, @sym = color == 'black' ? [[0, 3], " \u2655 "] : [[7, 3], " \u265B "]
	end

	def init_next_moves(board, color)
		@next_moves = set_moves(board, color)
	end
 
	# def set_moves(board, pos, pieces)
	# 	[board.left(pos, pieces), board.right(pos, pieces)
	# 	 board.bottom(pos, pieces), board.top(pos, pieces),
	# 	 board.diag_top_right(pos, pieces), board.diag_top_left(pos, pieces),
	# 	 board.diag_bottom_right(pos, pieces), board.diag_bottom_left(pos, pieces)
  #   ].flatten(1)
	# end
end