class King
  attr_accessor :pos, :sym
  def initialize(color)
		if color == 'black'
			@sym = " \u2654 "
			@pos = [0, 4]
		else
			@sym = " \u265A "
			@pos = [7, 4]
		end
	end

	def init_next_moves(board, color)
		@next_moves = set_moves(board, color)
	end
	
end