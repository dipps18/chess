require_relative '../lib/pawn'
require_relative '../lib/board'
require_relative '../lib/game'
describe Pawn do
  describe '#set_moves' do
    context 'when color is black ' do
      subject(:pawn_moves) { described_class.new('black') }
      let(:board) { Board.new }

      it 'should return [[2, 0], [3, 0]] when piece is at origin' do
        expect(pawn_moves.set_moves(board)).to eql([[2, 0], [3, 0]])
      end
      
      it 'should return [[2, 1], [3, 1], [2, 0]] when piece is at [1, 1] and piece of opp color in diagonal' do
        board.instance_eval('@cells[2][0] = " \u265F "')
        expect(pawn_moves.set_moves(board)).to eql([[2, 1], [3, 1], [2, 0]])
      end

      it 'should return [] when no position is available' do
        board.instance_eval('@cells[2][2] = " \u2657 "')
        expect(pawn_moves.set_moves(board)).to eql([])
      end

      it 'should return [2][3] when enpassant is possible' do
        board.instance_eval('@cells[2][3] = " \u265F "')
        allow(pawn_moves).to receive(:enpassant?).and_return(false, true)
        expect(pawn_moves.set_moves(board)).to eql([[2, 2]])
      end
    end

    context 'When color is white and position is [6, 0]' do
      subject(:pawn_moves) { described_class.new('white') }
      let(:board) { Board.new }
      before do
        pawn_moves.instance_eval('@pos = [6, 0]')
      end
      it 'should return [[5, 0], [4, 0]] when pawn is at origin' do
        expect(pawn_moves.set_moves(board)).to eql([[5, 0], [4, 0]])
      end

      it 'should return [[5,0], [4, 0], [5, 1]] when opp colored piece on [5,1]' do
        board.instance_eval('@cells[5][1] = " \u2659 "')
        expect(pawn_moves.set_moves(board)).to eql([[5,0], [4, 0], [5, 1]])
      end

      it 'should return [] when no position is available due to blocked piece' do
        board.instance_eval('@cells[5][0] = " \u2657 "')
        expect(pawn_moves.set_moves(board)).to eql([])
      end

      it 'should return [5, 0] when position [6, 0] is unavailable due to blocked piece' do
        board.instance_eval('@cells[4][0] = " \u2657 "')
        expect(pawn_moves.set_moves(board)).to eql([[5, 0]])
      end

    end
  end

  describe '#origin' do
    let(:board) { Board.new }
    let(:pawns) { board.black[:pawns] }


    context 'When origin is valid' do 
 
      before do
        pawns.each{|pawn| pawn.init_next_moves(board)}
      end

      it 'should return [2, 0] when a1 is played' do
        input = 'a3'
        destination = [2, 0]
        expect(Pawn.origin(input, destination, board.black)).to eql([1,0])
      end

      it 'should return [2, 1] ' do
        input = 'axb3'
        destination = [2, 1]
        expect(Pawn.origin(input, destination, board.black)).to eql([1, 0])
      end
    end

    context 'When origin is invalid' do
      before do
        pawns.each{|pawn| pawn.init_next_moves(board)}
      end

      it 'should return nil' do
        input = 'a1'
        destination = [0, 0]
        expect(Pawn.origin(input, destination, board.black)).to eql(nil)
      end
    end
  end

end
