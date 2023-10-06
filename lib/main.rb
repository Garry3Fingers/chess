# frozen_string_literal: true

require_relative 'display_board'
require_relative 'display_move'
require_relative 'create_pieces'
require_relative 'coordinate_board'
require_relative 'en_passant'
require_relative 'promotion_pawn'
require_relative 'chess'
require_relative 'check'
require_relative 'mate'

# This module helps with initializing the class Chess.
module ChessWrapper
  def self.args
    coor_board = CoordinateBoard.new.board
    display_board = DisplayBoard.new
    display_move = DisplayMove.new(coor_board, display_board)
    white_pieces = CreatePieces.new.white_pieces
    black_pieces = CreatePieces.new.black_pieces
    en_passant = EnPassant.new(white_pieces, black_pieces, display_move)
    promote_pawn = PromotePawn.new(white_pieces, black_pieces, display_move)
    check = Check.new(white_pieces, black_pieces, en_passant)
    mate = Mate.new(check, white_pieces, black_pieces, en_passant)

    {
      white_pieces:,
      black_pieces:,
      display_board:,
      display_move:,
      en_passant:,
      promote_pawn:,
      check:,
      mate:
    }
  end

  def self.start_game
    Chess.new(args).play_chess
    new_game
  end

  def self.new_game
    puts 'Do you want to play again? Enter "yes" or whatever.'
    input = gets.chomp.strip
    start_game if input == 'yes'
  end
end

ChessWrapper.start_game
