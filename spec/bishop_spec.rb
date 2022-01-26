require_relative '../lib/bishop'
require_relative '../lib/board'
describe Bishop do
  describe '#origin' do
    subject(:board) {Board.new}
    context 'When valid input is given' do
      it 'should return [7, 2]' do
        board.remove_piece([6, 3])
        board.update_next_moves
        input = 'Bh6'
        destination = [2, 7]
        pieces = board.white
        expect(Bishop.origin(input, destination, pieces)).to eql([7, 2])
      end
      
      context 'When 2 bishops are on the same row' do
        before do
          bishop_pos =  Board.coordinates('d3')
          bishop = Bishop.new('white', bishop_pos)
          board.white[:bishops].push(bishop)
          board.pieces.push(bishop)

        end
        it 'should return ' do
          board.white[:bishops][0].pos = Board.coordinates('f3')
          board.update_cells
          board.update_next_moves
          destination = Board.coordinates('e4')
          input = 'Bde4'
          pieces = board.white
          expect(Bishop.origin(input, destination, pieces)).to eql(Board.coordinates('d3'))
        end
      en5d

      context 'When 2 bishops are in the same column(file)' do
        before do
          bishop = Bishop.new('white', [5, 3])
          board.pieces.push(bishop)
          board.white[:bishops].push(bishop).select{ |bishop| bishop.pos == [7, 5] }.map!{ |bishop| bishop.pos = [1, 3] }
          board.update_next_moves
        end

        it 'should return ' do
          destination = Board.coordinates('f5')
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