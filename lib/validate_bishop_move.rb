# frozen_string_literal: true

# This module checks other pieces in the path of the bishop's move.
# Key method: #check_bishop_path.
module ValidateBishopMove
  def check_top_right_diagonal(move, check_pos)
    i = "#{position[0].next}#{position[1].next}"
    until i == move
      check_pos << i
      i = "#{i[0].next}#{i[1].next}"
    end

    check_pos
  end

  def check_top_left_diagonal(move, check_pos)
    i = "#{(position[0].ord - 1).chr}#{position[1].next}"
    until i == move
      check_pos << i
      i = "#{(i[0].ord - 1).chr}#{i[1].next}"
    end

    check_pos
  end

  def check_bottom_right_diagnoal(move, check_pos)
    i = "#{position[0].next}#{(position[1].ord - 1).chr}"
    until i == move
      check_pos << i
      i = "#{i[0].next}#{(i[1].ord - 1).chr}"
    end

    check_pos
  end

  def check_bottom_left_diagnoal(move, check_pos)
    i = "#{(position[0].ord - 1).chr}#{(position[1].ord - 1).chr}"
    until i == move
      check_pos << i
      i = "#{(i[0].ord - 1).chr}#{(i[1].ord - 1).chr}"
    end

    check_pos
  end

  def displacing_positions(move, check_pos)
    if move[1] > position[1] && move[0] > position[0]
      check_top_right_diagonal(move, check_pos)
    elsif move[1] > position[1] && move[0] < position[0]
      check_top_left_diagonal(move, check_pos)
    elsif move[1] < position[1] && move[0] > position[0]
      check_bottom_right_diagnoal(move, check_pos)
    else
      check_bottom_left_diagnoal(move, check_pos)
    end
  end

  def check_bishop_path(move, positions)
    check_pos = []

    check_pos = displacing_positions(move, check_pos)

    way_pos = positions.keep_if { |pos| check_pos.include?(pos) }
    return false unless way_pos.empty?

    true
  end
end
