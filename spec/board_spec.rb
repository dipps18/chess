require_relative '../lib/board'

describe Board do
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
    subject(:board) { described_class.new }
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
    subject(:board) { described_class.new }
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
    subject(:board) { described_class.new }
    it 'should return [[6,0], [5, 0], [4, 0]] when position is [3, 0] ' do
      position = [3, 0]
      color = 'black'
      expect(board.top(position, color)).to eql([[4, 0], [5, 0], [6, 0]])
    end
  end
end