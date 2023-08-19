# frozen_string_literal: true

require_relative 'bishop'
require_relative 'king'
require_relative 'knight'
require_relative 'pawn'
require_relative 'queen'
require_relative 'rook'
require_relative 'coordinate_board'

# This class has two public interfaces.
# Interfaces: white_pieces and black_pieces. Its return hash with pieces.
class CreatePieces
  attr_reader :board

  def initialize
    @board = create_board
  end

  def white_pieces
    pawns = pawns(6, 'white')
    knights = knights('b1', 'g1')
    rooks = rooks('a1', 'h1')
    bishops = bishops('c1', 'f1')
    king = king('e1')
    queen = queen('d1')
    pawns.merge(knights, rooks, bishops, king, queen)
  end

  def black_pieces
    pawns = pawns(1, 'black')
    knights = knights('b8', 'g8')
    rooks = rooks('a8', 'h8')
    bishops = bishops('c8', 'f8')
    king = king('e8')
    queen = queen('d8')
    pawns.merge(knights, rooks, bishops, king, queen)
  end

  private

  def pawn(position, color)
    Pawn.new(position, board, color)
  end

  def pawns(row_index, color)
    pawns = {}
    i = 1

    board[row_index].each do |position|
      pawn = ":pawn#{i}"
      i += 1
      pawns[pawn.to_sym] = pawn(position, color)
    end

    pawns
  end

  def knight(position)
    Knight.new(position, board)
  end

  def knights(first_square, second_square)
    knights = {}
    knights[:knight1] = knight(first_square)
    knights[:knight2] = knight(second_square)
    knights
  end

  def rook(position)
    Rook.new(position, board)
  end

  def rooks(first_square, second_square)
    rooks = {}
    rooks[:rook1] = rook(first_square)
    rooks[:rook2] = rook(second_square)
    rooks
  end

  def bishop(position)
    Bishop.new(position, board)
  end

  def bishops(first_square, second_square)
    bishops = {}
    bishops[:queen1] = bishop(first_square)
    bishops[:queen1] = bishop(second_square)
    bishops
  end

  def queen(position)
    queen = Queen.new(position, board)
    { queen: }
  end

  def king(position)
    king = King.new(position, board)
    { king: }
  end

  def create_board
    CoordinateBoard.new.board
  end
end
