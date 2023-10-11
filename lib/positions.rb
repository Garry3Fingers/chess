# frozen_string_literal: true

# This module helps to create an array with all the positions of the pieces.
module Positions
  def positions_arr(pieces)
    positions = []

    pieces.each_value do |value|
      pos = value.position
      positions << pos
    end

    positions
  end

  def all_positions(white_p, black_p)
    white = positions_arr(white_p)
    black = positions_arr(black_p)
    white + black
  end

  def positions_hash(pieces)
    positions = {}

    pieces.each do |key, value|
      pos = value.position
      positions[pos.to_sym] = key
    end

    positions
  end
end
