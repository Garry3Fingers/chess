# frozen_string_literal: true

require_relative 'create_pieces'

# An instance of this class performs one player move on the board.
# If it's an illegal move, it returns false.
class Move
  attr_accessor :current_player_pieces, :pieces_other_player

  def initialize(current_player_pieces, pieces_other_player)
    @current_player_pieces = current_player_pieces
    @pieces_other_player = pieces_other_player
  end

  def make_move(move)
    move_arr = move.split(' ')
    current_player_pos = positions_hash(current_player_pieces)
    pos = all_positions
    return false if check_move(move_arr, current_player_pos, pos)

    del_piece(move_arr.last.to_sym)
  end

  private

  def positions_hash(pieces)
    positions = {}

    pieces.each do |key, value|
      pos = value.position
      positions[pos.to_sym] = key
    end

    positions
  end

  def positions_arr(pieces)
    positions = []

    pieces.each_value do |value|
      pos = value.position
      positions << pos
    end

    positions
  end

  def all_positions
    first_player = positions_arr(current_player_pieces)
    second_player = positions_arr(pieces_other_player)
    first_player + second_player
  end

  def check_before_move(positions, move_arr)
    positions.include?(move_arr.first.to_sym) == false || move_arr.uniq.length == 1
  end

  def move(start_pos, end_pos, player_pos, pos)
    current_player_pieces[player_pos[start_pos]].change_position(end_pos, pos) == false
  end

  def del_piece(move)
    positions = positions_hash(pieces_other_player)
    return unless positions.key?(move)

    pieces_other_player.delete(positions[move])
  end

  def king?(positions, move_arr)
    piece_pos = move_arr.first.to_sym
    return unless positions.key?(piece_pos)

    positions[piece_pos] == :king
  end

  def king_under_attack?(move, positions, current_player_pos)
    return unless king?(current_player_pos, move)

    pieces_other_player.each_value do |value|
      return true if value.can_make_move?(move.last, positions)
    end
  end

  def check_move(move_arr, current_player_pos, pos)
    return true if king_under_attack?(move_arr, pos, current_player_pos)
    return true if check_before_move(current_player_pos, move_arr)
    return true if current_player_pos.include?(move_arr.last.to_sym)
    return true if move(move_arr.first.to_sym, move_arr.last, current_player_pos, pos)
  end
end
