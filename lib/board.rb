require 'ansi/code'
require_relative 'bishop.rb'
require_relative 'pawn.rb'
require_relative 'knight.rb'
require_relative 'king.rb'
require_relative 'queen.rb'
require_relative 'rook.rb'
class Board
	attr_reader :white, :black, :cells
	attr_accessor :pieces
  def initialize
		@WHITE_SYMBOLS = [" \u265F ", " \u265E ", " \u265B ", " \u265A ", " \u265C ", " \u265D "]
		@BLACK_SYMBOLS = [" \u2659 ", " \u2658 ", " \u2655 ", " \u2654 ", " \u2656 ", " \u2657 "]
    @white = create_pieces('white')
    @black = create_pieces('black')
		@pieces = [@white.values, @black.values].flatten
		@cells = Array.new(8){ Array.new(8) }
		update_cells
		update_all_moves
  end

	def update_cells
    @cells.map!{|row| row.map{ |cell| cell = "   "} }
    @pieces.each do |piece|
      @cells[piece.pos[0]][piece.pos[1]] = piece.sym
    end
  end

	def update_all_moves # updates next_moves for each piece, also includes invalid moves
		@pieces.each do |piece|
			piece.next_moves = piece.all_moves(self)
		end
	end

	def create_pieces(color)
		{:pawns => Array.new(8){ Pawn.new(color) },
     :bishops => Array.new(2){ Bishop.new(color) },
     :knights => Array.new(2){ Knight.new(color) },
     :rooks => Array.new(2){ Rook.new(color) },
     :queen => Array.new(1){ Queen.new(color) },
		 :king => Array.new(1){ King.new(color) } }
	end

  def display_board
    ct = 0
		puts "\n"
    @cells.each do |row|
      row.each do |piece|
        print ct % 2 == 1 ? ANSI::Code.rgb(0, 0, 0, true){piece} : ANSI::Code.rgb(250, 50, 50, true){piece}
        ct += 1
      end
      print "\n"
      ct += 1
    end
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

	def self.coordinates(positions)
		coordinates = []
		if positions.kind_of?(Array)
			positions.each do |position|
				coordinates.push([Board.row(position[1]), Board.column(position[0])])
			end
		else
    	coordinates = [Board.row(positions[1]), Board.column(positions[0])]
		end
		coordinates
  end

	def valid_cells(next_pos, color, offset, index = nil, cur_pos = nil)
		cells = []
		loop do
			break if out_of_bounds?(next_pos) || color_in_cell?(color, next_pos) || !squares_empty?(cur_pos)
      cells.push(next_pos.dup)
			cur_pos = cells[-1]
			if index == nil
				next_pos = [cur_pos[0] + offset[0], cur_pos[1] + offset[1]]
			else
			  next_pos[index] = cur_pos[index] + offset
			end
		end
		cells
	end

  def color_in_cell?(color, pos) #checks if a piece of particular type is in
		@cells[pos[0]][pos[1]]
		pieces = color == 'black' ? @BLACK_SYMBOLS : @WHITE_SYMBOLS
		pieces.include?(@cells[pos[0]][pos[1]])
	end


	def squares_empty?(positions)
		return true if positions == nil
		if positions.all?{ |position| position.kind_of?(Array) }
			positions.all?{|position| @cells[position[0]][position[1]] == "   " }
		else
			@cells[positions[0]][positions[1]] == "   "
		end
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