# frozen_string_literal: true

require_relative 'display_board'
require_relative 'coordinate_board'

# This class changes the positions of the pieces on the display board.
class DisplayMove
  attr_reader :board
  attr_accessor :display_board

  # c_board = CoordinateBoard, d_board = DisplayBoard
  def initialize(c_board, d_board)
    @board = c_board
    @display_board = d_board
  end

  def change_position(move, color)
    move = move.split(' ')
    start_square = [row_index(move.first), column_index(move.first)]
    end_square = [row_index(move.last), column_index(move.last)]
    change_end(end_square, color, piece(start_square))
    change_start(start_square)
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

  def d_board
    display_board.board
  end

  def piece(start_square)
    d_board[start_square.first][start_square.last].uncolorize
  end

  def piece_gray(piece, color, row, column)
    d_board[row][column] = piece.colorize(color: :"#{color}", background: :gray)
  end

  def piece_yellow(piece, color, row, column)
    d_board[row][column] = piece.colorize(color: :"#{color}", background: :yellow)
  end

  def empty_gray(row, column)
    d_board[row][column] = '   '.colorize(background: :gray)
  end

  def empty_yellow(row, column)
    d_board[row][column] = '   '.colorize(background: :yellow)
  end

  def odd_even?(row, column)
    row.even? == false && column.even? == true
  end

  def odd_odd?(row, column)
    row.even? == false && column.even? == false
  end

  def even_even?(row, column)
    row.even? == true && column.even? == true
  end

  def even_odd?(row, column)
    row.even? == true && column.even? == false
  end

  def change_start(start_square)
    case start_square
    in [row, column] if odd_even?(row, column)
      empty_gray(row, column)
    in [row, column] if odd_odd?(row, column)
      empty_yellow(row, column)
    in [row, column] if even_even?(row, column)
      empty_yellow(row, column)
    in [row, column] if even_odd?(row, column)
      empty_gray(row, column)
    end
  end

  def change_end(end_square, color, piece)
    case end_square
    in [row, column] if odd_even?(row, column)
      piece_gray(piece, color, row, column)
    in [row, column] if odd_odd?(row, column)
      piece_yellow(piece, color, row, column)
    in [row, column] if even_even?(row, column)
      piece_yellow(piece, color, row, column)
    in [row, column] if even_odd?(row, column)
      piece_gray(piece, color, row, column)
    end
  end
end
