# frozen_string_literal: true

require_relative '../lib/display_move'
require_relative '../lib/display_board'
require_relative '../lib/coordinate_board'

describe DisplayMove do
  subject(:display_board) { DisplayBoard.new }
  subject(:c_board) { CoordinateBoard.new }
  subject(:display_move) { described_class.new(c_board.board, display_board) }

  before do
    allow(display_board).to receive(:puts)
    allow(display_board).to receive(:print)
  end

  describe '#change_postion' do
    context 'when a player makes a move' do
      it 'changes the position of the piece' do
        display_board.print_board
        move = 'd7 d5'
        color = 'black'
        display_move.change_position(move, color)
        expect(display_board.board[3][3]).to eq(" \u265F ".colorize(color: :black, background: :yellow))
      end

      it 'changes the previuos position to an empty square' do
        display_board.print_board
        move = 'd7 d5'
        color = 'black'
        display_move.change_position(move, color)
        expect(display_board.board[1][3]).to eq('   '.colorize(background: :yellow))
      end
    end
  end

  describe '#empty_square' do
    it 'removes a piece from the square' do
      display_board.print_board
      square = 'a2'
      display_move.empty_square(square)
      expect(display_board.board[6][0]).to eq('   '.colorize(background: :yellow))
    end
  end

  describe '#change_square' do
    it 'changes the figure on the square' do
      display_board.print_board
      square = 'c8'
      color = 'white'
      unicode_piece = " \u265D "
      display_move.change_square(square, color, unicode_piece)
      expect(display_board.board[0][2]).to eq(unicode_piece.colorize(color: :white, background: :yellow))
    end
  end
end
