# frozen_string_literal: true

require_relative '../lib/move'
require_relative '../lib/create_pieces'

describe Move do
  pieces = CreatePieces.new.white_pieces
  subject(:move) { described_class.new(pieces) }

  describe '#make_move' do
    context 'when a player makes a move' do
      it 'returns a hash with the updated value' do
        expect(move.make_move('a2 a4')[:pawn1].position).to eq('a4')
      end
    end

    context 'when a player makes an illegal move' do
      it 'returns false' do
        expect(move.make_move('b2 a4')).to be(false)
      end
    end
  end
end
