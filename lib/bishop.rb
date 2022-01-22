require 'byebug'
class Bishop
  @@count = 0
	attr_accessor :pos, :sym, :next_moves
	attr_reader :color
	
  def initialize(color, pos = nil)
		@@count -= 2 if @@count == 2
    @color = color
		coordinates, @sym = color == 'black' ? [[[0, 2], [0, 5]], " \u2657 "] : [[[7, 2], [7, 5]], " \u265D "]
		@pos = pos ? pos : coordinates[@@count]
    @@count += 1
		@next_moves = []
  end

	def self.origin(input, destination, pieces)
    bishops = pieces[:bishops].select{ |bishop| bishop.next_moves.include?(destination) }
		if bishops.length > 1 # only possible when pawn has been promoted to bishop
			if input[1].match?(/[a-h]/)
				return bishops.select{ |bishop| bishop.pos[1] == Board.column(input[1]) }[0].pos
			elsif input[1].match?(/[1-8]/)
				return bishops.select{ |bishop| bishop.pos[0] == Board.row(input[1]) }[0].pos
			end
		end
		return bishops[0].pos unless bishops.empty?
  end
 
 
	def all_moves(board)
		[board.diag_top_right(@pos, @color), board.diag_top_left(@pos, @color),
		 board.diag_bottom_right(@pos, @color), board.diag_bottom_left(@pos, @color)].flatten(1)
	end
end