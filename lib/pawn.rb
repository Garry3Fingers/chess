# frozen_string_literal: true

require_relative 'coordinate_board'

# This class represents a pawn piece from a chess game.
# It has a current position. It also checks if the piece can make a move.
# And if it can, it changes the current position.
class Pawn
  attr_reader :board, :color
  attr_accessor :position, :first_move

  def initialize(position, board, color)
    @position = position
    @board = board
    @first_move = true
    @color = color
  end

  def change_position(destination)
    pontecial_moves = add_potencial_moves(row_index(position), column_index(position))
    destination_coordinate = [row_index(destination), column_index(destination)]

    if pontecial_moves.any? { |arr| arr == destination_coordinate }
      @first_move = false
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

  def white(moves, row, column)
    moves << [row - 2, column] if first_move == true
    moves << [row - 1, column]
    moves
  end

  def black(moves, row, column)
    moves << [row + 2, column] if first_move == true
    moves << [row + 1, column]
    moves
  end

  def add_potencial_moves(row, column)
    moves = []

    if color == 'white'
      moves = white(moves, row, column)
    elsif color == 'black'
      moves = black(moves, row, column)
    end

    moves
  end
end
