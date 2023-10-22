# frozen_string_literal: true

require_relative '../lib/process_castling'
require_relative '../lib/create_pieces'

describe ProcessCatling do
  white_pieces = CreatePieces.new.white_pieces
  black_pieces = CreatePieces.new.black_pieces
  subject(:process_castling) { described_class.new(white_pieces, black_pieces) }

  describe '#castling_possible?' do
    context 'when castling is possible' do
      it 'returns true' do
        black_pieces.delete(:queen)
        black_pieces.delete(:bishop1)
        black_pieces.delete(:knight1)
        move_arr = %w[e8 c8]
        color = 'black'
        expect(subject.castling_possible?(move_arr, color)).to be(true)
      end
    end

    context 'when castling is not possible' do
      it 'returns false' do
        move_arr = %w[e1 c1]
        color = 'white'
        expect(subject.castling_possible?(move_arr, color)).to be(false)
      end
    end
  end

  describe '#invoke_castling' do
    it 'sends #do_castling' do
      move_arr = %w[e1 c1]
      color = 'white'
      subject.castling_possible?(move_arr, color)
      expect(subject.castling).to receive(:do_castling)
      subject.invoke_castling
    end
  end
end
