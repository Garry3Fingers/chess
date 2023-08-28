# frozen_string_literal: true

# This module finds and checks the potencial move of the rook piece.
module FindRookMoves
  def add_rook_potencial_moves(row, column)
    moves = []

    (row + 1).upto(7) { |num| moves << [num, column] }
    (row - 1).downto(0) { |num| moves << [num, column] }
    (column + 1).upto(7) { |num| moves << [row, num] }
    (column - 1).downto(0) { |num| moves << [row, num] }

    moves
  end

  def check_rook_postions(pontecial_moves, destination_coordinate)
    pontecial_moves.any? { |arr| arr == destination_coordinate }
  end
end
