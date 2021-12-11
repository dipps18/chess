class Rook
  attr_accessor :pos, :sym
	attr_reader :next_moves

  @@count = 0
	def initialize(color, pos = nil)
    @@count -= 2 if @@count == 2
    @color = color
		coordinates, @sym = color == 'black' ? [[[0, 0], [0, 7]], " \u2656 "] : [[[7, 0], [7, 7]], " \u265C "]
		@pos = pos ? pos : coordinates[@@count]
    @@count += 1
	end
 
	def set_moves(board)
		moves = [board.left(@pos, @color), board.right(@pos, @color),
		 				 board.bottom(@pos, @color), board.top(@pos, @color)].flatten(1)
		moves	
	end

	def self.origin(input, destination, pieces)
    rooks = pieces[:rooks].select{ |rook| rook.next_moves.include?(destination) }
		if rooks.length > 1 # only possible when pawn has been promoted to rook
			if input[1].match?(/[a-h]/)
				condition = proc{ |rook| rook.pos[1] == Board.column(input[1]) }
			elsif input[1].match?(/[1-8]/)
				condition = proc{ |rook| rook.pos if rook.pos[0] == Board.row(input[1]) }
			end
			return rooks.select{ |rook| condition.call(rook) }[0].pos if input[1].match?(/[a-h1-8]/)
		end
		rooks[0] ? rooks[0].pos : nil
  end

end