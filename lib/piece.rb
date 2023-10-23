# frozen_string_literal: true

require_relative 'row_column_index'

# This class is a template for more specializes piece types
class Piece
  attr_reader :board
  attr_accessor :position

  def initialize(position, board)
    @board = board
    @position = position
  end

  include RowColumnIndex

  def change_position(move)
    self.position = move
  end

  def can_make_move?(move, positions); end
end
