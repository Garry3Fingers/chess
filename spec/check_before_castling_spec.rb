# frozen_string_literal: true

require_relative '../lib/check_before_castling'
require_relative '../lib/create_pieces'
require_relative '../lib/coordinate_board'

describe CheckBeforeCastling do
  white_pieces = CreatePieces.new.white_pieces
  black_pieces = CreatePieces.new.black_pieces
  board = CoordinateBoard.new.board
  subject(:check_before_castling) { described_class.new(board, white_pieces, black_pieces) }

  describe '#path_is_secure?' do
    context 'when the king\'s path is secure' do
      it 'returns true' do
        move_arr = %w[e8 g8]
        color = 'black'
        expect(check_before_castling.path_is_secure?(move_arr, color)).to be(true)
      end
    end

    context 'when the king\'s path is not secure' do
      it 'returns false' do
        black_pieces.delete(:pawn6)
        black_pieces.delete(:bishop2)
        white_pieces[:rook1].position = 'f4'
        move_arr = %w[e8 g8]
        color = 'black'
        expect(check_before_castling.path_is_secure?(move_arr, color)).to be(false)
      end
    end
  end
end
