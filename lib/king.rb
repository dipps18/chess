class King
  attr_accessor :pos, :sym
  def initialize(color)
		@color = color
		@pos, @sym = color == 'black' ? [[0, 4], " \u2654 "] : [[7, 4], " \u265A "]
	end

	def init_next_moves(board)
		@next_moves = set_moves(board)
	end

	def set_moves(board)
		moves = []
		increments = [[1,-1], [1, 1], [-1, -1],
								  [1, 0], [-1, 0]].map{|increment_set| increment_set.permutation.to_a}.flatten(1)
		increments.each do |increment|
			next_move = [@pos[0] + increment[0], @pos[1] + increment[1]]
			moves.push(next_move) unless board.out_of_bounds?(next_move) || board.piece_in_cell?(@color, next_move)
		end
		moves.empty? ? nil : moves	
	end
	
end