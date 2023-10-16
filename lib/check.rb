# frozen_string_literal: true

require 'colorize'
require_relative 'positions'
require_relative 'deep_copy'

# This class determines whether there is a king in check.
class Check
  attr_reader :white_pieces, :black_pieces, :en_passant
  attr_accessor :check_color

  def initialize(white_pieces, black_pieces, en_passant)
    @white_pieces = white_pieces
    @black_pieces = black_pieces
    @en_passant = en_passant
    @check_color = ''
  end

  include Positions
  include DeepCopy

  def after_move(color)
    @check_color = ''
    notify_about_check(color)
  end

  def before_move(move_arr, color)
    return false unless fake_move(move_arr, color)

    true
  end

  def before_en_passant(move_arr, color)
    return false unless en_passant_fake(move_arr, color)

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

  def notify_about_check(color)
    positions = all_positions(white_pieces, black_pieces)
    attacking_piece = if color == 'white'
                        find_attacking_piece(black_pieces[:king].position, white_pieces, positions)
                      elsif color == 'black'
                        find_attacking_piece(white_pieces[:king].position, black_pieces, positions)
                      end

    return if attacking_piece.nil?

    change_check_color(color)
    notify_message(color, attacking_piece)
  end

  def find_pawn(position, pieces)
    pieces.each do |name, piece|
      return name if piece.position == position
    end
  end

  def do_fake_en_passant(move_arr, color, main_copy, minor_copy)
    pawn = find_pawn(move_arr.first, main_copy)
    main_copy[pawn].position = move_arr.last
    minor_copy.delete(en_passant.pawn_container[color])
    new_positions = all_positions(main_copy, minor_copy)
    find_attacking_piece(main_copy[:king].position, minor_copy, new_positions)
  end

  def en_passant_fake(move_arr, color)
    attacking_piece = if color == 'white'
                        do_fake_en_passant(move_arr, 'black', deep_copy(white_pieces), deep_copy(black_pieces))
                      else
                        do_fake_en_passant(move_arr, 'white', deep_copy(black_pieces), deep_copy(white_pieces))
                      end

    return if attacking_piece.nil?

    true
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

  def process_move(move_arr, positions, copy_move_pieces, copy_pieces)
    return nil unless make_fake_move(copy_move_pieces, move_arr, positions)

    new_positions = all_positions(copy_move_pieces, copy_pieces)
    find_attacking_piece(copy_move_pieces[:king].position, copy_pieces, new_positions)
  end

  def fake_move(move_arr, color)
    positions = all_positions(white_pieces, black_pieces)
    attacking_piece = if color == 'white'
                        process_move(move_arr, positions, deep_copy(white_pieces), deep_copy(black_pieces))
                      else
                        process_move(move_arr, positions, deep_copy(black_pieces), deep_copy(white_pieces))
                      end
    return false if attacking_piece.nil?

    true
  end
end
