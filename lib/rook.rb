# frozen_string_literal: true

require_relative 'coordinate_board'

# This class represents a rook piece from a chess game.
# It has a current position. It also checks if the piece can make a move.
# And if it can, it changes the current position.
class Rook
  attr_reader :board
  attr_accessor :position

  def initialize(position, board)
    @position = position
    @board = board
  end

  def change_position(destination)
    pontecial_moves = add_potencial_moves(row_index(position), column_index(position))
    destination_coordinate = [row_index(destination), column_index(destination)]

    if pontecial_moves.any? { |arr| arr == destination_coordinate }
      @position = destination
    else
      false
    end
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
    moves = []

    (row + 1).upto(7) { |num| moves << [num, column] }
    (row - 1).downto(0) { |num| moves << [num, column] }
    (column + 1).upto(7) { |num| moves << [row, num] }
    (column - 1).downto(0) { |num| moves << [row, num] }

    moves
  end
end
