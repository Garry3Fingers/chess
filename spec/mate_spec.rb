# frozen_string_literal: true

require_relative '../lib/mate'
require_relative '../lib/king'
require_relative '../lib/rook'
require_relative '../lib/coordinate_board'
require_relative '../lib/check'

describe Mate do
  describe '#mate?' do
    context 'when it\'s checkmate' do
      let(:en_passant) { double('en_passant') }
      coordinate_board = CoordinateBoard.new.board
      white_king = King.new('h6', coordinate_board)
      white_rook = Rook.new('e8', coordinate_board)
      black_king = King.new('h8', coordinate_board)
      white_pieces = { king: white_king, rook1: white_rook }
      black_pieces = { king: black_king }
      let(:check) { Check.new(white_pieces, black_pieces, en_passant) }
      subject(:mate) { described_class.new(check, white_pieces, black_pieces, en_passant) }

      before do
        allow(check).to receive(:check_color).and_return('black')
      end

      it 'returns true' do
        color = 'black'
        expect(mate.process_mate(color)).to be(true)
      end
    end

    context 'when it isn\'t checkmate' do
      let(:en_passant) { double('en_passant') }
      coordinate_board = CoordinateBoard.new.board
      white_king = King.new('h6', coordinate_board)
      white_rook = Rook.new('h5', coordinate_board)
      black_king = King.new('h8', coordinate_board)
      white_pieces = { king: white_king, rook1: white_rook }
      black_pieces = { king: black_king }
      let(:check) { Check.new(white_pieces, black_pieces, en_passant) }
      subject(:mate) { described_class.new(check, white_pieces, black_pieces, en_passant) }

      before do
        allow(check).to receive(:check_color).and_return('black')
        allow(en_passant).to receive(:check_en_passant).and_return(false)
      end

      it 'returns false' do
        color = 'black'
        expect(mate.process_mate(color)).to be(false)
      end
    end
  end
end
