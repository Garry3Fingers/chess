# frozen_string_literal: true

require_relative '../lib/round'

describe Round do
  describe '#play' do
    let(:display_board) { double('display board') }
    let(:display_move) { double('display move') }
    let(:promote_pawn) { double('promote pawn') }
    let(:winner_check) { double('winner check') }
    let(:move) { double('move') }
    subject(:round) { described_class.new(@args) }

    before(:each) do
      @args = {
        display_board:,
        display_move:,
        promote_pawn:,
        winner_check:,
        move:
      }

      allow(promote_pawn).to receive(:promote)
      allow(round).to receive(:puts)
      allow(display_board).to receive(:print_board)
      allow(display_move).to receive(:change_position)
      allow(winner_check).to receive(:checkmate)
      allow(winner_check).to receive(:stalemate)
    end

    context 'when players make moves' do
      before do
        allow(move).to receive(:make_move).and_return(true)
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
    end

    context 'when a player makes an illegal move once' do
      before do
        allow(move).to receive(:make_move).and_return(false, true, true)
        allow(round).to receive(:gets).and_return('a2 a5', 'a2 a4', 'a7 a5')
      end

      it 'puts a message once' do
        message = 'You can\'t make an illegal move. Try again!'
        expect(round).to receive(:puts).with(message).once
        round.play
      end
    end

    context 'when the game is over' do
      before do
        allow(move).to receive(:make_move).and_return(true)
        allow(winner_check).to receive(:checkmate).and_return(true)
      end

      it 'returns true' do
        expect(round.play).to be(true)
      end
    end
  end
end
