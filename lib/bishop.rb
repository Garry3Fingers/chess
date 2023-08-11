# frozen_string_literal: true

require_relative 'coordinate_board'

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

  def change_position(destination)
    pontecial_moves = add_potencial_moves(row_index(position), column_index(position))
    destination_coordinate = [row_index(destination), column_index(destination)]

    if pontecial_moves.any? { |arr| arr == destination_coordinate }
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

  def first_diagonal(moves, row, column)
    if row <= 7 && column <= 7
      moves << [row, column]
      first_diagonal(moves, row + 1, column + 1)
    else
      moves
    end
  end

  def second_diagonal(moves, row, column)
    if row <= 7 && column >= 0
      moves << [row, column]
      second_diagonal(moves, row + 1, column - 1)
    else
      moves
    end
  end

  def third_diagonal(moves, row, column)
    if row >= 0 && column <= 7
      moves << [row, column]
      third_diagonal(moves, row - 1, column + 1)
    else
      moves
    end
  end

  def four_diagonal(moves, row, column)
    if row >= 0 && column >= 0
      moves << [row, column]
      four_diagonal(moves, row - 1, column - 1)
    else
      moves
    end
  end

  def add_potencial_moves(row, column)
    moves = []
    moves = first_diagonal(moves, row + 1, column + 1)
    moves = second_diagonal(moves, row + 1, column - 1)
    moves = third_diagonal(moves, row - 1, column + 1)
    four_diagonal(moves, row - 1, column - 1)
  end
end
