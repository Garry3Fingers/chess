# frozen_string_literal: true

require_relative 'round'

# This class implements a chess game.
class Chess
  attr_accessor :args

  def initialize(args)
    @args = args
  end

  def play_chess
    start_message

    loop do
      break if play_round == true
    end
  end

  private

  def start_message
    puts <<~MESSAGE
      Welcome to the game of chess.
      Chess is a board game for two players, called White and Black,
      each controlling an army of chess pieces in their color,
      with the objective to checkmate the opponent's king.
    MESSAGE

    puts ''
  end

  def play_round
    Round.new(args).play
  end
end
