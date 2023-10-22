# frozen_string_literal: true

require_relative 'validate_bishop_move'
require_relative 'find_bishop_moves'
require_relative 'deep_copy'
require_relative 'row_column_index'

# This class represents a bishop piece from a chess game.
# It has a current position. It also checks if the piece can make a move.
# And if it can, it changes the current position.
class Bishop
  attr_reader :board
  attr_accessor :position

  def initialize(position, board)
    @position = position
    @board = board
  end

  include FindBishopMoves
  include ValidateBishopMove
  include DeepCopy
  include RowColumnIndex

  def change_position(move)
    @position = move
  end

  def can_make_move?(move, positions)
    positions = deep_copy(positions)
    pontecial_moves = add_bishop_potencial_moves(row_index(position), column_index(position))
    destination_coordinate = [row_index(move), column_index(move)]
    check_bishop_postions(pontecial_moves, destination_coordinate) && check_bishop_path(move, positions)
  end
end
