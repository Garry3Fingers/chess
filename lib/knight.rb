# frozen_string_literal: true

require_relative 'piece'

# This class represents a knight piece from a chess game.
# It has a current position. It also checks if the piece can make a move.
# And if it can, it changes the current position.
class Knight < Piece
  def can_make_move?(move, _pos)
    pontecial_moves = add_potencial_moves(row_index(position), column_index(position))
    destination_coordinate = [row_index(move), column_index(move)]
    pontecial_moves.any? { |arr| arr == destination_coordinate }
  end

  private

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
