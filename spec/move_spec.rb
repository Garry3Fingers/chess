# frozen_string_literal: true

require_relative '../lib/move'
require_relative '../lib/create_pieces'

describe Move do
  white_pieces = CreatePieces.new.white_pieces
  black_pieces = CreatePieces.new.black_pieces
  subject(:move) { described_class.new(white_pieces, black_pieces) }

  describe '#make_move' do
    context 'when a player makes a move' do
      it 'has a hash with updated position' do
        move.make_move('a2 a4')
        expect(move.current_player_pieces[:pawn1].position).to eq('a4')
      end
    end

    context 'when a player makes an illegal move' do
      it 'returns false' do
        expect(move.make_move('b2 a4')).to be(false)
      end
    end
  end
end
