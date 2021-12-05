class Rook
  attr_accessor :pos, :sym
  @@count = 0
	def initialize(color)
    @@count -= 2 if @@count == 2
    @color = color
		coordinates, @sym = color == 'black' ? [[[0, 0], [0, 7]], " \u2656 "] : [[[7, 0], [7, 7]], " \u265C "]
		@pos = coordinates[@@count]
    @@count += 1
	end

	def init_next_moves(board, color)
		@next_moves = set_moves(board, color)
	end
 
	# def set_moves(board, color)
	# 	[board.left(@pos, color), board.right(@pos, color)
	# 	 board.bottom(@pos, color), board.top(@pos, color)].flatten(1)
	# end
end