# frozen_string_literal: true

# This module finds and checks the potencial move of the bishop piece.
# Key method: #check_bishop_postions and add_potencial_moves.
module FindBishopMoves
  def first_diagonal(moves, row, column)
    if row <= 7 && column <= 7
      moves << [row, column]
      first_diagonal(moves, row + 1, column + 1)
    else
      moves
    end
  end

  def second_diagonal(moves, row, column)
    if row <= 7 && column >= 0
      moves << [row, column]
      second_diagonal(moves, row + 1, column - 1)
    else
      moves
    end
  end

  def third_diagonal(moves, row, column)
    if row >= 0 && column <= 7
      moves << [row, column]
      third_diagonal(moves, row - 1, column + 1)
    else
      moves
    end
  end

  def four_diagonal(moves, row, column)
    if row >= 0 && column >= 0
      moves << [row, column]
      four_diagonal(moves, row - 1, column - 1)
    else
      moves
    end
  end

  def add_bishop_potencial_moves(row, column)
    moves = []
    moves = first_diagonal(moves, row + 1, column + 1)
    moves = second_diagonal(moves, row + 1, column - 1)
    moves = third_diagonal(moves, row - 1, column + 1)
    four_diagonal(moves, row - 1, column - 1)
  end

  def check_bishop_postions(pontecial_moves, destination_coordinate)
    pontecial_moves.any? { |arr| arr == destination_coordinate }
  end
end
