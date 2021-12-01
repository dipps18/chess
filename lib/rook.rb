class Rook
  attr_accessor :pos, :sym
  @@count = 0
	def initialize(color)
    @@count -= 2 if @@count == 2
		@sym = sym
    @color = color
		if color == 'black'
			coordinates = [[0, 0], [0, 7]]
			@sym = " \u2656 "
		else
			coordinates =[[7, 0], [7, 7]]
			@sym = " \u265C "
		end
		@pos = coordinates[@@count]
    @@count += 1
		@next_moves = nil
	end

	def init_next_moves(board, color)
		@next_moves = set_moves(board, color)
	end
 
	# def set_moves(board, color)
	# 	[board.left(@pos), board.right(@pos)
	# 	 board.bottom(@pos), board.top(@pos)].flatten(1)
	# end
end