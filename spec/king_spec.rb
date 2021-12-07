require_relative '../lib/king'
require_relative '../lib/board'

describe King do
  describe '#set_moves' do
    subject(:king){ described_class.new('black')}
    let(:board) { Board.new }

    it 'should return nil when no position available' do
      expect(king.set_moves(board)).to eql(nil)
    end
  end
end