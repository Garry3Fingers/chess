# frozen_string_literal: true

require_relative 'validate_rook_move'
require_relative 'find_rook_moves'

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

  def change_position(move)
    @position = move
    @first_move = false
  end

  def can_make_move?(move, positions)
    pontecial_moves = add_rook_potencial_moves(row_index(position), column_index(position))
    destination_coordinate = [row_index(move), column_index(move)]
    check_rook_postions(pontecial_moves, destination_coordinate) && check_rook_path(move, positions)
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
end
