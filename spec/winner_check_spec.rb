# frozen_string_literal: true

require_relative '../lib/winner_check'

describe WinnerCheck do
  let(:check) { double('check') }
  let(:mate) { double('mate') }
  let(:process_castling) { double('process castling') }
  subject(:winner_check) { described_class.new(check, mate, process_castling) }

  before do
    allow(winner_check).to receive(:puts)
  end

  describe '#stalemate' do
    context "when it's a stalemate" do
      before(:each) do
        allow(check).to receive(:check_color).and_return('')
        allow(mate).to receive(:process_mate).and_return(true)
        allow(process_castling).to receive(:castling_possible?).and_return(false)
      end

      it 'puts the message once' do
        message = "Stalemate! It's a draw."
        color = 'black'
        expect(winner_check).to receive(:puts).with(message).once
        winner_check.stalemate(color)
      end

      it 'returns true' do
        color = 'white'
        expect(winner_check.stalemate(color)).to be(true)
      end
    end

    context "when it's not a stalemate" do
      before do
        allow(check).to receive(:check_color).and_return('white')
      end

      it 'returns false' do
        color = 'white'
        expect(winner_check.stalemate(color)).to be(false)
      end
    end
  end

  describe '#checkmate' do
    context "when it's a checkmate" do
      before(:each) do
        @color_check = 'black'
        @color_player = 'white'
        allow(check).to receive(:check_color).and_return('black')
        allow(mate).to receive(:process_mate).and_return(true)
      end

      it 'puts the message once' do
        message = "Checkmate! #{@color_player.capitalize} player won the match!"
        expect(winner_check).to receive(:puts).with(message).once
        winner_check.checkmate(@color_check, @color_player)
      end

      it 'returns true' do
        expect(winner_check.checkmate(@color_check, @color_player)).to be(true)
      end
    end

    context "when it's not a checkmate" do
      before do
        @color_check = 'white'
        @color_player = 'black'
        allow(check).to receive(:check_color).and_return('')
      end

      it 'returns false' do
        expect(winner_check.checkmate(@color_check, @color_player)).to be(false)
      end
    end
  end
end
