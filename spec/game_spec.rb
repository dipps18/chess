require_relative '../lib/game'
require_relative '../lib/board'

describe Game do
  subject(:game) { described_class.new }

  describe '#update' do
    it 'should update position of white pawn to e4' do
      initial = game.board.coordinates('e2')
      final = game.board.coordinates('e4')
      expect{ game.update('e4', 'white') }.to change{ game.board.white[:pawns][4].pos}.from(initial).to(final)
    end
  end

  describe '#play' do
    before do
      allow(game).to receive(:input).and_return('a4', 'a5', 'e4', 'e5')
      allow(game).to receive(:gameover?).and_return(false, false, false, false, true)
    end

    it 'should change position of pawn at a2, a7, e2, e7' do
      a2 = game.board.coordinates('a2')
      a4 = game.board.coordinates('a4')
      a5 = game.board.coordinates('a5')
      a7 = game.board.coordinates('a7')
      e2 = game.board.coordinates('e2')
      e4 = game.board.coordinates('e4')
      e5 = game.board.coordinates('e5')
      e7 = game.board.coordinates('e7')
      expect{ game.play }.to change{ game.board.white[:pawns][0].pos }.from(a2).to(a4)
    end
  end
end