# frozen_string_literal: true

require_relative '../lib/round'

describe Round do
  describe '#play' do
    context 'when players make moves' do
      white_pieces = CreatePieces.new.white_pieces
      black_pieces = CreatePieces.new.black_pieces
      let(:display_board) { double('display board') }
      let(:display_move) { double('display move') }
      subject(:round) { described_class.new(white_pieces, black_pieces, display_board, display_move) }

      before do
        allow(round).to receive(:puts)
        allow(display_board).to receive(:print_board)
        allow(display_move).to receive(:change_position)
        allow(round).to receive(:gets).and_return('a2 a4', 'a7 a5', 'b1 c3', 'b8 c6')
      end

      it 'sends #print_board to class DisplayBoard twice' do
        expect(display_board).to receive(:print_board).twice
        round.play
      end

      it 'sends #change_position to class DisplayMove twice' do
        expect(display_move).to receive(:change_position).twice
        round.play
      end

      it 'has an updated hash with pieces' do
        expect(round.white_pieces[:pawn1].position).to eq('a4')
      end
    end

    context 'when a player makes an illegal move once' do
      white_pieces = CreatePieces.new.white_pieces
      black_pieces = CreatePieces.new.black_pieces
      let(:display_board) { double('display board') }
      let(:display_move) { double('display move') }
      subject(:round) { described_class.new(white_pieces, black_pieces, display_board, display_move) }

      before do
        allow(display_board).to receive(:print_board)
        allow(display_move).to receive(:change_position)
        allow(round).to receive(:puts)
        allow(round).to receive(:gets).and_return('a2 a5', 'a2 a4', 'a7 a5')
      end

      it 'receives a message once' do
        message = 'You can\'t make an illegal move. Try again!'
        expect(round).to receive(:puts).with(message).once
        round.play
      end
    end
  end
end
