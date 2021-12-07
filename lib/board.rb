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
		# condition = proc{ |pieces| pieces.kind_of?(Array) ? pieces.each{ |piece| piece.init_next_valid_cells(self, piece.color) } : pieces.init_next_valid_cells(self, pieces.color) }
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
		 :king => King.new(color) }
	end

  def init_cells
    @cells.map!{|row| row.map!{ |cell| cell = "   " if cell == nil } }
    @white.each{ |key, value| value.kind_of?(Array) ? value.each{ |piece| @cells[piece.pos[0]][piece.pos[1]] = piece.sym } : @cells[value.pos[0]][value.pos[1]] = value.sym }
    @black.each{ |key, value| value.kind_of?(Array) ? value.each{ |piece| @cells[piece.pos[0]][piece.pos[1]] = piece.sym } : @cells[value.pos[0]][value.pos[1]] = value.sym }
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

  # def check?(color)
  #   opp_pieces = color == 'white' ? @black : @white
  #   king_pos = color == 'white' ? @white[:king_white].position : @black[:king_black].position
  #   opp_pieces.any?{|opp_piece| opp_piece.next_valid_cells.any?{|move| move == king_pos}}
  # end

	def out_of_bounds?(next_pos)
		next_pos[0] > 7 || next_pos[1] > 7 || next_pos[0] < 0 || next_pos[1] < 0		
	end

	def self.column(input)
		input.ord - 'a'.ord
	end
	
	def self.row(input)
		(input.to_i - 8).abs
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

  def coordinates(position)
    [Board.row(position[1]), Board.column(position[0])]
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