# frozen_string_literal: true

# This module helps with currect moves of the king piece.
module AttackableKing
  def king?(positions, move_arr)
    piece_pos = move_arr.first.to_sym
    return unless positions.key?(piece_pos)

    positions[piece_pos] == :king
  end

  def king_under_attack?(move, positions, current_player_pos)
    return unless king?(current_player_pos, move)

    pieces_other_player.each do |key, value|
      return true if key.start_with?('pawn') && value.can_make_move?(move.last, [move.last])
      return true if value.can_make_move?(move.last, positions)
    end

    false
  end
end
