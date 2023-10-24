# frozen_string_literal: true

require_relative '../lib/move'
require_relative '../lib/create_pieces'


describe Move do
  describe '#make_move' do
    white_pieces = CreatePieces.new.white_pieces
    black_pieces = CreatePieces.new.black_pieces
    let(:en_passant) { double('en passant') }
    let(:check) { double('check') }
    let(:check_before_castling) { double('check before castling') }
    let(:process_castling) { double('process castling') }
    subject(:move) { described_class.new(@args) }

    before do
      @args = {
        white_pieces:,
        black_pieces:,
        check:,
        check_before_castling:,
        process_castling:,
        en_passant:
      }

      allow(check).to receive(:before_move)
      allow(check).to receive(:after_move)
      allow(en_passant).to receive(:look_for_pawn)
      allow(en_passant).to receive(:check_en_passant)
    end

    context 'when a piece captures another' do
      it 'removes enemy piece' do
        color = 'white'
        move.black_pieces[:pawn1].position = 'c3'
        move.make_move('b1 c3', color)
        expect(move.black_pieces.key?(:pawn1)).to be(false)
      end
    end

    context 'when a player makes a legal move' do
      it 'returns true' do
        color = 'black'
        expect(move.make_move('e7 e5', color)).to be(true)
      end
    end

    context 'when a player makes an illegal move' do
      it 'returns false' do
        color = 'white'
        expect(move.make_move('b2 a4', color)).to be(false)
      end
    end
  end

  describe '#castling' do
    white_pieces = CreatePieces.new.white_pieces
    black_pieces = CreatePieces.new.black_pieces
    let(:en_passant) { double('en passant') }
    let(:check) { double('check') }
    let(:check_before_castling) { double('check before castling') }
    let(:process_castling) { double('process castling') }
    subject(:move) { described_class.new(@args) }

    before do
      @args = {
        white_pieces:,
        black_pieces:,
        check:,
        check_before_castling:,
        process_castling:,
        en_passant:
      }
    end

    context 'when a player can castle' do
      before do
        allow(check).to receive(:check_color).and_return('')
        allow(check_before_castling).to receive(:path_is_secure?).and_return(true)
        allow(process_castling).to receive(:castling_possible?).and_return(true)
        allow(process_castling).to receive(:invoke_castling)
        allow(process_castling).to receive(:display_rook_castling)
        allow(en_passant).to receive(:pawn_container).and_return({})
      end

      it ' returns true' do
        color = 'white'
        expect(move.castling('e1 g1', color)).to be(true)
      end
    end

    context 'when a player cannot castle' do
      before do
        allow(check).to receive(:check_color).and_return('white')
      end

      it ' returns fasle' do
        color = 'white'
        expect(move.castling('e1 g1', color)).to be(false)
      end
    end
  end
end
