class Knight
  attr_accessor :pos, :sym, :next_moves
  attr_reader :color
  @@count = 0
  def initialize(color, pos = nil)
    @@count -= 2 if @@count == 2
    @color = color
    @sym = sym 
		coordinates, @sym = color == 'black' ? [[[0, 1], [0, 6]], " \u2658 "] : [[[7, 1], [7, 6]], " \u265E "]
		@pos = pos ? pos : coordinates[@@count]
    @@count += 1
    @next_moves = []
	end

  def init_next_moves(board)
		@next_moves = set_moves(board)
	end

  def all_moves(board)
    moves = []
    move_increments = [[2, 1], [-2, 1], [2, -1],
                        [-2, -1]].map { |increment| increment.permutation.to_a }.flatten(1)
    move_increments.each do |increment|
      next_move = [@pos[0] + increment[0], @pos[1] + increment[1]]
      moves.push(next_move) unless board.out_of_bounds?(next_move) || board.color_in_cell?(@color, next_move)
    end
    moves	
  end

  def self.origin(input, destination, pieces)
    knights = pieces[:knights].select{ |knight| knight.next_moves.include?(destination) }
		if knights.length > 1
			if input[1].match?(/[a-h]/)
				condition = proc{ |knight| knight.pos[1] == Board.column(input[1]) }
			elsif input[1].match?(/[1-8]/)
				condition = proc{ |knight| knight.pos if knight.pos[0] == Board.row(input[1]) }
			end
			return knights.select{ |knight| condition.call(knight) }[0].pos if input[1].match?(/[a-h1-8]/)
		end
		knights[0] ? knights[0].pos : nil
  end
 
	def self.valid_move(destination)
    move_increments = [[2, 1], [-2, 1], [2, -1],
                       [-2, -1]].map { |increment| increment.permutation.to_a }.flatten(1)
		move_increments.any?{|incr| [destination[0] + incr[0]][destination[1] + incr[1]] == @pos}
	end
end