# frozen_string_literal: true

require_relative '../lib/queen'

describe Queen do
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

    subject(:queen) { described_class.new('d4', board) }

    context 'when a player makes a move' do
      it 'changes position' do
        pos = %w[f5 d7]
        queen.change_position('h8', pos)
        expect(queen.position).to eq('h8')
      end
    end

    context 'when a player makes an illegal move' do
      it 'returns false' do
        pos = %w[e5 g4]
        expect(queen.change_position('h4', pos)).to be(false)
      end
    end
  end
end
