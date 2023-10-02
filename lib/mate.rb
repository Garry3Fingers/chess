# frozen_string_literal: true

require_relative 'coordinate_board'
require_relative 'positions'

# This class checks if the current player is in check and if so, it checks if the player can break check.
class Mate
  attr_reader :check, :white_pieces, :black_pieces, :en_passant

  def initialize(check, white_pieces, black_pieces, en_passant)
    @check = check
    @white_pieces = white_pieces
    @black_pieces = black_pieces
    @en_passant = en_passant
  end

  include Positions

  def mate?(color)
    return false unless check.check_color == color

    process_mate(color)
  end

  private

  def create_board_squares
    CoordinateBoard.new.board.flatten.sort
  end

  def binary_search(array, search_value, lower_bound, upper_bound)
    midpoint = (upper_bound + lower_bound) / 2
    value_at_midpoint = array[midpoint]

    if search_value == value_at_midpoint
      midpoint
    elsif search_value < value_at_midpoint
      binary_search(array, search_value, lower_bound, midpoint - 1)
    elsif search_value > value_at_midpoint
      binary_search(array, search_value, midpoint + 1, upper_bound)
    end
  end

  def delete_useless_squares(pieces, board_squares)
    positions_arr(pieces).each do |position|
      index = binary_search(board_squares, position, 0, board_squares.length - 1)
      board_squares.delete_at(index)
    end
  end

  def try_en_passant(move_arr, color)
    en_passant.try_en_passant(move_arr) && check.before_en_passant(move_arr, color)
  end

  def try_move(pieces, color, positions, board_squares)
    pieces.each_value do |piece|
      board_squares.each do |square|
        move_arr = [piece.position, square]
        next unless piece.can_make_move?(square, positions)
        return false unless check.before_move(move_arr, color) || try_en_passant(move_arr, color)
      end
    end

    true
  end

  def process_mate(color)
    positions = all_positions(white_pieces, black_pieces)
    board_squares = create_board_squares

    if color == 'white'
      delete_useless_squares(white_pieces, board_squares)
      try_move(white_pieces, color, positions, board_squares)
    else
      delete_useless_squares(black_pieces, board_squares)
      try_move(black_pieces, color, positions, board_squares)
    end
  end
end
