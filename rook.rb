class Rook
  @@count = 0
	def initialize(color, sym)
		@sym = sym
    @color = color
		coordinates = color == 'white' ? [[0, 0], [0, 7]] : [[7, 0], [7, 7]]
		@pos = coordinates[@@count]
    @@count += 1
		@next_moves = set_moves(board, pieces)
	end
 
	def set_moves(board)
		[board.left(@pos), board.right(@pos)
		 board.bottom(@pos), board.top(@pos)].flatten(1)
	end
end