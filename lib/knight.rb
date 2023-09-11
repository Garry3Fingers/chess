# frozen_string_literal: true

require_relative 'coordinate_board'

# This class represents a knight piece from a chess game.
# It has a current position. It also checks if the piece can make a move.
# And if it can, it changes the current position.
class Knight
  attr_reader :board
  attr_accessor :position

  def initialize(position, board)
    @position = position
    @board = board
  end

  def change_position(move, pos)
    if can_make_move?(move, pos)
      @position = move
      true
    else
      false
    end
  end

  def can_make_move?(move, _pos)
    pontecial_moves = add_potencial_moves(row_index(position), column_index(position))
    destination_coordinate = [row_index(move), column_index(move)]
    pontecial_moves.any? { |arr| arr == destination_coordinate }
  end

  private

  def row_index(location)
    board.index { |arr| arr.include?(location) }
  end

  def column_index(location)
    board.each do |arr|
      column = arr.index(location)
      return column unless column.nil?
    end
  end

  def add_potencial_moves(row, column)
    [
      [row + 2, column + 1],
      [row + 2, column - 1],
      [row - 2, column + 1],
      [row - 2, column - 1],
      [row + 1, column + 2],
      [row + 1, column - 2],
      [row - 1, column + 2],
      [row - 1, column - 2]
    ]
  end
end
