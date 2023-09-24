# frozen_string_literal: true

require_relative 'castling'
require_relative 'attackable_king'

# An instance of this class performs one player move on the board.
# If it's an illegal move, it returns false.
class Move
  attr_accessor :current_player_pieces, :pieces_other_player, :en_passant

  def initialize(current_player_pieces, pieces_other_player, en_passant)
    @current_player_pieces = current_player_pieces
    @pieces_other_player = pieces_other_player
    @en_passant = en_passant
  end

  include AttackableKing

  def make_move(move)
    move_arr = move.split(' ')
    current_player_pos = positions_hash(current_player_pieces)
    pos = all_positions
    return false if select_move(move_arr, current_player_pos, pos)

    del_piece(move_arr.last.to_sym)
    true
  end

  def castling(move)
    move_arr = move.split(' ')
    current_player_pos = positions_hash(current_player_pieces)
    pos = all_positions
    return false if king_under_attack?(move_arr, pos, current_player_pos)
    return false unless perform_castling(move_arr, pos)

    en_passant.pawn_container.clear
    true
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

  def can_make_move?(start_pos, end_pos, player_pos, pos)
    current_player_pieces[player_pos[start_pos]].can_make_move?(end_pos, pos) == false
  end

  def move(start_pos, end_pos, player_pos)
    current_player_pieces[player_pos[start_pos]].change_position(end_pos)
  end

  def del_piece(move)
    positions = positions_hash(pieces_other_player)
    return unless positions.key?(move)

    pieces_other_player.delete(positions[move])
  end

  def check_move(move_arr, current_player_pos, pos)
    return false if king_under_attack?(move_arr, pos, current_player_pos)
    return false if check_before_move(current_player_pos, move_arr)
    return false if current_player_pos.include?(move_arr.last.to_sym)
    return false if can_make_move?(move_arr.first.to_sym, move_arr.last, current_player_pos, pos)

    true
  end

  def select_move(move_arr, current_player_pos, pos)
    if check_move(move_arr, current_player_pos, pos)
      en_passant.look_for_pawn(move_arr, pos)
      move(move_arr.first.to_sym, move_arr.last, current_player_pos)
      false
    elsif en_passant.check_en_passant(move_arr)
      en_passant.en_passant(move_arr.last)
      false
    else
      true
    end
  end

  def castling_args(move_arr, positions)
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

  def perform_castling(move_arr, positions)
    Castling.new(castling_args(move_arr, positions)).perform_castling
  end
end
