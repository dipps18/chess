require_relative '../lib/bishop'
require_relative '../lib/board'
describe Bishop do
  describe '#origin' do
    subject(:board) {Board.new}
    context 'When valid input is given' do
      it 'should return [7, 2]' do
        board.instance_eval('@cells[6][3] = "   "')
        board.white[:bishops].each{ |bishop| bishop.init_next_moves(board) }
        input = 'Bh3'
        destination = [2, 7]
        pieces = board.white
        expect(Bishop.origin(input, destination, pieces))
      end
      
      context 'When 2 bishops are on the same row' do
        before do
          board.white[:bishops].push(Bishop.new('white', [5, 3])).select{ |bishop| bishop.pos == [7, 5] }.map!{ |bishop| bishop.pos = [5, 5] }
          board.white[:bishops].each{ |bishop| bishop.init_next_moves(board) }
        end
        it 'should return ' do
          destination = [4, 4]
          input = 'Bde4'
          pieces = board.white
          expect(Bishop.origin(input, destination, pieces)).to eql([5, 3])
        end
      end

      context 'When 2 bishops are in the same column(file)' do
        before do
          board.white[:bishops].push(Bishop.new('white', [5, 3])).select{ |bishop| bishop.pos == [7, 5] }.map!{ |bishop| bishop.pos = [1, 3] }
          board.white[:bishops].each{ |bishop| bishop.init_next_moves(board) }
        end

        it 'should return ' do
          destination = [3, 5]
          input = 'B3f5'
          pieces = board.white
          expect(Bishop.origin(input, destination, pieces)).to eql([5, 3])
        end
      end
    end

    context 'When invalid input is given' do
      
    end
  end
end