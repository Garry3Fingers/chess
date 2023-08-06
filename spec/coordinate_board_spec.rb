# frozen_string_literal: true

require_relative '../lib/coordinate_board'

describe CoordinateBoard do
  subject(:coor_board) { described_class.new }

  describe '#initialize' do
    context 'when instantiating an object' do
      it 'creates an array with eight nested arrays' do
        expect(coor_board.board.length == 8 && coor_board.board.all? { |arr| arr.is_a?(Array) }).to be(true)
      end

      it 'has elements in nested arrays' do
        expect(coor_board.board.any?(&:empty?)).to be(false)
      end
    end
  end
end
