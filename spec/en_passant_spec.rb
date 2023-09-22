# frozen_string_literal: true

require_relative '../lib/en_passant'
require_relative '../lib/create_pieces'

describe EnPassant do
  white_pieces = CreatePieces.new.white_pieces
  black_pieces = CreatePieces.new.black_pieces
  let(:display_move) { double('display move') }
  subject(:en_passant) { described_class.new(white_pieces, black_pieces, display_move) }

  describe '#look_for_pawn' do
    context 'when the pawn makes the first move and the move lenght is two squares' do
      it 'adds this pawn to pawn_container' do
        move_arr = %w[g2 g4]
        pos = []
        en_passant.look_for_pawn(move_arr, pos)
        key_of_pawn = :pawn7
        expect(en_passant.pawn_container['white']).to eq(key_of_pawn)
      end
    end

    context 'when the pawn makes a move and this move does not meet the conditions' do
      it 'does not add the pawn to pawn_container' do
        move_arr = %w[a7 a6]
        pos = []
        en_passant.look_for_pawn(move_arr, pos)
        expect(en_passant.pawn_container.empty?).to be(true)
      end
    end

    it 'clears pawn_container before search' do
      en_passant.pawn_container['white'] = :pawn7
      move_arr = %w[g1 c3]
      pos = []
      en_passant.look_for_pawn(move_arr, pos)
      expect(en_passant.pawn_container.empty?).to be(true)
    end
  end

  describe '#check_en_passant' do
    context 'when a player can make en passant' do
      it 'returns true' do
        en_passant.white_pieces[:pawn7].position = 'g5'
        en_passant.black_pieces[:pawn8].position = 'h5'
        en_passant.pawn_container['black'] = :pawn8
        move_arr = %w[g5 h6]
        expect(en_passant.check_en_passant(move_arr)).to be(true)
      end
    end

    context 'when a player cannot make en passant' do
      it 'returns false' do
        en_passant.white_pieces[:pawn7].position = 'g5'
        en_passant.black_pieces[:pawn8].position = 'h5'
        move_arr = %w[g5 h6]
        en_passant.pawn_container['white'] = :pawn2
        expect(en_passant.check_en_passant(move_arr)).to be(true)
      end
    end
  end

  describe '#en_passant' do
    before do
      allow(display_move).to receive(:empty_square)
    end

    it 'sends #empty_square' do
      black_pieces[:pawn1].position = 'a4'
      en_passant.pawn_container['white'] = :pawn2
      en_passant.instance_variable_set(:@pawn, black_pieces[:pawn1])
      expect(display_move).to receive(:empty_square)
      en_passant.en_passant('b3')
    end

    it 'deletes enemy piece' do
      black_pieces[:pawn3].position = 'c4'
      en_passant.pawn_container['white'] = :pawn4
      en_passant.instance_variable_set(:@pawn, black_pieces[:pawn3])
      en_passant.en_passant('d3')
      expect(en_passant.white_pieces.key?(:pawn4)).to be(false)
    end

    it 'changes the position of the pawn' do
      en_passant.white_pieces[:pawn7].position = 'g5'
      en_passant.black_pieces[:pawn8].position = 'h5'
      en_passant.pawn_container['black'] = :pawn8
      en_passant.instance_variable_set(:@pawn, white_pieces[:pawn7])
      en_passant.en_passant('h6')
      expect(en_passant.white_pieces[:pawn7].position).to be('h6')
    end

    it 'changes @pawn to nil' do
      en_passant.white_pieces[:pawn5].position = 'e5'
      en_passant.black_pieces[:pawn6].position = 'f5'
      en_passant.pawn_container['black'] = :pawn6
      en_passant.instance_variable_set(:@pawn, white_pieces[:pawn5])
      en_passant.en_passant('f6')
      expect(en_passant.pawn).to be(nil)
    end
  end
end
