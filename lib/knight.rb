class Knight
  attr_accessor :pos, :sym
  @@count = 0
  def initialize(color)
    @@count -= 2 if @@count == 2
    @color = color
    @sym = sym 
		coordinates, @sym = color == 'black' ? [[[0, 1], [0, 6]], " \u2658 "] : [[[7, 1], [7, 6]], " \u265E "]
		@pos = coordinates[@@count]
    @@count += 1
	end

  def init_next_moves(board, color)
		@next_moves = set_moves(board, color)
	end
 
	# def self.valid_move(destination, board)
	# 	@move_increments.any?{|incr| board.cells[dest[0] + incr][dest[1] + incr].sym == @sym}
	# end
end