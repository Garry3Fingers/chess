# frozen_string_literal: true

require_relative '../lib/check'
require_relative '../lib/create_pieces'

describe Check do
  let(:en_passant) { double('en_passant') }
  white_pieces = CreatePieces.new.white_pieces
  black_pieces = CreatePieces.new.black_pieces
  subject(:check) { described_class.new(white_pieces, black_pieces, en_passant) }

  describe '#after_move' do
    before do
      allow(check).to receive(:puts)
      check.white_pieces[:king].position = 'e3'
      check.black_pieces[:queen].position = 'g5'
    end

    context 'when a piece gives check to the king after its move' do
      it 'outputs a message' do
        message = 'Black queen gives check to the white king'.colorize(color: :red)
        color = 'black'
        expect(check).to receive(:puts).with(message).once
        check.after_move(color)
      end

      it 'changes @check_color' do
        color = 'black'
        check_color = 'white'
        check.after_move(color)
        expect(check.check_color).to be(check_color)
      end
    end

    it 'changes @check_color to an empty string before each check' do
      check.instance_variable_set(:@check_color, 'black')
      color = 'white'
      empty_string = ''
      check.after_move(color)
      expect(check.check_color).to be(empty_string)
    end
  end

  describe '#before_move' do
    context 'when the king is in check after a move' do
      it 'returns true' do
        check.white_pieces[:king].position = 'e3'
        check.white_pieces[:pawn6].position = 'f4'
        check.black_pieces[:queen].position = 'g5'
        move_arr = %w[f4 f5]
        color = 'white'
        expect(check.before_move(move_arr, color)).to be(true)
      end
    end

    context 'when the king isn\'t in check after a move' do
      it 'returns false' do
        check.white_pieces[:king].position = 'e1'
        check.white_pieces[:pawn6].position = 'f2'
        check.black_pieces[:queen].position = 'd8'
        move_arr = %w[f2 f4]
        color = 'white'
        expect(check.before_move(move_arr, color)).to be(false)
      end
    end
  end

  describe '#before_en_passant' do
    context 'when the king is in check after a move' do
      it 'returns true' do
        allow(en_passant).to receive(:pawn_container).and_return(:pawn8)
        move_arr = %w[g5 h6]
        color = 'white'
        check.white_pieces[:king].position = 'h4'
        check.black_pieces[:queen].position = 'f6'
        check.white_pieces[:pawn7].position = 'g5'
        check.black_pieces[:pawn8].position = 'h5'
        expect(check.before_en_passant(move_arr, color)).to be(true)
      end
    end

    context 'when the king isn\'t in check after a move' do
      it 'returns false' do
        allow(en_passant).to receive(:pawn_container).and_return(:pawn8)
        move_arr = %w[g5 h6]
        color = 'white'
        check.white_pieces[:king].position = 'e1'
        check.black_pieces[:queen].position = 'd8'
        check.white_pieces[:pawn7].position = 'g5'
        check.black_pieces[:pawn8].position = 'h5'
        expect(check.before_en_passant(move_arr, color)).to be(false)
      end
    end
  end
end
