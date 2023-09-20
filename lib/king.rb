# frozen_string_literal: true

require_relative 'coordinate_board'

# This class represents a king piece from a chess game.
# It has a current position. It also checks if the piece can make a move.
# And if it can, it changes the current position.
class King
  attr_reader :board
  attr_accessor :position, :first_move

  def initialize(position, board)
    @position = position
    @board = board
    @first_move = true
  end

  def change_position(move)
    @position = move
    @first_move = false
  end

  def can_make_move?(move, _pos)
    check_potencial_moves(move)
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
      [row + 1, column],
      [row - 1, column],
      [row, column + 1],
      [row, column - 1],
      [row + 1, column + 1],
      [row + 1, column - 1],
      [row - 1, column + 1],
      [row - 1, column - 1]
    ]
  end

  def check_potencial_moves(move)
    pontecial_moves = add_potencial_moves(row_index(position), column_index(position))
    destination_coordinate = [row_index(move), column_index(move)]
    pontecial_moves.any? { |arr| arr == destination_coordinate }
  end
end
