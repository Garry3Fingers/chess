# frozen_string_literal: true

# This class is a chessboard with coordinates to help move the pieces.
class CoordinateBoard
  attr_reader :board

  def initialize
    @board = create_board
  end

  private

  def create_board
    nest_arr = Array.new(8) { [] }
    i = 8
    nest_arr.each do |arr|
      letter = 'a'

      while arr.length < 8
        arr << letter + i.to_s
        letter = letter.next
      end

      i -= 1
    end
  end
end
