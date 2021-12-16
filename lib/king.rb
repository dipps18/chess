class King
  attr_accessor :sym, :next_moves, :pos
	attr_reader :color

  def initialize(color)
		@color = color
		@pos, @sym = color == 'black' ? [[0, 4], " \u2654 "] : [[7, 4], " \u265A "]
	end


	def all_moves(board)
		moves = []
		increments = [[1,-1], [1, 1], [-1, -1],
								  [1, 0], [-1, 0]].map{|increment_set| increment_set.permutation.to_a}.flatten(1)
		increments.each do |increment|
			next_move = [@pos[0] + increment[0], @pos[1] + increment[1]]
			moves.push(next_move) unless board.out_of_bounds?(next_move) || board.piece_in_cell?(@color, next_move)
		end
		moves	
	end
	
end