# frozen_string_literal: true

require_relative 'castling'
require_relative 'attackable_king'
require_relative 'positions'

# An instance of this class performs one player move on the board.
# If it's an illegal move, it returns false.
class Move
  attr_reader :en_passant, :check, :check_before_castling, :white_pieces, :black_pieces

  def initialize(args)
    @en_passant = args[:en_passant]
    @check = args[:check]
    @white_pieces = args[:white_pieces]
    @black_pieces = args[:black_pieces]
    @check_before_castling = args[:check_before_castling]
  end

  include Positions

  def make_move(move, color)
    move_arr = move.split(' ')
    positions = select_positions(color)
    return false if select_move(move_arr, positions, color)

    del_piece(move_arr.last.to_sym, positions, color)

    check.after_move(color)
    true
  end

  def castling(move, color)
    move_arr = move.split(' ')
    return false if check.check_color == color
    return false unless check_before_castling.path_is_secure?(move_arr, color)
    return false unless perform_castling(move_arr, all_positions(white_pieces, black_pieces), color)

    en_passant.pawn_container.clear
    true
  end

  private

  def select_positions(color)
    hash_pos = if color == 'white'
                 { player_pos: positions_hash(white_pieces),
                   delete_pos: positions_hash(black_pieces) }
               else
                 { player_pos: positions_hash(black_pieces),
                   delete_pos: positions_hash(white_pieces) }
               end

    all_positions = all_positions(white_pieces, black_pieces)

    { player_pos: hash_pos[:player_pos], delete_pos: hash_pos[:delete_pos], all_positions: }
  end

  def check_before_move(positions, move_arr)
    positions.include?(move_arr.first.to_sym) == false || move_arr.uniq.length == 1
  end

  def can_make_move?(move_arr, player_pos, positions, color)
    start_pos = move_arr.first.to_sym
    end_pos = move_arr.last
    current_player_pieces = choose_pieces(color)

    current_player_pieces[player_pos[start_pos]].can_make_move?(end_pos, positions)
  end

  def move(move_arr, positions, color)
    start_pos = move_arr.first.to_sym
    end_pos = move_arr.last
    current_player_pieces = choose_pieces(color)
    current_player_pieces[positions[:player_pos][start_pos]].change_position(end_pos)
  end

  def del_piece(move, positions, color)
    pieces_other_player = if color == 'white'
                            black_pieces
                          else
                            white_pieces
                          end

    delete_pos = positions[:delete_pos]
    return unless delete_pos.key?(move)

    pieces_other_player.delete(delete_pos[move])
  end

  def check_move(move_arr, positions, color)
    player_pos = positions[:player_pos]
    all_positions = positions[:all_positions]
    return false if check.before_move(move_arr, color)
    return false if check_before_move(player_pos, move_arr)
    return false if player_pos.include?(move_arr.last.to_sym)
    return false unless can_make_move?(move_arr, player_pos, all_positions, color)

    true
  end

  def select_move(move_arr, positions, color)
    if check_move(move_arr, positions, color)
      en_passant.look_for_pawn(move_arr, positions[:all_positions])
      move(move_arr, positions, color)
      false
    elsif en_passant.check_en_passant(move_arr) && !check.before_en_passant(move_arr, color)
      en_passant.en_passant(move_arr.last)
      false
    else
      true
    end
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

  def perform_castling(move_arr, positions, color)
    Castling.new(castling_args(move_arr, positions, color)).perform_castling
  end
end
