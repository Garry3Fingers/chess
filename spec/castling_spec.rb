# frozen_string_literal: true

require_relative '../lib/castling'
require_relative '../lib/king'
require_relative '../lib/rook'

describe Castling do
  move = 'g1'
  positions = ['b5']
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

  subject(:rook) { Rook.new('h1', board) }
  subject(:king) { King.new('e1', board) }
  subject(:castling) { described_class.new({ king:, rook:, move:, positions: }) }

  describe '#perform_castling' do
    context 'when a player can castle' do
      it 'returns true' do
        expect(castling.perform_castling).to be(true)
      end

      it 'changes the king\'s position to move' do
        castling.perform_castling
        expect(king.position).to be('g1')
      end

      it 'changes the postion of the rook to behind the king' do
        castling.perform_castling
        expect(rook.position).to eq('f1')
      end

      it 'changes the status of the first move of the king and rook to false' do
        castling.perform_castling
        expect(king.first_move).to be(false)
        expect(rook.first_move).to be(false)
      end
    end

    context 'when a player can\'t castle' do
      it 'returns false' do
        king.instance_variable_set(:@first_move, false)
        expect(castling.perform_castling).to be(false)
      end
    end
  end
end
