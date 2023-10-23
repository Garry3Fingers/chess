# frozen_string_literal: true

require_relative 'validate_rook_move'
require_relative 'find_rook_moves'
require_relative 'deep_copy'
require_relative 'piece'

# This class represents a rook piece from a chess game.
# It has a current position. It also checks if the piece can make a move.
# And if it can, it changes the current position.
class Rook < Piece
  attr_accessor :first_move

  def initialize(position, board)
    super(position, board)
    @first_move = true
  end

  include FindRookMoves
  include ValidateRookMove
  include DeepCopy

  def change_position(move)
    self.first_move = false
    super
  end

  def can_make_move?(move, positions)
    positions = deep_copy(positions)
    pontecial_moves = add_rook_potencial_moves(row_index(position), column_index(position))
    destination_coordinate = [row_index(move), column_index(move)]
    check_rook_postions(pontecial_moves, destination_coordinate) && check_rook_path(move, positions)
  end
end
