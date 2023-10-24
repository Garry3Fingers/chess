# frozen_string_literal: true

require_relative '../lib/process_castling'
require_relative '../lib/create_pieces'

describe ProcessCatling do
  white_pieces = CreatePieces.new.white_pieces
  black_pieces = CreatePieces.new.black_pieces
  let(:display_move) { double('display move') }
  subject(:process_castling) { described_class.new(white_pieces, black_pieces, display_move) }

  describe '#castling_possible?' do
    context 'when castling is possible' do
      it 'returns true' do
        black_pieces.delete(:queen)
        black_pieces.delete(:bishop1)
        black_pieces.delete(:knight1)
        move_arr = %w[e8 c8]
        color = 'black'
        expect(process_castling.castling_possible?(move_arr, color)).to be(true)
      end
    end

    context 'when castling is not possible' do
      it 'returns false' do
        move_arr = %w[e1 c1]
        color = 'white'
        expect(process_castling.castling_possible?(move_arr, color)).to be(false)
      end
    end
  end

  describe '#invoke_castling' do
    it 'sends #do_castling' do
      move_arr = %w[e1 c1]
      color = 'white'
      subject.castling_possible?(move_arr, color)
      expect(process_castling.castling).to receive(:do_castling)
      process_castling.invoke_castling
    end
  end

  describe '#display_rook_castling' do
    it 'sends #change_position' do
      move_arr = %w[e1 g1]
      color = 'white'
      expect(display_move).to receive(:change_position)
      process_castling.display_rook_castling(move_arr, color)
    end
  end
end
