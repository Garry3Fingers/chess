# frozen_string_literal: true

require_relative 'row_column_index'
require_relative 'deep_copy'

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

  include RowColumnIndex
  include DeepCopy

  def change_position(move)
    self.first_move = false
    self.position = move
  end

  def can_make_move?(move, positions)
    positions = deep_copy(positions)
    diagonal_attack(move, positions) || check_potencial_moves(move) && check_pawn_path(move, positions)
  end

  private

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

  def check_top_diagonals(move)
    [
      "#{(position[0].ord - 1).chr}#{position[1].next}",
      "#{position[0].next}#{position[1].next}"
    ].include?(move)
  end

  def check_bottom_diagonals(move)
    [
      "#{(position[0].ord - 1).chr}#{(position[1].ord - 1).chr}",
      "#{position[0].next}#{(position[1].ord - 1).chr}"
    ].include?(move)
  end

  def diagonal_attack(move, positions)
    return false unless positions.include?(move)

    if color == 'white' && check_top_diagonals(move)
      true
    elsif color == 'black' && check_bottom_diagonals(move)
      true
    end
  end

  def check_potencial_moves(move)
    pontecial_moves = add_potencial_moves(row_index(position), column_index(position))
    move_coordinate = [row_index(move), column_index(move)]
    pontecial_moves.any? { |arr| arr == move_coordinate }
  end

  def filter_positions(move, positions)
    if position < move
      positions.keep_if { |pos| pos[0] == move[0] && pos[1] <= move[1] }
    else
      positions.keep_if { |pos| pos[0] == move[0] && pos[1] >= move[1] }
    end
  end

  def blocking_positions(move, positions)
    if position < move
      positions.keep_if { |pos| pos <= move && pos > position  }
    else
      positions.keep_if { |pos| pos >= move && pos < position  }
    end
  end

  def check_pawn_path(move, positions)
    positions = filter_positions(move, positions)
    way_pos = blocking_positions(move, positions)
    return false unless way_pos.empty?

    true
  end
end
