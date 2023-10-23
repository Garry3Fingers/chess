# frozen_string_literal: true

require_relative 'find_bishop_moves'
require_relative 'find_rook_moves'
require_relative 'validate_bishop_move'
require_relative 'validate_rook_move'
require_relative 'deep_copy'
require_relative 'piece'

# This class represents a queen piece from a chess game.
# It has a current position. It also checks if the piece can make a move.
# And if it can, it changes the current position.
class Queen < Piece
  include FindBishopMoves
  include FindRookMoves
  include ValidateBishopMove
  include ValidateRookMove
  include DeepCopy

  def can_make_move?(move, positions)
    positions = deep_copy(positions)
    check_queen_positions(move) && check_queen_path(move, positions)
  end

  private

  def add_potencial_moves(row, column)
    rook_moves = add_rook_potencial_moves(row, column)
    bishop_moves = add_bishop_potencial_moves(row, column)
    rook_moves + bishop_moves
  end

  def check_queen_positions(destination)
    pontecial_moves = add_potencial_moves(row_index(position), column_index(position))
    destination_coordinate = [row_index(destination), column_index(destination)]
    pontecial_moves.any? { |arr| arr == destination_coordinate }
  end

  def check_queen_path(move, positions)
    if move[0] == position[0] || move[1] == position[1]
      check_rook_path(move, positions)
    else
      check_bishop_path(move, positions)
    end
  end
end
