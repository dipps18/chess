class Rook
  attr_accessor :pos, :sym
  @@count = 0
	def initialize(color, sym)
    @@count -= 2 if @@count == 2
		@sym = sym
    @color = color
		coordinates = color == 'black' ? [[0, 0], [0, 7]] : [[7, 0], [7, 7]]
		@pos = coordinates[@@count]
    @@count += 1
		@next_moves = nil
	end
 
	# def set_moves(board, color)
	# 	[board.left(@pos), board.right(@pos)
	# 	 board.bottom(@pos), board.top(@pos)].flatten(1)
	# end
end