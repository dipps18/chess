require 'ansi/code'
require_relative 'bishop.rb'
require_relative 'pawn.rb'
require_relative 'knight.rb'
require_relative 'king.rb'
require_relative 'queen.rb'
require_relative 'rook.rb'
class Board   
  def initialize
    @white_pieces = {:pawns_white => Array.new(8){ Pawn.new('white', " \u265F ") },
                     :bishops_white => Array.new(2){ Bishop.new('white', " \u265D ") },
                     :knights_white => Array.new(2){ Knight.new('white', " \u265E ") },
                     :rook_white => Array.new(2){ Rook.new('white', " \u265C ") },
                     :queen_white => Queen.new('white', " \u265B "), :king_white => King.new('white', " \u265A ") }

    @black_pieces = {:bishops_black => Array.new(2){ Bishop.new('black', " \u2657 ") },
                     :knights_black => Array.new(2){ Knight.new('black', " \u2658 ") },
                     :rooks_black => Array.new(2){ Rook.new('black', " \u2656 ") },
                     :queen_black => Queen.new('black', " \u2655 "), :king_black => King.new('black'," \u2654 "),
                     :pawns_black => Array.new(8){ Pawn.new('black', " \u2659 ") } }

    @cells = Array.new(8){ Array.new(8) }
    init_cells
    display_board
  end

  def init_cells

    @cells.map!{|row| row.map!{ |cell| cell = "   " if cell == nil } }
    @white_pieces.each{ |key, value| value.kind_of?(Array) ? value.each{ |piece| @cells[piece.pos[0]][piece.pos[1]] = piece.sym } : @cells[value.pos[0]][value.pos[1]] = value.sym }

    @black_pieces.each{ |key, value| value.kind_of?(Array) ? value.each{ |piece| @cells[piece.pos[0]][piece.pos[1]] = piece.sym } : @cells[value.pos[0]][value.pos[1]] = value.sym }
  end

  def display_board
    count = 0
    @cells.each do |row|
      row.each do |piece|
        print count % 2 == 1 ? ANSI::Code.rgb(0, 0, 0, true){piece} : ANSI::Code.rgb(250, 50, 50, true){piece}
        count += 1
      end
      print "\n"
      count += 1
    end
  end

  # def check?(color)
  #   opp_pieces = color == 'white' ? @black_pieces : @white_pieces
  #   king_pos = color == 'white' ? @white_pieces[:king_white].position : @black_pieces[:king_black].position
  #   opp_pieces.any?{|opp_piece| opp_piece.next_posmoves.any?{|move| move == king_pos}}
  # end

  # def diag_top_right(pos, color)
	# 	pieces = color == 'black' ? @black_pieces : @white_pieces
	# 	moves = []
	# 	next_pos = [pos[0] + 1, pos[1] + 1]
	# 	loop do
	# 		break if (next_pos[0] > 7 || next_pos[1] > 7) || peices.include?(@cells[next_pos[0][next_pos[1]]) || !cell_empty?(cur_pos)
      
	# 		moves.push(next_pos[0], next_pos[1])
	# 		cur_pos = moves[0]
	# 		next_pos = [cur_pos[0] + 1, cur_pos[1] + 1]
	# 	end
	# 	moves
	# end
 
	# def diag_top_left(pos, color)
	#   piece = color == 'black' ? @black_pieces : @white_pieces
	# 	moves = []
	# 	loop do
	# 		break if (next_pos[0] > 7 || next_pos[1] < 0) || piece.include?(@cells[next_pos[0]][next_pos[1]]) || !cell_empty?(cur_pos)
      
  #     moves.push(next_pos[0], next_pos[1])
	# 		cur_pos = moves[0]
	# 		next_pos = [cur_pos[0] + 1, cur_pos[1] - 1]
	# 	end
	# 	moves
	# end
 
	# def diag_bottom_left(pos, color)
	#   pieces = color == 'black' ? @black_pieces : @white_pieces #pieces stores pieces of the same color
	# 	moves = []
	# 	next_pos = [pos[0] - 1, pos[1] - 1] 
	# 	loop do
	# 		break if (next_pos[0] < 0 || next_pos[1] < 0) || peices.include?(@cells[next_pos[0][next_pos[1]]) || !cell_empty?(cur_pos)
      
	# 		moves.push(next_pos[0], next_pos[1])
	# 		cur_pos = moves[0]
	# 		next_pos = [cur_pos[0] - 1, cur_pos[1] - 1]
	# 	end
	# 	moves
	# end
 
	# def left(pos, color)
  #   pieces = color == 'black' ? @black_pieces : @white_pieces #pieces stores pieces of the same color
	# 	moves = []
	# 	next_pos = [pos[0], pos[1] - 1]
	# 	loop do
	# 		break if (next_pos[1] < 0) || pieces.include?(@cells[next_pos[0][next_pos[1]]) || !cell_empty?(cur_pos)

	# 		moves.push(next_pos[0], next_pos[1])
	# 		cur_pos = moves[0]
	# 		next_pos = [cur_pos[0], cur_pos[1] - 1]
	# 	end
  # end

  # def right(pos, color)
  #   pieces = color == 'black' ? @black_pieces : @white_pieces #pieces stores pieces of the same color
	# 	moves = []
	# 	next_pos = [pos[0], pos[1] - 1]
	# 	loop do
	# 		break if (next_pos[1] > 7) || pieces.include?(@cells[next_pos[0][next_pos[1]]) || !cell_empty?(cur_pos)

	# 		moves.push(next_pos[0], next_pos[1])
	# 		cur_pos = moves[0]
	# 		next_pos[1] = [cur_pos[1] + 1]
	# 	end
  # end

  # def top(pos, color)
  #   pieces = color == 'black' ? @black_pieces : @white_pieces #pieces stores pieces of the same color
	# 	moves = []
	# 	next_pos = [pos[0] + 1, pos[1]]
	# 	loop do
	# 		break if (next_pos[0] > 7) || pieces.include?(@cells[next_pos[0][next_pos[1]]) || !cell_empty?(cur_pos)

	# 		moves.push(next_pos[0], next_pos[1])
	# 		cur_pos = moves[0]
	# 		next_pos[0] = cur_pos[0] + 1
	# 	end
  # end

  # def bottom(pos, color)
  #   pieces = color == 'black' ? @black_pieces : @white_pieces #pieces stores pieces of the same color
	# 	moves = []
	# 	next_pos = [pos[0] - 1, pos[1]]
	# 	loop do
	# 		break if (next_pos[0] < 0) || pieces.include?(@cells[next_pos[0][next_pos[1]]) || !cell_empty?(cur_pos)

	# 		moves.push(next_pos[0], next_pos[1])
	# 		cur_pos = moves[0]
	# 		next_pos = cur_pos[0] - 1
	# 	end
  # end

end

board = Board.new
