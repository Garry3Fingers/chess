# frozen_string_literal: true

require 'colorize'

# This class determines whether there is a king in check.
class Check
  attr_reader :white_pieces, :black_pieces
  attr_accessor :check_color

  def initialize(white_pieces, black_pieces)
    @white_pieces = white_pieces
    @black_pieces = black_pieces
    @check_color = ''
  end

  def after_move(color, positions)
    notify_about_check(color, positions)
  end

  def before_move(move_arr, color, positions)
    return false unless fake_move(move_arr, color, positions)

    true
  end

  private

  def find_attacking_piece(king_position, enemy_pieces, positions)
    enemy_pieces.each do |key, value|
      return key if key.start_with?('pawn') && value.can_make_move?(king_position, [king_position])
      return key if value.can_make_move?(king_position, positions)
    end

    nil
  end

  def change_check_color(color)
    @check_color = if color == 'white'
                     'black'
                   elsif color == 'black'
                     'white'
                   end
  end

  def notify_message(color, attacking_piece)
    if color == 'white'
      puts "White #{attacking_piece} gives check to the black king".colorize(color: :red)
    elsif color == 'black'
      puts "Black #{attacking_piece} gives check to the white king".colorize(color: :red)
    end
  end

  def notify_about_check(color, positions)
    attacking_piece = if color == 'white'
                        find_attacking_piece(black_pieces[:king].position, white_pieces, positions)
                      elsif color == 'black'
                        find_attacking_piece(white_pieces[:king].position, black_pieces, positions)
                      end

    return if attacking_piece.nil?

    change_check_color(color)
    notify_message(color, attacking_piece)
  end

  def deep_copy(object)
    Marshal.load(Marshal.dump(object))
  end

  def make_fake_move(pieces, move_arr, positions)
    pieces.each_value do |piece|
      next unless piece.position == move_arr.first
      break unless piece.can_make_move?(move_arr.last, positions)

      piece.position = move_arr.last
      return true
    end

    false
  end

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

  def white_color(move_arr, positions)
    white_pieces_copy = deep_copy(white_pieces)
    return nil unless make_fake_move(white_pieces_copy, move_arr, positions)

    new_positions = all_positions(white_pieces_copy, black_pieces)
    find_attacking_piece(white_pieces_copy[:king].position, black_pieces, new_positions)
  end

  def black_color(move_arr, positions)
    black_pieces_copy = deep_copy(black_pieces)
    return nil unless make_fake_move(black_pieces_copy, move_arr, positions)

    new_positions = all_positions(white_pieces, black_pieces_copy)
    find_attacking_piece(black_pieces_copy[:king].position, white_pieces, new_positions)
  end

  def fake_move(move_arr, color, positions)
    if color == 'white'
      attacking_piece = white_color(move_arr, positions)
    elsif color == 'black'
      attacking_piece = black_color(move_arr, positions)
    end

    return if attacking_piece.nil?

    true
  end
end
