# frozen_string_literal: true

require_relative 'move'

# This class implements one round of the game.
class Round
  attr_reader :display_board, :display_move
  attr_accessor :white_pieces, :black_pieces

  def initialize(args)
    @white_pieces = args[:white_pieces]
    @black_pieces = args[:black_pieces]
    @display_board = args[:display_board]
    @display_move = args[:display_move]
  end

  def play
    print_board
    return true if check_king(white_pieces, 'Black')

    puts "\nThe white player makes a move."
    player_move(input, white_pieces, black_pieces, 'white')
    print_board
    return true if check_king(black_pieces, 'White')

    puts "\nThe black player makes a move."
    player_move(input, black_pieces, white_pieces, 'black')
  end

  private

  def input
    input = ''

    while /[a-h][1-8] [a-h][1-8]/.match?(input) == false
      puts "\nEnter the position of the piece to move.\nAnd after the space, the place where to move the piece."
      input = gets.chomp
    end

    input
  end

  def print_board
    display_board.print_board
  end

  def move(pieces, enemy_pieces, move)
    Move.new(pieces, enemy_pieces).make_move(move)
  end

  def display_pos_change(move, color)
    display_move.change_position(move, color)
  end

  def player_move(player_move, pieces, enemy_pieces, color)
    if move(pieces, enemy_pieces, player_move) == false
      puts 'You can\'t make an illegal move. Try again!'
      player_move(input, pieces, enemy_pieces, color)
    else
      display_pos_change(player_move, color)
    end
  end

  def check_king(pieces, color)
    return if pieces.key?(:king)

    puts "#{color} player won the match!"
    true
  end
end
