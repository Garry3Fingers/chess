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

  def change_position(destination, positions)
    pontecial_moves = add_potencial_moves(row_index(position), column_index(position))
    destination_coordinate = [row_index(destination), column_index(destination)]

    if check_postions(pontecial_moves, destination_coordinate) && check_pieces(destination, positions)
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

  def filter_positions(move, positions)
    if position[0] == move[0]
      positions.keep_if { |pos| pos[0] == position[0] }
    else
      positions.keep_if { |pos| /[a-h]#{move[1]}/.match?(pos) }
    end
  end

  def displacing_positions(move, positions)
    if position < move
      positions.keep_if { |pos| pos > position && pos < move }
    else
      positions.keep_if { |pos| pos < position && pos > move }
    end
  end

  def check_pieces(move, positions)
    positions = filter_positions(move, positions)

    way_pos = displacing_positions(move, positions)

    return false unless way_pos.empty?

    true
  end

  def check_postions(pontecial_moves, destination_coordinate)
    pontecial_moves.any? { |arr| arr == destination_coordinate }
  end
end
