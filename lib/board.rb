require 'ansi/code'
require_relative 'bishop.rb'
require_relative 'pawn.rb'
require_relative 'knight.rb'
require_relative 'king.rb'
require_relative 'queen.rb'
require_relative 'rook.rb'
class Board
	attr_reader :white, :black, :cells
  def initialize
		@WHITE_SYMBOLS = [" \u265F ", " \u265E ", " \u265B ", " \u265A ", " \u265C ", " \u265D "]
		@BLACK_SYMBOLS = [" \u2659 ", " \u2658 ", " \u2655 ", " \u2654 ", " \u2656 ", " \u2657 "]
    @white = create_pieces('white')
    @black = create_pieces('black')
		@pieces = [@white.values, @black.values].flatten
		# condition = proc{ |pieces| pieces.each{ |piece| piece.init_next_valid_cells(self, piece.color) }}
		# @white.each{ |key, value| condition.call(value) }
		# @black.each{ |key, value| condition.call(value) }
    @cells = Array.new(8){ Array.new(8) }
    init_cells
  end

	def create_pieces(color)
		{:pawns => Array.new(8){ Pawn.new(color) },
     :bishops => Array.new(2){ Bishop.new(color) },
     :knights => Array.new(2){ Knight.new(color) },
     :rooks => Array.new(2){ Rook.new(color) },
     :queen => Array.new(1){ Queen.new(color) },
		 :king => Array.new(1){ King.new(color) }}
	end

  def init_cells
    @cells.map!{|row| row.map!{ |cell| cell = "   " if cell == nil } }
    @white.values.flatten.each{ |piece| @cells[piece.pos[0]][piece.pos[1]] = piece.sym }
    @black.values.flatten.each{ |piece| @cells[piece.pos[0]][piece.pos[1]] = piece.sym }
  end

  def display_board
    count = 0
		puts "\n"
    @cells.each do |row|
      row.each do |piece|
        print count % 2 == 1 ? ANSI::Code.rgb(0, 0, 0, true){piece} : ANSI::Code.rgb(250, 50, 50, true){piece}
        count += 1
      end
      print "\n"
      count += 1
    end
  end

	def valid_move?(destination, origin, piece, color)
		piece.pos = destination
		temp = @cells[destination[0]][destination[1]]
		@cells[destination[0]][destination[1]] = piece.sym
		@cells[origin[0]][origin[1]] = "   "
		update_all_moves
		valid_move = check?(color) ? false : true
		piece.pos = origin
		@cells[origin[0]][origin[1]] = piece.sym
		@cells[destination[0]][destination[1]] = temp
		update_all_moves
		valid_move
	end

	def update_all_moves #updates next_moves for each piece, also includes invalid moves
		@white.values.flatten.each{ |piece| piece.next_moves = piece.all_moves(self) }
		@black.values.flatten.each{ |piece| piece.next_moves = piece.all_moves(self) }
	end

	def update_next_moves #updates next moves for each piece with only valid moves
		# @pieces.each{|piece| p piece; p piece.all_moves(self).select{|move| valid_move?(move, piece.pos, piece, piece.color)} }
		condition = proc{ |piece| piece.next_moves = piece.all_moves(self).select{ |move| valid_move?(move, piece.pos, piece, piece.color)} }
		@white.values.flatten.each{ |piece| condition.call(piece) }
		@black.values.flatten.each{ |piece| condition.call(piece) }
		# @white.values.flatten.each{|piece| p piece.next_moves}
	end

	def update_position(destination, origin, color)
    pieces = color == 'white' ? @white : @black
		piece = pieces.map{ |key, value| value.select{ |piece| piece.pos == origin } }[0]
		piece[0].pos = destination
	end

  def check?(color)
		king_pos, opp_pieces = color == 'white' ? [@white[:king][0].pos, @black.values.flatten] : [@black[:king][0].pos, @white.values.flatten]
		opp_pieces.any?{ |piece| piece if piece.next_moves.include?(king_pos) }
  end

	def checkmate?(color)
		pieces = color == 'black' ? @black : @white
		#pieces.values.flatten.none?{ |piece|  piece.next_moves.any?{ |move| p valid_move?(move, piece.pos, piece, piece.color) } } 
		pieces.values.flatten.none?{ |piece| piece.next_moves.any?{ |move| valid_move?(move, piece.pos, piece, piece.color) } }
	end

	def out_of_bounds?(next_pos)
		next_pos[0] > 7 || next_pos[1] > 7 || next_pos[0] < 0 || next_pos[1] < 0		
	end

	def self.column(input)
		input.ord - 'a'.ord
	end
	
	def self.row(input)
		(input.to_i - 8).abs
	end

	def coordinates(position)
    [Board.row(position[1]), Board.column(position[0])]
  end

	def self.capture?(input)
    input.match?('x')
  end

	def destination(input, opp_color)
    destination = input[-2..-1]
    return nil unless destination.match?(/[a-h][1-8]/)

    destination = coordinates(destination)
    return nil if Board.capture?(input) && !piece_in_cell?(opp_color, destination)
    return nil if !Board.capture?(input) && !cell_empty?(destination)
    return destination
  end

	def piece_in_cell?(color, pos)
		pieces = color == 'black' ? @BLACK_SYMBOLS : @WHITE_SYMBOLS
		pieces.include?(@cells[pos[0]][pos[1]])
	end

	def cell_empty?(position)
		return true if position == nil
		@cells[position[0]][position[1]] == "   "
	end

	def valid_cells(next_pos, color, offset, index = nil, cur_pos = nil)
		cells = []
		loop do
			break if out_of_bounds?(next_pos) || piece_in_cell?(color, next_pos) || !cell_empty?(cur_pos)
      cells.push(next_pos.dup)
			cur_pos = cells[-1]
			index == nil ? next_pos = [cur_pos[0] + offset[0], cur_pos[1] + offset[1]] : next_pos[index] = cur_pos[index] + offset
		end
		cells
	end
	
  def diag_top_right(pos, color)
		offset = color == 'black' ? [1, -1] : [-1, 1]
		next_pos = [pos[0] + offset[0], pos[1] + offset[1]]
		valid_cells(next_pos, color, offset)
	end
 
	def diag_top_left(pos, color)
	  offset = color == 'black' ? [1, 1] : [-1, -1]
		next_pos = [pos[0] + offset[0], pos[1] + offset[1]]
		valid_cells(next_pos, color, offset)
	end
 
	def diag_bottom_left(pos, color)
	  offset = color == 'black' ? [-1, 1] : [1, -1]
		next_pos = [pos[0] + offset[0], pos[1] + offset[1]]
		valid_cells(next_pos, color, offset)
	end

	def diag_bottom_right(pos, color)
	  offset = color == 'black' ? [-1, -1] : [1, 1]
		next_pos = [pos[0] + offset[0], pos[1] + offset[1]]
		valid_cells(next_pos, color, offset)
	end
 
	def left(pos, color)
    offset = color == 'black' ? 1 : -1
		next_pos = [pos[0], pos[1] + offset]
		valid_cells(next_pos, color, offset, 1)
  end

  def right(pos, color)
    offset = color == 'black' ? -1 : 1
		next_pos = [pos[0], pos[1] + offset]
		valid_cells(next_pos, color, offset, 1)
  end

  def top(pos, color)
    offset = color == 'black' ? 1 : -1
		next_pos = [pos[0] + offset, pos[1]]
		valid_cells(next_pos, color, offset, 0)
  end

  def bottom(pos, color)
    offset = color == 'black' ?  -1 : 1 
		next_pos = [pos[0] + offset, pos[1]]
		valid_cells(next_pos, color, offset, 0)
  end
end