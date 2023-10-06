# frozen_string_literal: true

require_relative 'move'

# This class implements one round of the game.
class Round
  attr_reader :display_board, :display_move, :promote_pawn, :en_passant, :check, :mate
  attr_accessor :white_pieces, :black_pieces

  def initialize(args)
    @white_pieces = args[:white_pieces]
    @black_pieces = args[:black_pieces]
    @display_board = args[:display_board]
    @display_move = args[:display_move]
    @en_passant = args[:en_passant]
    @promote_pawn = args[:promote_pawn]
    @check = args[:check]
    @mate = args[:mate]
  end

  def play
    print_board
    return true if check_end_game('white', 'black')

    puts "\nThe white player makes a move."
    player_move(input, white_pieces, black_pieces, 'white')
    print_board
    return true if check_end_game('black', 'white')

    puts "\nThe black player makes a move."
    player_move(input, black_pieces, white_pieces, 'black')
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

  def move(pieces, enemy_pieces, move, color)
    Move.new(pieces, enemy_pieces, en_passant, check).make_move(move, color)
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

  def castling(player_move, pieces, enemy_pieces, color)
    if !perform_castling(pieces, enemy_pieces, player_move, color)
      puts 'You can\'t make an illegal move. Try again!'
      player_move(input, pieces, enemy_pieces, color)
    else
      display_pos_change(player_move, color)
      display_rook_castling(player_move, color)
    end
  end

  def perform_castling(pieces, enemy_pieces, move, color)
    Move.new(pieces, enemy_pieces, en_passant, check).castling(move, color)
  end

  def standard_move(player_move, pieces, enemy_pieces, color)
    if !move(pieces, enemy_pieces, player_move, color)
      puts 'You can\'t make an illegal move. Try again!'
      player_move(input, pieces, enemy_pieces, color)
    else
      display_pos_change(player_move, color)
      promote_pawn.promote(player_move.split.last)
    end
  end

  def player_move(player_move, pieces, enemy_pieces, color)
    move_arr = player_move.split(' ')

    if move_arr.first == 'castling'
      move_arr.shift
      castling(move_arr.join(' '), pieces, enemy_pieces, color)
    else
      standard_move(player_move, pieces, enemy_pieces, color)
    end
  end

  def stalemate(color)
    return false unless mate.process_mate(color)

    puts "Stalemate! It's a draw."
    true
  end

  def checkmate(color_check, color_player)
    return false unless check.check_color == color_check
    return false unless mate.process_mate(color_check)

    puts "Checkmate! #{color_player.capitalize} player won the match!"
    true
  end

  def check_end_game(color_check, color_player)
    return true if checkmate(color_check, color_player) || stalemate(color_check)

    false
  end
end
