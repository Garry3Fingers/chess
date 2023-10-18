# frozen_string_literal: true

# This class implements a move known as castling.
class Castling
  attr_reader :move
  attr_accessor :king, :rook, :positions

  def initialize(args)
    @king = args[:king]
    @rook = args[:rook]
    @positions = args[:positions]
    @move = args[:move]
  end

  def castling_available?
    first_move? && clear_path? && two_square?
  end

  def do_castling
    king_pos = king.position
    rook_pos = rook.position
    king.position = move
    king.first_move = false
    rook.position = rook_position(king_pos, rook_pos)
    rook.first_move = false
  end

  private

  def first_move?
    king.first_move == true && rook.first_move == true
  end

  def check_left_path(king_pos, rook_pos)
    i = "#{(king_pos[0].ord - 1).chr}#{king_pos[1]}"

    until i == rook_pos
      return true if positions.include?(i)

      i = "#{(i[0].ord - 1).chr}#{i[1]}"
    end

    false
  end

  def check_right_path(king_pos, rook_pos)
    i = "#{king_pos[0].next}#{king_pos[1]}"

    until i == rook_pos
      return true if positions.include?(i)

      i = "#{i[0].next}#{i[1]}"
    end

    false
  end

  def clear_path?
    king_pos = king.position
    rook_pos = rook.position

    if king_pos < rook_pos
      return false if check_right_path(king_pos, rook_pos)
    elsif king_pos > rook_pos
      return false if check_left_path(king_pos, rook_pos)
    end

    true
  end

  def check_move_right(king_pos)
    i = king_pos
    j = 0
    until i == move
      j += 1
      i = "#{i[0].next}#{i[1]}"
    end

    j
  end

  def check_move_left(king_pos)
    i = king_pos
    j = 0
    until i == move
      j += 1
      i = "#{(i[0].ord - 1).chr}#{i[1]}"
    end

    j
  end

  def two_square?
    king_pos = king.position

    squares = if king_pos < move
                check_move_right(king_pos)
              else
                check_move_left(king_pos)
              end

    return false unless squares == 2

    true
  end

  def rook_position(king_pos, rook_pos)
    if king_pos < rook_pos
      "#{(move[0].ord - 1).chr}#{move[1]}"
    else
      "#{move[0].next}#{move[1]}"
    end
  end
end
