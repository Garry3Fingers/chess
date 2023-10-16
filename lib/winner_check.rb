# frozen_string_literal: true

# This class checks if one of the players has won the game or if it's a draw.
class WinnerCheck
  attr_reader :check, :mate, :process_castling

  def initialize(check, mate, process_castling)
    @check = check
    @mate = mate
    @process_castling = process_castling
  end

  def stalemate(color)
    return false if check.check_color == color_check
    return false unless mate.process_mate(color)
    return false if can_make_castling?(color)

    puts "Stalemate! It's a draw."
    true
  end

  def checkmate(color_check, color_player)
    return false unless check.check_color == color_check
    return false unless mate.process_mate(color_check)

    puts "Checkmate! #{color_player.capitalize} player won the match!"
    true
  end

  private

  def can_make_castling?(color)
    if color == 'white'
      process_castling.castling_possible?(%w[e1 g1], color) || process_castling.castling_possible?(%w[e1 c1], color)
    else
      process_castling.castling_possible?(%w[e8 g8], color) || process_castling.castling_possible?(%w[e8 c8], color)
    end
  end
end
