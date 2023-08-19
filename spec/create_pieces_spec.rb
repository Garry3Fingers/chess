# frozen_string_literal: true

require_relative '../lib/create_pieces'

describe CreatePieces do
  subject(:create) { described_class.new }

  describe '#initialize' do
    it 'creates an Array' do
      expect(create.board.class).to be(Array)
    end

    it 'has elements in Array' do
      expect(create.board.empty?).to be(false)
    end

    it 'has size 8' do
      expect(create.board.size).to be(8)
    end
  end

  describe '#white_pieces' do
    it 'returns hash' do
      expect(create.white_pieces.class).to be(Hash)
    end

    it 'has entries' do
      expect(create.white_pieces.empty?).to be(false)
    end

    it 'has size 16' do
      expect(create.white_pieces.size).to be(16)
    end

    it 'has eight instances of the Pawn class' do
      expect(create.white_pieces.count { |_key, value| value.is_a?(Pawn) }).to be(8)
    end

    it 'has two instances of the Rook class' do
      expect(create.white_pieces.count { |_key, value| value.is_a?(Rook) }).to be(2)
    end

    it 'has two instances of the Knight class' do
      expect(create.white_pieces.count { |_key, value| value.is_a?(Knight) }).to be(2)
    end

    it 'has two instances of the Bishop class' do
      expect(create.white_pieces.count { |_key, value| value.is_a?(Bishop) }).to be(2)
    end

    it 'has one instance of the Queen class' do
      expect(create.white_pieces.count { |_key, value| value.is_a?(Queen) }).to be(1)
    end

    it 'has one instance of the King class' do
      expect(create.white_pieces.count { |_key, value| value.is_a?(King) }).to be(1)
    end

    it 'has a Pawn with white color' do
      expect(create.white_pieces[:pawn1].color).to be('white')
    end
  end

  describe '#black_pieces' do
    it 'returns hash' do
      expect(create.black_pieces.class).to be(Hash)
    end

    it 'has entries' do
      expect(create.black_pieces.empty?).to be(false)
    end

    it 'has size 16' do
      expect(create.black_pieces.size).to be(16)
    end

    it 'has eight instances of the Pawn class' do
      expect(create.black_pieces.count { |_key, value| value.is_a?(Pawn) }).to be(8)
    end

    it 'has two instances of the Rook class' do
      expect(create.black_pieces.count { |_key, value| value.is_a?(Rook) }).to be(2)
    end

    it 'has two instances of the Knight class' do
      expect(create.black_pieces.count { |_key, value| value.is_a?(Knight) }).to be(2)
    end

    it 'has two instances of the Bishop class' do
      expect(create.black_pieces.count { |_key, value| value.is_a?(Bishop) }).to be(2)
    end

    it 'has one instance of the Queen class' do
      expect(create.black_pieces.count { |_key, value| value.is_a?(Queen) }).to be(1)
    end

    it 'has one instance of the King class' do
      expect(create.black_pieces.count { |_key, value| value.is_a?(King) }).to be(1)
    end

    it 'has a Pawn with black color' do
      expect(create.black_pieces[:pawn1].color).to be('black')
    end
  end
end
