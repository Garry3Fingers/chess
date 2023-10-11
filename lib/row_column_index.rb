# frozen_string_literal: true

# These methods allow you to find coordinates on the board.
module RowColumnIndex
  def row_index(location)
    board.index { |arr| arr.include?(location) }
  end

  def column_index(location)
    board.each do |arr|
      column = arr.index(location)
      return column unless column.nil?
    end
  end
end
