# frozen_string_literal: true

require_relative 'validate_bishop_move'
require_relative 'find_bishop_moves'

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

  def change_position(move, positions)
    if can_make_move?(move, positions)
      @position = move
      true
    else
      false
    end
  end

  def can_make_move?(move, positions)
    pontecial_moves = add_bishop_potencial_moves(row_index(position), column_index(position))
    destination_coordinate = [row_index(move), column_index(move)]
    check_bishop_postions(pontecial_moves, destination_coordinate) && check_bishop_path(move, positions)
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
