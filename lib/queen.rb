class Queen
  attr_accessor :pos, :sym, :next_moves
	attr_reader :color
  def initialize(color, pos = nil)
		@sym = sym
		@color = color
		@pos, @sym = color == 'black' ? [[0, 3], " \u2655 "] : [[7, 3], " \u265B "]
		@pos = pos if pos
	end

	def init_next_moves(board)
		@next_moves = set_moves(board)
	end

	def self.origin(input, destination, pieces)
    queen = pieces[:Queen]
		if queen.length > 1 #only happend when pawn is promoted to queen
			if input[1].match?(/[a-h]/)
				condition = proc{ |queen| queen.pos[1] == Board.column(input[1]) }
			elsif input[1].match?(/[1-8]/)
				condition = proc{ |queen| queen.pos if queen.pos[0] == Board.row(input[1]) }
			end
			return queens.select{ |queen| condition.call(queen) }[0].pos if input[1].match?(/[a-h1-8]/)
		end
		return queen[0] ? queen[0].pos : nil
  end
 
	def all_moves(board)
		moves = [board.left(@pos, @color), board.right(@pos, @color),
		 				 board.bottom(@pos, @color), board.top(@pos, @color),
						 board.diag_top_right(@pos, @color), board.diag_top_left(@pos, @color),
		         board.diag_bottom_right(@pos, @color), board.diag_bottom_left(@pos, @color)].flatten(1)
		moves	
	end
end