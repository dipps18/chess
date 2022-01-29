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
     game.remove_piece(Board.coordinates('f1'))
     game.remove_piece(Board.coordinates('g1'))
      game.update_next_moves
      old_pos = Board.coordinates('e1')
      new_pos = Board.coordinates('g1')
      expect{ game.update('O-O', 'white') }.to change{ game.board.white[:king][0].pos}.from(old_pos).to(new_pos)
    end

    it 'should update position of the white king for queen side castle' do
     game.remove_piece(Board.coordinates('b1'))
     game.remove_piece(Board.coordinates('c1'))
     game.remove_piece(Board.coordinates('d1'))
      game.update_next_moves
      old_pos = Board.coordinates('e1')
      new_pos = Board.coordinates('c1')
      expect{ game.update('O-O-O', 'white') }.to change{ game.board.white[:king][0].pos }.from(old_pos).to(new_pos)
    end

    it 'should update position of the white rook for queen side castle' do
     game.remove_piece(Board.coordinates('b1'))
     game.remove_piece(Board.coordinates('c1'))
     game.remove_piece(Board.coordinates('d1'))
      game.update_next_moves
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
      expect(game.pawn_move?(input)).to eql(true)
    end

    it 'should return true when input is axb2' do
      input = 'axb2'
      expect(game.pawn_move?(input)).to eql(true)
    end

    it 'should return false when input is aa2' do
      input = 'aa2'
      expect(game.pawn_move?(input)).to eql(false)
    end
  end

  describe '#king_move' do
    it 'should return true when input is Ka4' do
      input = 'Ka4'
      expect(game.king_move?(input)).to eql(true)
    end

    it 'should return true when input is Kxb2' do
      input = 'Kxb2'
      expect(game.king_move?(input)).to eql(true)
    end

    it 'should return false when input is Kx2' do
      input = 'Kx2'
      expect(game.king_move?(input)).to eql(false)
    end
  end

  describe '#piece_move?' do
    it 'should return true when input is Nc4' do
      input = 'Nc4'
      expect(game.piece_move?(input)).to eql(true)
    end

    it 'should return true when input is Nxc4' do
      input = 'Nxc4'
      expect(game.piece_move?(input)).to eql(true)
    end

    it 'should return true when input is N3xc4' do
      input = 'N3xc4'
      expect(game.piece_move?(input)).to eql(true)
    end

    it 'should return true when input is Ndc4' do
      input = 'Ndc4'
      expect(game.piece_move?(input)).to eql(true)
    end
    
    it 'should return true when input is Ndxc4' do
      input = 'N3xc4'
      expect(game.piece_move?(input)).to eql(true)
    end

    it 'should return true when input is Nba4' do
      input = 'Nba4'
      expect(game.piece_move?(input)).to eql(true)
    end

  end

  describe 'Game.promotion' do
    it 'should return true when the input is a8=R' do
      input = 'a8=R'
      expect(game.promotion?(input)).to eql(true)
    end

    it 'should return false when the input is a7=R' do
      input = 'a7=R'
      expect(game.promotion?(input)).to eql(false)
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
      allow(game).to receive(:input).and_return('e4', 'd5', 'Bb5+', 'Bd7', 'a3', 'Bxb5', 'resign')
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
      allow(game).to receive(:input).and_return('d4', 'Nf6', 'c4', 'g6', 'Nc3', 'd5', 'cxd5', 'Nxd5', 'e4', 'Nxc3', 'bxc3', 'Bg7', 'Nf3', 'c5', 'Rb1', 'O-O', 'Be2', 'cxd4', 'cxd4', 'Qa5+', 'Bd2', 'Qxa2', 'O-O', 'Bg4', 'Rxb7', 'Bxf3', 'Bxf3', 'Bxd4', 'Bb4', 'Rd8', 'Qc1', 'e5', 'Be7', 'Re8', 'Bf6', 'Qa6', 'Qg5','Re6', 'Bh8', 'Kxh8', 'Rxf7', 'Kg8', 'Rc7', 'Qd6', 'Rc8+', 'Kg7', 'Rfc1', 'Bb6', 'Bd1', 'Qe7', 'Qg4', 'h5', 'Qh3', 'Rf6', 'Bb3', 'Rxf2', 'Kh1', 'Qf6' ,'Qd3', 'Qg5', 'Rg1', 'Rd2', 'Qc4', 'Qf6', 'Rf1', 'Rf2', 'Rxf2', 'Bxf2', 'Qg8+', 'Kh6', 'Rf8', 'Qg7', 'Bd5', 'Qxg8', 'Rxg8', 'a5', 'Bxa8', 'Nd7', 'Bc6', 'Nb6', 'Be8', 'a4', 'Rxg6+', 'Kh7', 'Rxb6', 'Bxb6', 'Bxh5', 'Kh6', 'Bf7', 'a3', 'g3', 'Kg5', 'Kg2', 'Kf6', 'Bd5', 'Kg5', 'h4+', 'Kf6', 'Kh3', 'Bd4', 'g4', 'Kg6', 'g5', 'Bf2', 'Kg4', 'Be3', 'h5+', 'Kg7', 'Kf5', 'Bf4', 'h6+', 'Kh8', 'Kg6', 'Bd2', 'Kh5', 'a2', 'Bxa2', 'Be3', 'Be6', 'Bf4', 'Bd7', 'resign')
      game.play
    end

    it 'should work nice' do
      allow(game).to receive(:input).and_return('e4', 'd5', 'Bb5+', 'Bd7', 'Bxd7', 'resign')
      expect{ game.play }.to change{ game.board.black[:bishops].length }.from(2).to(1)
    end

    it 'should work nice 2' do
      allow(game).to receive(:input).and_return('e4', 'e5', 'Nf3', 'Nc6', 'Bb5', 'a6', 'Ba4', 'Nf6', 'resign')
      game.play
    end

    it 'should work nice 3' do
      allow(game).to receive(:input).and_return('e4', 'a5', 'e5', 'd5', 'exd6', 'resign')
      game.play
    end

    it 'should work nice 4' do
      allow(game).to receive(:input).and_return('e4', 'd5', 'Bb5+', 'Bd7', 'a4', 'Bxb5', 'resign')
      game.play
    end

    
  end

  describe '#destination' do
    context 'When input is valid' do
      it 'should return a3 when input is a3 and color is white' do
        input = 'Na3'
        expect(game.destination(input, 'white')).to eq([5, 0])
      end

      # it 'should return d5 when capturing pawn at d4 by enpassant' do
      #   board.black[:pawns][0].pos = Board.coordinates('d4')
      #   board.white[:pawns][0].pos = Board.coordinates('e4')
      # end

      it 'should return c6 when input is Qxc6 and color is white' do
        input = 'Qxc6'
        game.board.instance_eval('@cells[2][2] = " \u265F "')
        expect(game.destination(input, 'white')).to eql([2, 2])
      end
    end

    context 'When input is invalid' do
      it 'should return nil when input is "a1" and color is white' do
        input = 'Ka1'
        expect(game.destination(input, 'white')).to eq(nil)
      end

      it 'should return nil when input is Qxc6 and color is black' do
        input = 'Qxc6'
        game.board.instance_eval('@cells[2][2] = " \u265F "')
        expect(game.destination(input, 'black')).to eql(nil)
      end

      it 'should return nil when input is Qc6 and piece is present on c6' do
        input = 'Qc6'
        game.board.instance_eval('@cells[2][2] = " \u265F "')
        expect(game.destination(input, 'white')).to eql(nil)
      end
    end
  end

  describe '#check?' do
    context 'When black king is in check' do
      it 'should return true when bishop targets king' do
        game.board.instance_eval('@cells[1][5] = "   "') # f7 square is empty
        game.board.instance_eval('@cells[2][6] = " \u265D "')
        game.board.black[:pawns].select{|pawn| pawn.pos == [1, 5]}[0].pos = [3, 5]
        game.board.white[:bishops][0].pos = Board.coordinates('g6')
        game.update_next_moves
        expect(game.check?('black')).to eql(true)
      end
    end
  end

  describe '#valid_move?' do
    context 'When it is an invalid move' do
      before do
        bishop_pos = Board.coordinates('b4')
        bishop = game.board.black[:bishops][0]
        bishop.pos = bishop_pos
        game.board.cells[bishop_pos[0]][bishop_pos[1]] = bishop.sym
        game.update_next_moves
        game.board.display_board
      end

      it 'should return false when origin is d2' do
        origin = Board.coordinates('d2')
        destination = Board.coordinates('d4')
        color = 'white'
        piece = game.board.white[:pawns].select{ |pawn| pawn.pos == origin }
        expect(game.valid_move?(destination, origin, color, false, piece[0])).to eql(false)
      end
    end

    context 'When it is a valid move' do
      it 'should return true when origin is c2' do
        origin = Board.coordinates('c2')
        destination = Board.coordinates('c4')
        color = 'white'
        piece = game.board.white[:pawns].select{ |pawn| pawn.pos == origin }
        game.board.display_board
        expect(game.valid_move?(destination, origin, color, false, piece[0])).to eql(true)
      end

      it 'should return true when origin is d2' do
        origin = Board.coordinates('d2')
        destination = Board.coordinates('d4')
        color = 'white'
        game.board.display_board
        piece = game.board.white[:pawns].select{ |pawn| pawn.pos == origin }
        expect(game.valid_move?(destination, origin, color, false, piece[0])).to eql(true)
      end

      it 'should return true when input is exd6(enpassant)' do
        passing_pawn = game.board.white[:pawns][5]
        input = 'exd6'
        passing_pawn_old_pos = Board.coordinates('e5')
        passing_pawn.pos = passing_pawn_old_pos
        passing_pawn_new_pos = Board.coordinates('d6')
        passed_pawn = game.board.black[:pawns][4]
        passed_pawn.pos = Board.coordinates('d5')
        passed_pawn.enpossible = true
        game.update_next_moves
        expect(game.valid_move?(passing_pawn_new_pos, passing_pawn_old_pos, 'white', true, passing_pawn, input)).to eql(true)
      end
    end
  end

  describe '#update_position' do
    it 'should change position of piece' do
      old_pos = Board.coordinates('a2')
      new_pos = Board.coordinates('a3')
      color = 'white'
      game.update_position(new_pos, old_pos)
      expect(game.board.white[:pawns][0].pos).to eq(new_pos)
    end
  end

  describe '#checkmate?' do
    before do
      p_pos = Board.coordinates('d2')
      p_dest = Board.coordinates('d4')
      b_origin = game.board.black[:bishops][1].pos
      b_dest = Board.coordinates('b4')
      game.board.white[:pawns].select{|pawn| pawn.pos ==p_pos}[0].pos = p_dest
      game.board.black[:bishops][1].pos = b_dest
      game.board.update_cells
      game.update_next_moves
    end

    it 'should return false when king can move' do
      expect(game.checkmate?('white')).to eql(false)
    end

    it 'should return true when king cannot move' do
      game.board.white[:bishops].delete_at(0)
      game.board.white[:knights].delete_at(0)
      game.board.white[:pawns].delete_at(2)
      game.board.white.delete(:queen)
      game.update_next_moves
      expect(game.checkmate?('white')).to eql(true)
    end
  end

  describe '#stalemate?' do
    context 'When stalemate' do
      before do
        game.board.white.delete_if{ |key, value| key != :king }
        game.board.black.delete_if{ |key, value| key != :king && key!= :pawns }
        game.board.pieces.delete_if{ |piece| piece.sym != " \u2659 " || piece.sym != " \u2654 " || " \u265A " }
        game.update_next_moves
        game.board.black[:pawns].slice!(0, 6)
        game.board.black[:pawns][0].pos = [1, 2]
        game.board.black[:king][0].pos = [2, 0]
        game.board.white[:king][0].pos = [0, 0]
        game.board.display_board
      end

      it 'should return true when stalemate' do
        expect(game.stalemate?('white')).to eql(true)
      end
    end

    context 'When not stalemate' do
      before do
        game.update_next_moves
      end
      it 'should return false when not stalemate' do
        expect(game.stalemate?('white')).to eql(false)
      end
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
          game.update_next_moves
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
          game.update_next_moves
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
          game.update_next_moves
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
          game.update_next_moves
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
          game.update_next_moves
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
          game.update_next_moves
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
          game.update_next_moves
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
          game.update_next_moves
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
         game.remove_piece(piece.pos)
        end
      end

      game.board.white.values.flatten.each do |piece|
        if !piece.kind_of?(Pawn) && !piece.kind_of?(King)
         game.remove_piece(piece.pos)
        end
      end

      game.board.black.values.flatten.each do |piece|
        if !piece.kind_of?(Pawn) && !piece.kind_of?(King)
         game.remove_piece(piece.pos)
        end
      end
      game.board.update_cells
    end

    context 'When color is white' do
      it 'should promote piece to queen' do
       game.remove_piece(Board.coordinates('d7'))
        game.board.white[:pawns][3].pos = Board.coordinates('d7')
        game.update_next_moves
        game.board.update_cells
        input = 'd8=Q'
        color = 'white'
        expect{game.promote_piece(input, color)}.to change{game.board.white[:pawns].length}.by(-1)
      end
    end
    context 'When color is black' do
      it 'should promote piece to queen' do
       game.remove_piece(Board.coordinates('d2'))
        game.board.black[:pawns][3].pos = Board.coordinates('d2')
        game.update_next_moves
        game.board.update_cells
        input = 'd1=B'
        color = 'black'
        expect{game.promote_piece(input, color)}.to change{game.board.black[:bishops].length}.from(0).to(1)
      end
    end
  end

end