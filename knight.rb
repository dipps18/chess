class Knight
  attr_accessor :pos, :sym
  @@count = 0
  def initialize(color, sym)
    @@count -= 2 if @@count == 2
    @color = color
    @sym = sym 
		coordinates = color == 'black' ? [[0, 1], [0, 6]] : [[7, 1], [7, 6]]
		@pos = coordinates[@@count]
    @@count += 1
    @next_moves = nil
	end
 
	# def valid_move(destination, board)
	# 	@move_increments.any?{|incr| board.cells[dest[0] + incr][dest[1] + incr].sym == @sym}
	# end
end