class Rook
  attr_accessor :pos, :sym, :next_moves, :moved
	attr_reader :color

  @@count = 0
	def initialize(color, pos = nil)
		@moved = false
    @@count -= 2 if @@count == 2
    @color = color
		coordinates, @sym = color == 'black' ? [[[0, 0], [0, 7]], " \u2656 "] : [[[7, 0], [7, 7]], " \u265C "]
		@pos = pos ? pos : coordinates[@@count]
    @@count += 1
	end
 
	def all_moves(board)
		moves = [board.left(@pos, @color), board.right(@pos, @color),
		 				 board.bottom(@pos, @color), board.top(@pos, @color)].flatten(1)
		moves	
	end

	def self.origin(input, destination, pieces)
    rooks = pieces[:rooks].select{ |rook| rook.next_moves.include?(destination) }
		if rooks.length > 1 # only possible when pawn has been promoted to rook
			if input[1].match?(/[a-h]/)
				return rooks.select{ |rook| rook.pos[1] == Board.column(input[1]) }[0].pos
			elsif input[1].match?(/[1-8]/)
				return rooks.select{ |rook| rook.pos[0] == Board.row(input[1]) }[0].pos
			end
		end
		rooks[0] ? rooks[0].pos : nil
  end

end