# frozen_string_literal: true

require_relative 'validate_rook_move'
require_relative 'find_rook_moves'
require_relative 'deep_copy'
require_relative 'row_column_index'

# This class represents a rook piece from a chess game.
# It has a current position. It also checks if the piece can make a move.
# And if it can, it changes the current position.
class Rook
  attr_reader :board
  attr_accessor :position, :first_move

  def initialize(position, board)
    @position = position
    @board = board
    @first_move = true
  end

  include FindRookMoves
  include ValidateRookMove
  include DeepCopy
  include RowColumnIndex

  def change_position(move)
    self.position = move
    self.first_move = false
  end

  def can_make_move?(move, positions)
    positions = deep_copy(positions)
    pontecial_moves = add_rook_potencial_moves(row_index(position), column_index(position))
    destination_coordinate = [row_index(move), column_index(move)]
    check_rook_postions(pontecial_moves, destination_coordinate) && check_rook_path(move, positions)
  end
end
