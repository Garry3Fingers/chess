# frozen_string_literal: true

# This module checks other pieces in the path of the rook's move.
# Key method: #check_rook_path.
module ValidateRookMove
  def filter_pos(move, positions)
    if position[0] == move[0]
      positions.keep_if { |pos| pos[0] == position[0] }
    else
      positions.keep_if { |pos| /[a-h]#{move[1]}/.match?(pos) }
    end
  end

  def blocking_positions(move, positions)
    if position < move
      positions.keep_if { |pos| pos > position && pos < move }
    else
      positions.keep_if { |pos| pos < position && pos > move }
    end
  end

  def check_rook_path(move, positions)
    positions = filter_pos(move, positions)

    way_pos = blocking_positions(move, positions)

    return false unless way_pos.empty?

    true
  end
end
