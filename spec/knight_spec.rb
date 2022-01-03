require_relative '../lib/knight'
require_relative '../lib/board'
describe Knight do
  describe '#valid_move' do
    subject(:knight) { described_class.new('black', [0, 1]) }
    it 'should return true when position is [0, 1] and destination is [2, 1]' do
      destination = [2, 1]
      expect(Knight.valid_move(destination)).to eql(true)
    end
  end

  describe '#set_moves' do
    let(:board) { Board.new }
    subject(:knight) { described_class.new('black', [0, 1])}

    it 'should return [[2, 2], [2, 0]] when position is [0, 1]' do
      expect(knight.all_moves(board)).to eql([[2, 2], [2, 0]])
    end
  end
end