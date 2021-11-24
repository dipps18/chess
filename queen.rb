class Queen
  attr_accessor :pos, :sym
  def initialize(color, sym)
		@sym = sym
		@pos = color == 'black' ? [0, 3] : [7, 3]
		@moves = nil
	end
 
	# def set_moves(board, pos, pieces)
	# 	[board.left(pos, pieces), board.right(pos, pieces)
	# 	 board.bottom(pos, pieces), board.top(pos, pieces),
	# 	 board.diag_top_right(pos, pieces), board.diag_top_left(pos, pieces),
	# 	 board.diag_bottom_right(pos, pieces), board.diag_bottom_left(pos, pieces)
  #   ].flatten(1)
	# end
end