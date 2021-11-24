class Bishop
  @@count = 0
  def initialize(color, sym)
    @color = color
    coordinates = color == 'white' ? [[0, 2], [0, 5]] : [[7,2], [7,5]]
		pos = coordinates[@@count]
    @@count += 1
    @next_moves = set_moves(@pos)
		@sym = sym
  end
 
	def valid_move?(dest, board)
		dest = coordinate(dest)
		(next_moves1.include?(dest) && board.cell_empty(dest)
	end
 
	def valid_capture?(color, dest, board)
		dest = coordinate(dest)
		opp_pieces = color == 'white' ? black_pieces : white_pieces
		(next_moves1.include?(dest) && opp_pieces.include?(board.cells[dest[0]][dest[1]])
	end
 
def set_moves(coordinates)
  [Board.diag_top_right(coordinates), Board.diag_top_left(coordinates),
	 Board.diag_bottom_right(coordinates), 
	 Board.diag_bottom_left(coordinates)].flatten(1)
end