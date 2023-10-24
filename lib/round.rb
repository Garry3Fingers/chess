# frozen_string_literal: true

require_relative 'save_game'

# This class implements one round of the game.
class Round
  attr_reader :display_board, :display_move, :promote_pawn, :mate, :move, :winner_check, :args
  attr_accessor :color

  def initialize(args)
    @display_board = args[:display_board]
    @display_move = args[:display_move]
    @move = args[:move]
    @promote_pawn = args[:promote_pawn]
    @mate = args[:mate]
    @winner_check = args[:winner_check]
    @args = args
    @color = args[:color] || 'white'
  end

  def print_board
    display_board.print_board
  end

  def play
    case color
    when 'white'
      white_move
      return true if winner?('black', 'white')
    when 'black'
      black_move
      return true if winner?('white', 'black')
    end
  end

  private

  def input
    input = ''

    until /(castling )?[a-h][1-8] [a-h][1-8]|[save]/.match?(input)
      puts "\nEnter the position of the piece to move.\nAnd after the space, the place where to move the piece."
      input = gets.chomp
    end
    input
  end

  def make_move(player_move, color)
    move.make_move(player_move, color)
  end

  def display_pos_change(move, color)
    display_move.change_position(move, color)
  end

  def white_move
    puts "\nThe white player makes a move."
    player_move(input, 'white')
    print_board
    self.color = 'black'
  end

  def black_move
    puts "\nThe black player makes a move."
    player_move(input, 'black')
    print_board
    self.color = 'white'
  end

  def castling(player_move, color)
    if !perform_castling(player_move, color)
      puts 'You can\'t make an illegal move. Try again!'
      player_move(input, color)
    else
      display_pos_change(player_move, color)
    end
  end

  def perform_castling(player_move, color)
    move.castling(player_move, color)
  end

  def standard_move(player_move, color)
    if !make_move(player_move, color)
      puts 'You can\'t make an illegal move. Try again!'
      player_move(input, color)
    else
      display_pos_change(player_move, color)
      promote_pawn.promote(player_move.split.last)
    end
  end

  def player_move(player_move, color)
    move_arr = player_move.split(' ')

    if move_arr.first == 'save'
      save_game(args)
      player_move(input, color)
    elsif move_arr.first == 'castling'
      move_arr.shift
      castling(move_arr.join(' '), color)
    else
      standard_move(player_move, color)
    end
  end

  def winner?(color_check, color_player)
    return true if winner_check.checkmate(color_check, color_player)
    return true if winner_check.stalemate(color_check)

    false
  end

  def save_game(data)
    data[:color] = color
    SaveGame.new(data).save
  end
end
