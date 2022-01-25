require_relative '../lib/game'
require_relative '../lib/board'
require 'byebug'
describe Game do
  subject(:game) { described_class.new }

  describe '#update' do
    it 'should update position of white pawn to e4' do
      initial =  Board.coordinates('e2')
      final = Board.coordinates('e4')
      expect{ game.update('e4', 'white') }.to change{ game.board.white[:pawns][4].pos}.from(initial).to(final)
    end

    it 'should update position of the white king for king side castle' do
      game.board.remove_piece(Board.coordinates('f1'))
      game.board.remove_piece(Board.coordinates('g1'))
      game.board.update_next_moves
      old_pos = Board.coordinates('e1')
      new_pos = Board.coordinates('g1')
      expect{ game.update('O-O', 'white') }.to change{ game.board.white[:king][0].pos}.from(old_pos).to(new_pos)
    end

    it 'should update position of the white king for queen side castle' do
      game.board.remove_piece(Board.coordinates('b1'))
      game.board.remove_piece(Board.coordinates('c1'))
      game.board.remove_piece(Board.coordinates('d1'))
      game.board.update_next_moves
      old_pos = Board.coordinates('e1')
      new_pos = Board.coordinates('c1')
      expect{ game.update('O-O-O', 'white') }.to change{ game.board.white[:king][0].pos }.from(old_pos).to(new_pos)
    end

    it 'should update position of the white rook for queen side castle' do
      game.board.remove_piece(Board.coordinates('b1'))
      game.board.remove_piece(Board.coordinates('c1'))
      game.board.remove_piece(Board.coordinates('d1'))
      game.board.update_next_moves
      old_pos = Board.coordinates('a1')
      new_pos = Board.coordinates('d1')
      expect{ game .update('O-O-O', 'white') }.to change{ game.board.white[:rooks][0].pos }.from(old_pos).to(new_pos)
    end

    it 'should update position of black pawn to e5' do
      initial =  Board.coordinates('e7')
      final = Board.coordinates('e5')
      expect{ game.update('e5', 'black') }.to change{ game.board.black[:pawns][4].pos}.from(initial).to(final)
    end
  end

  describe '#pawn_move' do
    it 'should return true when input is a4' do
      input = 'a4'
      expect(Game.pawn_move?(input)).to eql(true)
    end

    it 'should return true when input is axb2' do
      input = 'axb2'
      expect(Game.pawn_move?(input)).to eql(true)
    end

    it 'should return false when input is aa2' do
      input = 'aa2'
      expect(Game.pawn_move?(input)).to eql(false)
    end
  end

  describe '#king_move' do
    it 'should return true when input is Ka4' do
      input = 'Ka4'
      expect(Game.king_move?(input)).to eql(true)
    end

    it 'should return true when input is Kxb2' do
      input = 'Kxb2'
      expect(Game.king_move?(input)).to eql(true)
    end

    it 'should return false when input is Kx2' do
      input = 'Kx2'
      expect(Game.king_move?(input)).to eql(false)
    end
  end

  describe '#piece_move?' do
    it 'should return true when input is Nc4' do
      input = 'Nc4'
      expect(Game.piece_move?(input)).to eql(true)
    end

    it 'should return true when input is Nxc4' do
      input = 'Nxc4'
      expect(Game.piece_move?(input)).to eql(true)
    end

    it 'should return true when input is N3xc4' do
      input = 'N3xc4'
      expect(Game.piece_move?(input)).to eql(true)
    end

    it 'should return true when input is Ndc4' do
      input = 'Ndc4'
      expect(Game.piece_move?(input)).to eql(true)
    end
    
    it 'should return true when input is Ndxc4' do
      input = 'N3xc4'
      expect(Game.piece_move?(input)).to eql(true)
    end

    it 'should return true when input is Nba4' do
      input = 'Nba4'
      expect(Game.piece_move?(input)).to eql(true)
    end

  end

  describe 'Game.promotion' do
    it 'should return true when the input is a8=R' do
      input = 'a8=R'
      expect(Game.promotion?(input)).to eql(true)
    end

    it 'should return false when the input is a7=R' do
      input = 'a7=R'
      expect(Game.promotion?(input)).to eql(false)
    end
  end


  describe '#input' do
    context 'When the input is right' do
        it 'should return input' do
        input = 'a4'
        allow(game).to receive(:gets).and_return(input)
        expect(game.input('white')).to eql(input)
      end
    end

    context 'When input is wrong' do
      it 'should display error message and ask user to input again' do
      end  
    end
  end

  describe '#play' do
    # before do
    #   allow(game).to receive(:input).and_return('b4', 'a5', 'e4', 'e5')
    # end

    # it 'should change position of pawn at b2, a7, e2, e7' do
    #   b2 = Board.coordinates('b2')
    #   b4 = Board.coordinates('b4')
    #   a5 = Board.coordinates('a5')
    #   a7 = Board.coordinates('a7')
    #   e2 = Board.coordinates('e2')
    #   e4 = Board.coordinates('e4')
    #   e5 = Board.coordinates('e5')
    #   e7 = Board.coordinates('e7')
    #   expect{ game.play }.to change{ game.board.white[:pawns][1].pos }.from(b2).to(b4)
    # end

    # it 'should reduce the size of pieces by 1' do
    #   allow(game).to receive(:gameover?).and_return(false, false, false, false, false, true)
    #   byebug
    #   allow(game).to receive(:gets).and_return('e4', 'd5', 'Bb5', 'Bd7', 'a3', 'Bxb5')
    #   length = game.board.pieces.length
    #   expect{ game.play }.to change{ game.board.pieces.length }.from(length).to(length - 1)
    # end

    it 'should reduce the size of pieces by 1' do
      allow(game).to receive(:gameover?).and_return(false, false, false, false, false, true)
      allow(game).to receive(:input).and_return('e4', 'd5', 'Bb5+', 'Bd7', 'a3', 'Bxb5')
      
      expect{game.play}.to change{game.board.white[:bishops].length}.from(2).to(1)
    end

    # it 'final position of e4 pawns should be c2' do
    #   allow(game).to receive(:gameover?).and_return(false, false, false, false, true)
    #   allow(game).to receive(:input).and_return('e4', 'd5', 'exd5', 'Nc6', 'dxc6')
    #   byebug
    #   e4_pawn = game.board.white[:pawns][4]
    #   # expect{ game.play }.to change{ e4_pawn.pos }.from(Board.coordinates('e2')).to(Board.coordinates('c6'))
    #   byebug
    # end

    it 'should change position of black rook to f8' do
      old_pos = Board.coordinates('h8')
      new_pos = Board.coordinates('f8')
      allow(game).to receive(:input).and_return('d4', 'Nf6', 'c4', 'g6', 'Nc3', 'd5', 'cxd5', 'Nxd5', 'e4', 'Nxc3', 'bxc3', 'Bg7', 'Nf3', 'c5', 'Rb1', 'O-O', 'Be2', 'cxd4', 'cxd4', 'Qa5+', 'Bd2', 'Qxa2', 'O-O', 'Bg4', 'Rxb7', 'Bxf3', 'Bxf3', 'Bxd4', 'Bb4', 'Rd8', 'Qc1', 'e5', 'Be7', 'Re8', 'Bf6', 'Qa6', 'Qg5','Re6', 'Bh8', 'Kxh8', 'Rxf7', 'Kg8', 'Rc7', 'Qd6', 'Rc8+', 'Kg7', 'Rfc1', 'Bb6', 'Bd1', 'Qe7', 'Qg4', 'h5', 'Qh3', 'Rf6', 'Bb3', 'Rxf2', 'Kh1', 'Qf6' ,'Qd3', 'Qg5', 'Rg1', 'Rd2', 'Qc4', 'Qf6', 'Rf1', 'Rf2', 'Rxf2', 'Bxf2', 'Qg8+', 'Kh6', 'Rf8', 'Qg7', 'Bd5', 'Qxg8', 'Rxg8', 'a5', 'Bxa8', 'Nd7', 'Bc6', 'Nb6', 'Be8', 'a4', 'Rxg6+', 'Kh7', 'Rxb6', 'Bxb6', 'Bxh5', 'Kh6', 'Bf7', 'a3', 'g3', 'Kg5', 'Kg2', 'Kf6', 'Bd5', 'Kg5', 'h4+', 'Kf6', 'Kh3', 'Bd4', 'g4', 'Kg6', 'g5', 'Bf2', 'Kg4', 'Be3', 'h5+', 'Kg7', 'Kf5', 'Bf4', 'h6+', 'Kh8', 'Kg6', 'Bd2', 'Kh5', 'a2', 'Bxa2', 'Be3', 'Be6', 'Bf4', 'Bd7')
      game.play
    end

    it 'should work nice' do
      allow(game).to receive(:gameover?).and_return(false, false, false, false, true)
      allow(game).to receive(:input).and_return('e4', 'd5', 'Bb5+', 'Bd7', 'Bxd7')
      expect{ game.play }.to change{ game.board.black[:bishops].length }.from(2).to(1)
    end

    it 'should work nice 2' do
      allow(game).to receive(:gameover?).and_return(false, false, false, false, false, false, false, true)
      allow(game).to receive(:input).and_return('e4', 'e5', 'Nf3', 'Nc6', 'Bb5', 'a6', 'Ba4', 'Nf6')
      game.play
    end

    it 'should work nice 3' do
      allow(game).to receive(:gameover?).and_return(false, false, false, false, true)
      allow(game).to receive(:input).and_return('e4', 'a5', 'e5', 'd5', 'exd6')
      game.play
    end

    it 'should work nice 3' do
      allow(game).to receive(:gameover?).and_return(false, false, false, false, false, true)
      allow(game).to receive(:input).and_return('e4', 'd5', 'Bb5+', 'Bd7', 'a4', 'Bxb5')
      game.play
    end

  end

  describe '#can_castle?' do
    context 'When king side castling is not possible' do
      context 'When color of player castling is black' do
        it 'should return false when pieces b/w king and rook' do
          expect(game.can_castle?('O-O', 'black')).to eql(false)
        end

        it 'should return false when king passes through a square which is in check' do
          bish_pos = Board.coordinates('c4') #checking bishop
          pawn_old_pos = Board.coordinates('f7')
          pawn_new_pos = Board.coordinates('f5')
          bishop_new_pos = Board.coordinates('c5')
          knight_new_pos = Board.coordinates('f6')
          game.board.black[:pawns].each do |pawn|
            pawn.pos = pawn_new_pos if pawn.pos == pawn_old_pos
          end
          game.board.black[:bishops][1].pos = bishop_new_pos
          game.board.white[:bishops][0].pos = bish_pos
          game.board.black[:knights][1].pos = knight_new_pos
          game.board.update_cells
          game.board.display_board
          game.board.update_next_moves
          expect(game.can_castle?('O-O', 'black')).to eql(false)
        end

        it 'should return false when king or rook have moved' do
          game.board.black[:king][0].moved = true
          expect(game.can_castle?('O-O','black')).to eql(false)
        end
      end

      context 'When color is white' do
        it 'should return false when pieces b/w king and rook' do
          expect(game.can_castle?('O-O', 'white')).to eql(false)
        end

        it 'should return false when king passes through a square which is in check' do
          bish_pos = Board.coordinates('c5') #checking bishop
          pawn_old_pos = Board.coordinates('f2')
          pawn_new_pos = Board.coordinates('f4')
          bishop_new_pos = Board.coordinates('c4')
          knight_new_pos = Board.coordinates('f3')
          game.board.white[:pawns].each do |pawn|
            pawn.pos = pawn_new_pos if pawn.pos == pawn_old_pos
          end
          game.board.white[:bishops][1].pos = bishop_new_pos
          game.board.black[:bishops][0].pos = bish_pos
          game.board.white[:knights][1].pos = knight_new_pos
          game.board.update_cells
          game.board.update_next_moves
          game.board.display_board
          expect(game.can_castle?('O-O','white')).to eql(false)
        end

        it 'should return false when king or rook have moved' do
          game.board.white[:rooks][1].moved = true
          expect(game.can_castle?('O-O','white')).to eql(false)
        end
      end
    end
    
    context 'When king castling is possible' do
      context 'When color is black' do
        it 'should return true' do
          pawn_old_pos = Board.coordinates('f7')
          pawn_new_pos = Board.coordinates('f5')
          bishop_new_pos = Board.coordinates('c5')
          knight_new_pos = Board.coordinates('f6')
          game.board.black[:pawns].each do |pawn|
            pawn.pos = pawn_new_pos if pawn.pos == pawn_old_pos
          end
          game.board.black[:bishops][1].pos = bishop_new_pos
          game.board.black[:knights][1].pos = knight_new_pos
          game.board.update_cells
          game.board.display_board
          game.board.update_next_moves
          expect(game.can_castle?('O-O', 'black')).to eql(true)
        end
      end

      context 'When color is white' do
        it 'should return true' do
          pawn_old_pos = Board.coordinates('f2')
          pawn_new_pos = Board.coordinates('f4')
          bishop_new_pos = Board.coordinates('c4')
          knight_new_pos = Board.coordinates('f3')
          game.board.white[:pawns].each do |pawn|
            pawn.pos = pawn_new_pos if pawn.pos == pawn_old_pos
          end
          game.board.white[:bishops][1].pos = bishop_new_pos
          game.board.white[:knights][1].pos = knight_new_pos
          game.board.update_cells
          game.board.update_next_moves
          game.board.display_board
          expect(game.can_castle?('O-O', 'white')).to eql(true)
        end
      end
    end

    context 'When queen castling is not possible' do
      context 'When castling color is black' do
        it 'should return false when pieces b/w king and rook' do
          expect(game.can_castle?('O-O-O', 'black')).to eql(false)
        end

        it 'should return false when king passes through a square which is in check' do
          bish_pos = Board.coordinates('f4') #checking bishop
          pawn_old_pos = Board.coordinates('c7')
          pawn_new_pos = Board.coordinates('c5')
          bishop_new_pos = Board.coordinates('f5')
          knight_new_pos = Board.coordinates('c6')
          queen_new_pos = Board.coordinates('d5')
          game.board.black[:pawns].each do |pawn|
            pawn.pos = pawn_new_pos if pawn.pos == pawn_old_pos
          end
          game.board.black[:bishops][1].pos = bishop_new_pos
          game.board.white[:bishops][0].pos = bish_pos
          game.board.black[:knights][1].pos = knight_new_pos
          game.board.black[:queen][0].pos = queen_new_pos
          game.board.update_cells
          game.board.display_board
          game.board.update_next_moves
          expect(game.can_castle?('O-O-O', 'black')).to eql(false)
        end

        it 'should return false when king or rook have moved' do
          game.board.black[:king][0].moved = true
          expect(game.can_castle?('O-O-O','black')).to eql(false)
        end
      end

      context 'When color is white' do
        it 'should return false when pieces b/w king and rook' do
          expect(game.can_castle?('O-O-O', 'white')).to eql(false)
        end

        it 'should return false when king passes through a square which is in check' do
          bish_pos = Board.coordinates('f5') #checking bishop
          pawn_old_pos = Board.coordinates('c2')
          pawn_new_pos = Board.coordinates('c4')
          bishop_new_pos = Board.coordinates('f4')
          knight_new_pos = Board.coordinates('c3')
          queen_new_pos = Board.coordinates('d5')
          game.board.white[:pawns].each do |pawn|
            pawn.pos = pawn_new_pos if pawn.pos == pawn_old_pos
          end
          game.board.white[:bishops][1].pos = bishop_new_pos
          game.board.black[:bishops][0].pos = bish_pos
          game.board.white[:knights][1].pos = knight_new_pos
          game.board.white[:queen][0].pos = queen_new_pos
          game.board.update_cells
          game.board.update_next_moves
          game.board.display_board
          expect(game.can_castle?('O-O-O','white')).to eql(false)
        end

        it 'should return false when king or rook have moved' do
          game.board.white[:rooks][1].moved = true
          expect(game.can_castle?('O-O-O','white')).to eql(false)
        end
      end
    end
    

    context 'When queen castling is possible' do
      context 'When color is black' do
        it 'should return true' do
          pawn_old_pos = Board.coordinates('c7')
          pawn_new_pos = Board.coordinates('c5')
          bishop_new_pos = Board.coordinates('f5')
          knight_new_pos = Board.coordinates('c6')
          queen_new_pos = Board.coordinates('d5')
          game.board.black[:pawns].each do |pawn|
            pawn.pos = pawn_new_pos if pawn.pos == pawn_old_pos
          end
          game.board.black[:bishops][0].pos = bishop_new_pos
          game.board.black[:knights][0].pos = knight_new_pos
          game.board.black[:queen][0].pos = queen_new_pos
          game.board.update_cells
          game.board.display_board
          game.board.update_next_moves
          expect(game.can_castle?('O-O-O', 'black')).to eql(true)
        end
      end

      context 'When color is white' do
        it 'should return true' do
          pawn_old_pos = Board.coordinates('c2')
          pawn_new_pos = Board.coordinates('c4')
          bishop_new_pos = Board.coordinates('f4')
          knight_new_pos = Board.coordinates('c3')
          queen_new_pos = Board.coordinates('d5')
          game.board.white[:pawns].each do |pawn|
            pawn.pos = pawn_new_pos if pawn.pos == pawn_old_pos
          end
          game.board.white[:bishops][0].pos = bishop_new_pos
          game.board.white[:knights][0].pos = knight_new_pos
          game.board.white[:queen][0].pos = queen_new_pos
          game.board.update_cells
          game.board.update_next_moves
          game.board.display_board
          expect(game.can_castle?('O-O-O', 'white')).to eql(true)
        end
      end
    end
  end

  describe '#promote_piece' do
    before do
      game.board.pieces.each do |piece|
        if !piece.kind_of?(Pawn) && !piece.kind_of?(King)
          game.board.remove_piece(piece.pos)
        end
      end

      game.board.white.values.flatten.each do |piece|
        if !piece.kind_of?(Pawn) && !piece.kind_of?(King)
          game.board.remove_piece(piece.pos)
        end
      end

      game.board.black.values.flatten.each do |piece|
        if !piece.kind_of?(Pawn) && !piece.kind_of?(King)
          game.board.remove_piece(piece.pos)
        end
      end
      game.board.update_cells
    end

    context 'When color is white' do
      it 'should promote piece to queen' do
        game.board.remove_piece(Board.coordinates('d7'))
        game.board.white[:pawns][3].pos = Board.coordinates('d7')
        game.board.update_next_moves
        game.board.update_cells
        game.board.display_board
        input = 'd8=Q'
        color = 'white'
        expect{game.promote_piece(input, color)}.to change{game.board.white[:pawns].length}.by(-1)
      end
    end
    context 'When color is black' do
      it 'should promote piece to queen' do
        game.board.remove_piece(Board.coordinates('d2'))
        game.board.black[:pawns][3].pos = Board.coordinates('d2')
        game.board.update_next_moves
        game.board.update_cells
        game.board.display_board
        input = 'd1=B'
        color = 'black'
        expect{game.promote_piece(input, color)}.to change{game.board.black[:bishops].length}.from(0).to(1)
      end
    end
  end

end