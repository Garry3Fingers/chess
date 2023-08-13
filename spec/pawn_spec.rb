# frozen_string_literal: true

require_relative '../lib/pawn'

describe Pawn do
  describe '#change_position' do
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

    subject(:pawn) { described_class.new('f2', board, 'white') }

    context 'when a player makes a move' do
      it 'changes position' do
        pawn.change_position('f3')
        expect(pawn.position).to eq('f3')
      end
    end

    context 'when a player makes an illegal move' do
      it 'returns false' do
        expect(pawn.change_position('e2')).to be(false)
      end
    end

    context 'when the pawn makes its first move' do
      it 'can advance two squares along the same file' do
        pawn.change_position('f4')
        expect(pawn.position).to eq('f4')
      end
    end

    context 'when it\'s not the first pawn move' do
      it 'can\'t advance two squares along the same file' do
        pawn.instance_variable_set(:@first_move, false)
        expect(pawn.change_position('f4')).to be(false)
      end
    end
  end
end
