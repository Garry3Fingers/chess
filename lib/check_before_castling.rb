# frozen_string_literal: true

require_relative 'row_column_index'
require_relative 'positions'

# This class checks to ensure that the king piece does't pass through or finish on a square attacked by an enemy piece.
class CheckBeforeCastling
  attr_reader :board, :white_pieces, :black_pieces

  def initialize(board, white_pieces, black_pieces)
    @board = board
    @white_pieces = white_pieces
    @black_pieces = black_pieces
  end

  include RowColumnIndex
  include Positions

  def path_is_secure?(move_arr, color)
    positions = select_positions(color)
    return false unless king?(positions[:player_pos], move_arr)
    return false unless check_path(positions[:all_positions], move_arr, color)

    true
  end

  private

  def select_positions(color)
    player_pos = if color == 'white'
                   positions_hash(white_pieces)
                 else
                   positions_hash(black_pieces)
                 end

    all_positions = all_positions(white_pieces, black_pieces)

    { player_pos:, all_positions: }
  end

  def select_pieces(color)
    if color == 'white'
      black_pieces
    else
      white_pieces
    end
  end

  def find_rook_indexes(move_arr)
    king_square = [row_index(move_arr.last), column_index(move_arr.last)]
    if move_arr.last > move_arr.first
      [king_square.first, king_square.last - 1]
    else
      [king_square.first, king_square.last + 1]
    end
  end

  def rook_square(move_arr)
    rook_indexes = find_rook_indexes(move_arr)
    board[rook_indexes.first][rook_indexes.last]
  end

  def king?(player_pos, move_arr)
    piece_pos = move_arr.first.to_sym
    return false unless player_pos.key?(piece_pos)

    player_pos[piece_pos] == :king
  end

  def square_under_attack?(square, positions, color)
    pieces_other_player = select_pieces(color)

    pieces_other_player.each do |name, piece|
      return true if name.start_with?('pawn') && piece.can_make_move?(square, [square])
      return true if piece.can_make_move?(square, positions)
    end

    false
  end

  def check_path(positions, move_arr, color)
    return false if square_under_attack?(move_arr.last, positions, color)

    rook_pos = rook_square(move_arr)
    return false if square_under_attack?(rook_pos, positions, color)

    true
  end
end
