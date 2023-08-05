# frozen_string_literal: true

require 'colorize'

# This class is responsible for printing a chessboard.
class DisplayBoard
  attr_accessor :board

  def initialize(board = [])
    @board = board
  end

  def print_board
    fill_board if board.empty?

    i = 8
    board.each do |arr|
      arr.each { |element| print element }
      print i if i >= 1
      i -= 1
      puts ''
    end
  end

  private

  def fill_board
    add_lines
    add_letters
    add_pawns
    add_rooks
    add_knights
    add_bishops
    add_queen_king
  end

  def yellow_first(arr = [])
    arr << '   '.colorize(background: :yellow)
    arr << '   '.colorize(background: :gray)
    return yellow_first(arr) if arr.length < 8

    arr
  end

  def gray_first(arr = [])
    arr << '   '.colorize(background: :gray)
    arr << '   '.colorize(background: :yellow)
    return gray_first(arr) if arr.length < 8

    arr
  end

  def add_lines
    board << yellow_first
    board << gray_first
    add_lines if board.length < 8
  end

  def add_letters(arr = [], letter = ' a ')
    arr << letter
    return add_letters(arr, letter.next) if arr.length < 8

    board << arr
  end

  def black_pawns(element)
    if element == '   '.colorize(background: :gray)
      " \u265F ".colorize(color: :black, background: :gray)
    else
      " \u265F ".colorize(color: :black, background: :yellow)
    end
  end

  def white_pawns(element)
    if element == '   '.colorize(background: :gray)
      " \u265F ".colorize(color: :white, background: :gray)
    else
      " \u265F ".colorize(color: :white, background: :yellow)
    end
  end

  def add_pawns
    board[1].map! do |element|
      black_pawns(element)
    end

    board[-3].map! do |element|
      white_pawns(element)
    end
  end

  def add_rooks
    board[0][0] = " \u265C ".colorize(color: :black, background: :yellow)
    board[0][-1] = " \u265C ".colorize(color: :black, background: :gray)
    board[-2][0] = " \u265C ".colorize(color: :white, background: :gray)
    board[-2][-1] = " \u265C ".colorize(color: :white, background: :yellow)
  end

  def add_knights
    board[0][1] = " \u265E ".colorize(color: :black, background: :gray)
    board[0][-2] = " \u265E ".colorize(color: :black, background: :yellow)
    board[-2][1] = " \u265E ".colorize(color: :white, background: :yellow)
    board[-2][-2] = " \u265E ".colorize(color: :white, background: :gray)
  end

  def add_bishops
    board[0][2] = " \u265D ".colorize(color: :black, background: :yellow)
    board[0][-3] = " \u265D ".colorize(color: :black, background: :gray)
    board[-2][2] = " \u265D ".colorize(color: :white, background: :gray)
    board[-2][-3] = " \u265D ".colorize(color: :white, background: :yellow)
  end

  def add_queen_king
    board[0][3] = " \u265B ".colorize(color: :black, background: :gray)
    board[0][4] = " \u265A ".colorize(color: :black, background: :yellow)
    board[-2][3] = " \u265B ".colorize(color: :white, background: :yellow)
    board[-2][4] = " \u265A ".colorize(color: :white, background: :gray)
  end
end
