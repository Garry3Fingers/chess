# frozen_string_literal: true

require_relative '../lib/move'
require_relative '../lib/create_pieces'
require_relative '../lib/king'
require_relative '../lib/rook'
require_relative '../lib/coordinate_board'

describe Move do
  white_pieces = CreatePieces.new.white_pieces
  black_pieces = CreatePieces.new.black_pieces
  let(:en_passant) { double('en passant') }
  subject(:move) { described_class.new(white_pieces, black_pieces, en_passant) }

  before do
    allow(en_passant).to receive(:pawn_container).and_return({})
    allow(en_passant).to receive(:check_en_passant)
    allow(en_passant).to receive(:look_for_pawn)
  end

  describe '#make_move' do
    context 'when a player makes a move' do
      it 'has a hash with updated position' do
        move.make_move('a2 a4')
        expect(move.current_player_pieces[:pawn1].position).to eq('a4')
      end

      it 'removes enemy piece from the hash' do
        move.pieces_other_player[:pawn1].position = 'c3'
        move.make_move('b1 c3')
        expect(move.pieces_other_player.key?(:pawn1)).to be(false)
      end
    end

    context 'when a player makes an illegal move' do
      it 'returns false' do
        expect(move.make_move('b2 a4')).to be(false)
      end
    end

    context 'when a king under attack' do
      it 'returns false' do
        move.pieces_other_player[:pawn2].position = 'd5'
        move.current_player_pieces[:king].position = 'd3'
        expect(move.make_move('d3 d4')).to be(false)
      end
    end
  end

  describe '#castling' do
    let(:board) { CoordinateBoard.new }
    let(:king) { King.new('e1', board.board) }
    let(:rook) { Rook.new('h1', board.board) }

    context 'when a player can castle' do
      it ' returns true' do
        move.instance_variable_set(:@current_player_pieces, { king:, rook2: rook })
        expect(move.castling('e1 g1')).to be(true)
      end
    end

    context 'when a player cannot castle' do
      it ' returns fasle' do
        move.instance_variable_set(:@current_player_pieces, { king:, rook2: rook })
        king.instance_variable_set(:@first_move, false)
        expect(move.castling('e1 g1')).to be(false)
      end
    end
  end
end
