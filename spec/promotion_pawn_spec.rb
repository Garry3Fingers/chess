# frozen_string_literal: true

require_relative '../lib/promotion_pawn'
require_relative '../lib/create_pieces'

describe PromotePawn do
  describe '#promote' do
    white_pieces = CreatePieces.new.white_pieces
    black_pieces = CreatePieces.new.black_pieces
    let(:display_move) { double('display move') }
    subject(:promote_pawn) { described_class.new(white_pieces, black_pieces, display_move) }

    before do
      allow(display_move).to receive(:empty_square)
      allow(display_move).to receive(:change_square)
      allow(promote_pawn).to receive(:puts)
    end

    context 'when the pawn cannot be promoted' do
      it 'stops the method' do
        expect(promote_pawn.promote('a3')).to be(nil)
      end
    end

    context 'when the pawn can be promoted' do
      it 'chages the pawn to anoter piece' do
        square = 'g8'
        white_pieces[:pawn7].position = square
        allow(promote_pawn).to receive(:gets).and_return('4')
        promote_pawn.promote(square)
        expect(promote_pawn.white_pieces.key?(:queen7)).to be(true)
      end

      it 'sends #empty_square to display_move' do
        square = 'g1'
        black_pieces[:pawn7].position = square
        allow(promote_pawn).to receive(:gets).and_return('3')
        expect(display_move).to receive(:empty_square)
        promote_pawn.promote(square)
      end

      it 'sends #change_square to display_move' do
        square = 'f1'
        black_pieces[:pawn6].position = square
        allow(promote_pawn).to receive(:gets).and_return('2')
        expect(display_move).to receive(:change_square)
        promote_pawn.promote(square)
      end
    end
  end
end
