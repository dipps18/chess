require_relative '../lib/game'
require_relative '../lib/board'
describe Game do
  describe '#destination' do
    let(:board) { Board.new }
    subject(:game_destination) { described_class.new }
    context 'When input is valid' do

      it 'should return a3 when input is a3 and color is white' do
        input = 'Na3'
        expect(game_destination.destination(input, board, 'white')).to eq([5, 0])
      end

      it 'should return c6 when input is Qxc6 and color is white' do
        input = 'Qxc6'
        board.instance_eval('@cells[2][2] = " \u265F "')
        expect(game_destination.destination(input, board, 'white')).to eql([2, 2])
      end
    end

    context 'When input is invalid' do
      it 'should return nil when input is "a1" and color is white' do
        input = 'Ka1'
        expect(game_destination.destination(input, board, 'white')).to eq(nil)
      end
      it 'should return nil when input is Qxc6 and color is black' do
        input = 'Qxc6'
        board.instance_eval('@cells[2][2] = " \u265F "')
        expect(game_destination.destination(input, board, 'black')).to eql(nil)
      end
    end
  end
end