require_relative '../lib/board'

describe Board do
  let(:board) { described_class.new }
  describe '#initialize' do
    subject(:board_initialize) { described_class.new }

    it 'should contain 6 distinct white pieces' do
      expect(board_initialize.white.length).to eql(6)
    end

    it 'should contain 6 distinct black pieces' do
      expect(board_initialize.black.length).to eql(6)
    end
    
  end

  describe '#cell_empty' do
    subject(:board) { described_class.new }
    it 'should return true when position is empty' do
      position = [2, 0]
      expect(board.cell_empty?(position)).to eql(true)
    end

    it 'should return false when position is occupied' do
      position = [0, 0]
      expect(board.cell_empty?(position)).to eql(false)
    end
  end

  describe '#diag_top_right' do
    subject(:board) { described_class.new }
    context 'When piece is white' do
      it 'should return []] when no moves are available' do
        position = [7, 2]
        color = 'white'
        expect(board.diag_top_right(position, color)).to eql([])
      end

      it 'should return [] when position is [2, 0] and is blocked by piece of same color' do
        board.instance_eval('@cells[4][3] = " \u265F "')
        position = [5, 2]
        color = 'white'
        expect(board.diag_top_right(position, color)).to eq([])
      end

      it 'should return [[4, 2], [3, 3], [2, 4], [1, 5]]' do
        position = [5, 1]
        color = 'white'
        expect(board.diag_top_right(position, color)).to eql([[4, 2], [3, 3], [2, 4], [1, 5]])
      end
    end

    context 'When color is black' do
      it 'should return [] when no square is available' do
        position = [2, 0]
        board.instance_eval('@cells[2][0] = " \u265D "')
        color = 'black'
        expect(board.diag_top_right(position, color)).to eql([])
      end

      it 'should return [] when piece is blocked' do
        position = [0, 5]
        color = 'black'
        expect(board.diag_top_right(position, color)).to eql([])
      end

      it 'should return [[1, 4], [2, 3], [3, 2], [5, 1], [6, 0]] when position [0, 5]' do
        board.instance_eval('@cells[1][4] = "   "')
        position = [0, 5]
        color = 'black'
        expect(board.diag_top_right(position, color)).to eql( [[1, 4], [2, 3], [3, 2], [4, 1], [5, 0]])
      end
    end
  end

  describe '#diag_top_left' do
    context 'When piece is white' do
      it 'should return [] when no moves are available' do
        position = [5, 0]
        color = 'white'
        expect(board.diag_top_left(position, color)).to eql([])
      end

      it 'should return [] when position is [7, 2] and is blocked by piece of same color' do
        position = [7, 2]
        color = 'white'
        expect(board.diag_top_left(position, color)).to eq([])
      end

      it 'should return [4, 0]' do
        position = [5, 1]
        color = 'white'
        expect(board.diag_top_left(position, color)).to eql([[4, 0]])
      end
    end

    context 'When color is black' do
      it 'should return [] when no square is available' do
        position = [2, 7]
        color = 'black'
        expect(board.diag_top_left(position, color)).to eql([])
      end

      it 'should return [] when piece is blocked' do
        position = [0, 5]
        color = 'black'
        expect(board.diag_top_left(position, color)).to eql([])
      end

      it 'should return [[1, 4], [2, 3], [3, 2], [5, 1], [6, 0]] when position [0, 5]' do
        board.instance_eval('@cells[1][6] = "   "')
        position = [0, 5]
        color = 'black'
        expect(board.diag_top_left(position, color)).to eql( [[1, 6], [2, 7]])
      end
    end
  end

  describe '#diag_bottom_left' do
    context 'When piece is white' do
      it 'should return [] when no moves are available' do
        position = [7, 2]
        color = 'white'
        expect(board.diag_bottom_left(position, color)).to eql([])
      end

      it 'should return [] when position is [5, 4] and is blocked by piece of same color' do
        position = [5, 4]
        color = 'white'
        expect(board.diag_bottom_left(position, color)).to eq([])
      end

      it 'should return [[4, 5], [5, 4]] when position is [3, 6]' do
        position = [3, 6]
        color = 'white'
        expect(board.diag_bottom_left(position, color)).to eql([[4, 5], [5, 4]])
      end
    end

    context 'When color is black' do
      it 'should return [] when no square is available' do
        position = [0, 2]
        color = 'black'
        expect(board.diag_bottom_left(position, color)).to eql([])
      end

      it 'should return [] when piece is blocked' do
        position = [2, 3]
        color = 'black'
        expect(board.diag_bottom_left(position, color)).to eql([])
      end

      it 'should return [[4, 1], [3, 2], [2, 3]] when position [5, 0]' do
        board.instance_eval('@cells[1][6] = "   "')
        position = [5, 0]
        color = 'black'
        expect(board.diag_bottom_left(position, color)).to eql([[4, 1], [3, 2], [2, 3]])
      end
    end
  end

  describe '#top' do
    it 'should return [[6,0], [5, 0], [4, 0]] when position is [3, 0] ' do
      position = [3, 0]
      color = 'black'
      expect(board.top(position, color)).to eql([[4, 0], [5, 0], [6, 0]])
    end
  end

  describe '#destination' do
    context 'When input is valid' do
      it 'should return a3 when input is a3 and color is white' do
        input = 'Na3'
        expect(board.destination(input, 'white')).to eq([5, 0])
      end

      it 'should return c6 when input is Qxc6 and color is white' do
        input = 'Qxc6'
        board.instance_eval('@cells[2][2] = " \u265F "')
        expect(board.destination(input, 'white')).to eql([2, 2])
      end
    end

    context 'When input is invalid' do
      it 'should return nil when input is "a1" and color is white' do
        input = 'Ka1'
        expect(board.destination(input, 'white')).to eq(nil)
      end

      it 'should return nil when input is Qxc6 and color is black' do
        input = 'Qxc6'
        board.instance_eval('@cells[2][2] = " \u265F "')
        expect(board.destination(input, 'black')).to eql(nil)
      end

      it 'should return nil when input is Qc6 and piece is present on c6' do
        input = 'Qc6'
        board.instance_eval('@cells[2][2] = " \u265F "')
        expect(board.destination(input, 'white')).to eql(nil)
      end
    end
  end

  describe '#check?' do
    context 'When black king is in check' do
      it 'should return true when bishop targets king' do
        board.instance_eval('@cells[1][5] = "   "') # f7 square is empty
        board.instance_eval('@cells[2][6] = " \u265D "')
        board.black[:pawns].select{|pawn| pawn.pos == [1, 5]}[0].pos = [3, 5]
        board.white[:bishops][0].pos = board.coordinates('g6')
        board.update_next_moves
        expect(board.check?('black')).to eql(true)
      end
    end
  end

  describe '#valid_move?' do
    context 'When it is an invalid move' do
      before do
        bishop_pos = board.coordinates('b4')
        board.black[:bishops][0].pos = bishop_pos
        board.cells[bishop_pos[0]][bishop_pos[1]] = board.black[:bishops][0].sym
        board.update_next_moves
        board.display_board
        # p board.white[:pawns].select{|pawn| pawn.pos == pawn_pos}[0].next_moves
      end

      it 'should return false when origin is d2' do
        origin = board.coordinates('d2')
        destination = board.coordinates('d4')
        color = 'white'
        piece = board.white[:pawns].select{ |pawn| pawn.pos == origin }
        expect(board.valid_move?(destination, origin, piece[0], color)).to eql(false)

      end

      it 'should return true when origin is c2' do
        origin = board.coordinates('c2')
        destination = board.coordinates('c4')
        color = 'white'
        piece = board.white[:pawns].select{ |pawn| pawn.pos == origin }

        #board.display_board
        expect(board.valid_move?(destination, origin, piece[0], color)).to eql(true)
      end
    end

    context 'When it is a valid move' do
      it 'should return true when origin is d2' do
        origin = board.coordinates('d2')
        destination = board.coordinates('d4')
        color = 'white'
        piece = board.white[:pawns].select{ |pawn| pawn.pos == origin }
        expect(board.valid_move?(destination, origin, piece[0], color)).to eql(true)
      end
    end
  end

  describe '#update_position' do
    it 'should change position of piece' do
      destination = board.coordinates('a3')
      origin = board.coordinates('a2')
      color = 'white'
      board.update_position(destination, origin, color)
      expect(board.white[:pawns][0].pos).to eq(destination)
    end
  end

  describe '#checkmate?' do
    before do
      p_pos = board.coordinates('d2')
      p_dest = board.coordinates('d4')
      b_origin = board.black[:bishops][1].pos
      b_dest = board.coordinates('b4')
      board.white[:pawns].select{|pawn| pawn.pos ==p_pos}[0].pos = p_dest
      board.black[:bishops][1].pos = b_dest
      board.cells[p_pos[0]][p_pos[1]] = "   "
      board.cells[b_origin[0]][b_origin[1]] = "   "
      board.cells[p_dest[0]][p_dest[1]] = board.white[:pawns][0].sym
      board.cells[b_dest[0]][b_dest[1]] = board.black[:bishops][0].sym
      board.update_next_moves
    end

    it 'should return false when king can move' do
      expect(board.checkmate?('white')).to eql(false)
    end

    it 'should return true when king cannot move' do
      board.white[:bishops].delete_at(0)
      board.white[:knights].delete_at(0)
      board.white[:pawns].delete_at(2)
      board.white.delete(:queen)
      board.update_next_moves
      # board.white.values.flatten.each{|piece| p piece}
      expect(board.checkmate?('white')).to eql(true)
      # board.white.values.flatten.each{|piece| p piece.next_moves}
    end
  end

end