# frozen_string_literal: true

require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'coordinate_board'

# This class is responsible for changing the piece when the pawn advances to its eighth rank.
class PromotePawn
  attr_accessor :pawn_container
  attr_reader :black_pieces, :white_pieces, :display_move

  def initialize(white_pieces, black_pieces, display_move)
    @white_pieces = white_pieces
    @black_pieces = black_pieces
    @display_move = display_move
    @pawn_container = {}
  end

  def promote(position)
    return unless can_promote?(position)

    if pawn_container.key?('white')
      exchange_pawn(white_pieces, pawn_container['white'], position, 'white')
    else
      exchange_pawn(black_pieces, pawn_container['black'], position, 'black')
    end
  end

  private

  def check_pawn(position, pieces)
    pieces.each do |name, piece|
      return name if piece.position == position && name.start_with?('pawn')
    end

    nil
  end

  def eighth_rank_positions
    arr = []
    i = 'a'
    while i <= 'h'
      arr << "#{i}1"
      arr << "#{i}8"
      i = i.next
    end

    arr
  end

  def can_promote?(position)
    white_pawn = check_pawn(position, white_pieces)
    black_pawn = check_pawn(position, black_pieces)

    if !white_pawn.nil? && eighth_rank_positions.include?(position)
      pawn_container['white'] = white_pawn
      return true
    elsif !black_pawn.nil? && eighth_rank_positions.include?(position)
      pawn_container['black'] = black_pawn
      return true
    end

    false
  end

  def coordinate_board
    CoordinateBoard.new.board
  end

  def queen(position)
    Queen.new(position, coordinate_board)
  end

  def rook(position)
    Rook.new(position, coordinate_board)
  end

  def knight(position)
    Knight.new(position, coordinate_board)
  end

  def bishop(position)
    Bishop.new(position, coordinate_board)
  end

  def input
    puts 'The pawn advanced to its eighth rank. You can now exchange this pawn to other pieces.'
    input = ''
    until /[1-4]/.match?(input)
      puts 'Enter corresponding digit.'
      puts '1 - Knight, 2 - Bishop, 3 - Rook, 4 - Queen.'
      input = gets.chomp
    end
    input.to_i
  end

  def create_piece(position)
    case input
    when 1
      [knight(position), 'knight']
    when 2
      [bishop(position), 'bishop']
    when 3
      [rook(position), 'rook']
    else
      [queen(position), 'queen']
    end
  end

  def exchange_pawn(pieces, pawn_name, position, color)
    pieces.delete(pawn_name)
    new_piece = create_piece(position)
    pieces[(new_piece[1] + pawn_name[-1]).to_sym] = new_piece[0]
    add_to_board(position, color, new_piece[1])
  end

  def unicode_piece
    {
      'knight' => " \u265E ",
      'bishop' => " \u265D ",
      'rook' => " \u265C ",
      'queen' => " \u265B "
    }
  end

  def add_to_board(position, color, piece)
    display_move.empty_square(position)
    display_move.change_square(position, color, unicode_piece[piece])
  end
end
