class Knight
  attr_accessor :pos, :sym
  @@count = 0
  def initialize(color)
    @@count -= 2 if @@count == 2
    @color = color
    @sym = sym 
		if color == 'black' 
      coordinates = [[0, 1], [0, 6]]
      @sym =  " \u2658 " 
    else 
      coordinates = [[7, 1], [7, 6]]
      @sym = " \u265E "
    end
		@pos = coordinates[@@count]
    @@count += 1
    @next_moves = nil
	end

  def init_next_moves(board, color)
		@next_moves = set_moves(board, color)
	end
 
	# def self.valid_move(destination, board)
	# 	@move_increments.any?{|incr| board.cells[dest[0] + incr][dest[1] + incr].sym == @sym}
	# end
end