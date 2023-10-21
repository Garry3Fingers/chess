# frozen_string_literal: true

# This class implements one round of the game.
class Round
  attr_reader :display_board, :display_move, :promote_pawn, :mate, :move, :winner_check

  def initialize(args)
    @display_board = args[:display_board]
    @display_move = args[:display_move]
    @move = args[:move]
    @promote_pawn = args[:promote_pawn]
    @mate = args[:mate]
    @winner_check = args[:winner_check]
  end

  def play
    print_board
    return true if winner?('white', 'black')

    puts "\nThe white player makes a move."
    player_move(input, 'white')
    print_board
    return true if winner?('black', 'white')

    puts "\nThe black player makes a move."
    player_move(input, 'black')
  end

  private

  def input
    input = ''

    until /(castling )?[a-h][1-8] [a-h][1-8]/.match?(input)
      puts "\nEnter the position of the piece to move.\nAnd after the space, the place where to move the piece."
      input = gets.chomp
    end
    input
  end

  def print_board
    display_board.print_board
  end

  def make_move(player_move, color)
    move.make_move(player_move, color)
  end

  def display_pos_change(move, color)
    display_move.change_position(move, color)
  end

  def rook_move_left(color, move)
    if color == 'white'
      ['h1', "#{(move[0].ord - 1).chr}#{move[1]}"].join(' ')
    else
      ['h8', "#{(move[0].ord - 1).chr}#{move[1]}"].join(' ')
    end
  end

  def rook_move_right(color, move)
    if color == 'white'
      ['a1', "#{move[0].next}#{move[1]}"].join(' ')
    else
      ['a8', "#{move[0].next}#{move_arr[1]}"].join(' ')
    end
  end

  def display_rook_castling(player_move, color)
    move_arr = player_move.split(' ')

    move = if move_arr.first < move_arr.last
             rook_move_left(color, move_arr.last)
           else
             rook_move_right(color, move_arr.last)
           end

    display_move.change_position(move, color)
  end

  def castling(player_move, color)
    if !perform_castling(player_move, color)
      puts 'You can\'t make an illegal move. Try again!'
      player_move(input, color)
    else
      display_pos_change(player_move, color)
      display_rook_castling(player_move, color)
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

    if move_arr.first == 'castling'
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
end
