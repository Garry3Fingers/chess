# frozen_string_literal: true

require_relative '../lib/display_board'

describe DisplayBoard do
  subject(:display_board) { described_class.new }

  before do
    allow(display_board).to receive(:puts)
    allow(display_board).to receive(:print)
  end

  describe '#print_board' do
    context 'when the board is empty' do
      it 'fills the board' do
        display_board.print_board
        expect(display_board.board).not_to be_empty
      end
    end
  end
end
