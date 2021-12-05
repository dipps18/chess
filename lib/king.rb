class King
  attr_accessor :pos, :sym
  def initialize(color)
		@pos, @sym = color == 'black' ? [[0, 4], " \u2654 "] : [[7, 4], " \u265A "]
	end

	def init_next_moves(board, color)
		@next_moves = set_moves(board, color)
	end
	
end