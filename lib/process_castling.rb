# frozen_string_literal: true

require_relative 'castling'
require_relative 'positions'

# This class prepares args for the Castling class. Then the Castling class is created.
# This class then sends a #castling_available? message to the Castling class.
# If true, a #do_castling message is sent.
# #display_rook_castling helps with visually updating the board.
class ProcessCatling
  attr_reader :white_pieces, :black_pieces, :display_move
  attr_accessor :castling

  def initialize(white_pieces, black_pieces, display_move)
    @white_pieces = white_pieces
    @black_pieces = black_pieces
    @display_move = display_move
    @castling = nil
  end

  include Positions

  def castling_possible?(move_arr, color)
    create_castling_class(move_arr, color)
    castling.castling_available?
  end

  def invoke_castling
    castling.do_castling
  end

  def display_rook_castling(move_arr, color)
    move = if move_arr.first < move_arr.last
             rook_move_left(color, move_arr.last)
           else
             rook_move_right(color, move_arr.last)
           end

    display_move.change_position(move, color)
  end

  private

  def create_castling_class(move_arr, color)
    positions = all_positions(white_pieces, black_pieces)
    args = castling_args(move_arr, positions, color)
    self.castling = Castling.new(args)
  end

  def choose_pieces(color)
    if color == 'white'
      white_pieces
    else
      black_pieces
    end
  end

  def castling_args(move_arr, positions, color)
    current_player_pieces = choose_pieces(color)

    rook = if move_arr.first < move_arr.last
             current_player_pieces[:rook2]
           else
             current_player_pieces[:rook1]
           end

    { rook:,
      king: current_player_pieces[:king],
      positions:,
      move: move_arr.last }
  end

  def rook_move_left(color, move)
    if color == 'white'
      ['h1', "#{(move[0].ord - 1).chr}#{move[1]}"].join(' ')
    else
      ['h8', "#{(move[0].ord - 1).chr}#{move[1]}"].join(' ')
    end
  end

  def rook_move_right(color, move)
    if color == 'white'
      ['a1', "#{move[0].next}#{move[1]}"].join(' ')
    else
      ['a8', "#{move[0].next}#{move_arr[1]}"].join(' ')
    end
  end
end
