# frozen_string_literal: true

# This class handles a special case: en passant move in chess.
class EnPassant
  attr_reader :white_pieces, :black_pieces, :display_move
  attr_accessor :pawn_container

  def initialize(white_pieces, black_pieces, display_move)
    @white_pieces = white_pieces
    @black_pieces = black_pieces
    @display_move = display_move
    @pawn_container = {}
  end

  def perform_en_passant(move_arr, positions)
    if pawn_container.empty?
      find_pawn(move_arr, positions)
      false
    elsif find_next_move_piece(move_arr)
      true
    else
      pawn_container.clear
      find_pawn(move_arr, positions)
      false
    end
  end

  private

  def check_type_piece(pieces, pos)
    pieces.each do |name, piece|
      return name if piece.position == pos && name.start_with?('pawn')
    end

    'not found'
  end

  def add_pawn(pawn, move_arr, positions, name)
    return if pawn.first_move == false
    return if pawn.can_make_move?(move_arr.last, positions) == false
    return if (move_arr.first[1].to_i - move_arr.last[1].to_i).abs != 2

    pawn_container[pawn.color] = name
  end

  def find_pawn(move_arr, positions)
    white_pawn_name = check_type_piece(white_pieces, move_arr.first)
    black_pawn_name = check_type_piece(black_pieces, move_arr.first)

    if white_pawn_name != 'not found'
      add_pawn(white_pieces[white_pawn_name], move_arr, positions, white_pawn_name)
    elsif black_pawn_name != 'not found'
      add_pawn(black_pieces[black_pawn_name], move_arr, positions, black_pawn_name)
    end
  end

  def check_top_diagonals(position, move)
    [
      "#{(position[0].ord - 1).chr}#{position[1].next}",
      "#{position[0].next}#{position[1].next}"
    ].include?(move)
  end

  def check_bottom_diagonals(position, move)
    [
      "#{(position[0].ord - 1).chr}#{(position[1].ord - 1).chr}",
      "#{position[0].next}#{(position[1].ord - 1).chr}"
    ].include?(move)
  end

  def check_bottom_square(move)
    return unless black_pieces.key?(pawn_container['black'])

    "#{move[0]}#{move[1].to_i - 1}" == black_pieces[pawn_container['black']].position
  end

  def check_top_square(move)
    return unless white_pieces.key?(pawn_container['white'])

    "#{move[0]}#{move[1].to_i + 1}" == white_pieces[pawn_container['white'].position]
  end

  def try_en_passant(pawn, move)
    if pawn.color == 'white'
      return false if check_top_diagonals(pawn.position, move) == false
      return false if check_bottom_square(move) == false

      en_passant(pawn, move)
    elsif pawn.color == 'black'
      return false if check_bottom_diagonals(pawn.position, move) == false
      return false if check_top_square(move) == false

      en_passant(pawn, move)
    end

    true
  end

  def find_next_move_piece(move_arr)
    white_pawn_name = check_type_piece(white_pieces, move_arr.first)
    black_pawn_name = check_type_piece(black_pieces, move_arr.first)

    if white_pawn_name != 'not found'
      try_en_passant(white_pieces[white_pawn_name], move_arr.last)
    elsif black_pawn_name != 'not found'
      try_en_passant(black_pieces[black_pawn_name], move_arr.last)
    end
  end

  def en_passant(pawn, move)
    pawn.position = move
    if pawn.color == 'white'
      # display_move.change_start(black_pieces[pawn_container['black']].position)

      black_pieces.delete(pawn_container['black'])
    else
      # display_move.change_start(white_pieces[pawn_container['white']].position)
      white_pieces.delete(pawn_container['white'])
    end
  end
end
