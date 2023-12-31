# frozen_string_literal: true

require_relative '../lib/rook'
require_relative '../lib/create_pieces'

describe Rook do
  board = [
    %w[a8 b8 c8 d8 e8 f8 g8 h8],
    %w[a7 b7 c7 d7 e7 f7 g7 h7],
    %w[a6 b6 c6 d6 e6 f6 g6 h6],
    %w[a5 b5 c5 d5 e5 f5 g5 h5],
    %w[a4 b4 c4 d4 e4 f4 g4 h4],
    %w[a3 b3 c3 d3 e3 f3 g3 h3],
    %w[a2 b2 c2 d2 e2 f2 g2 h2],
    %w[a1 b1 c1 d1 e1 f1 g1 h1]
  ]

  subject(:rook) { described_class.new('a1', board) }

  describe '#change_position' do
    context 'when a player makes a move' do
      it 'change @first_move to fasle' do
        rook.change_position('c1')
        expect(rook.first_move).to be(false)
      end

      it 'changes position' do
        rook.change_position('d1')
        expect(rook.position).to eq('d1')
      end
    end
  end

  describe '#can_make_move?' do
    context 'when a player makes a legal move' do
      it 'returns true' do
        pos_on_way = []
        expect(rook.can_make_move?('g1', pos_on_way)).to be(true)
      end
    end

    context 'when a player makes an illegal move' do
      it 'returns false' do
        pos_on_way = ['b1']
        expect(rook.can_make_move?('g1', pos_on_way)).to be(false)
      end
    end
  end
end
