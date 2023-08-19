# frozen_string_literal: true

require_relative 'create_pieces'

# An instance of this class performs one player move on the board and returns an update hash of pieces.
# If it's an illegal move, it returns false.
class Move
  attr_accessor :pieces

  def initialize(pieces)
    @pieces = pieces
  end

  def make_move(move)
    move_arr = move.split(' ')
    positions = positions_hash
    if pieces[positions[move_arr.first.to_sym]].change_position(move_arr.last) == false
      false
    else
      pieces
    end
  end

  private

  def positions_hash
    positions = {}

    pieces.each do |key, value|
      pos = value.position
      positions[pos.to_sym] = key
    end

    positions
  end
end
