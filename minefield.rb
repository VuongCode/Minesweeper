class Minefield
  attr_reader :row_count, :column_count
  attr_accessor :mine_locations, :cleared_locations

  def initialize(row_count, column_count, mine_count)
    @column_count = column_count
    @row_count = row_count
    @mine_locations = flag(mine_count)
    @cleared_locations = []
  end

  # Return true if the cell been uncovered, false otherwise.
  def cell_cleared?(row, col)
    false
  end

  def flag(number_of_mines)
    locations = []
    while number_of_mines > 0
      column = rand(column_count)
      row = rand(row_count)
      if !locations.include?([row, column])
        locations << [row, column]
        number_of_mines -= 1
      end
    end
    locations
  end

  def cell_cleared?(row, col)
    cleared_locations.include?([row, col])
  end

  # Uncover the given cell. If there are no adjacent mines to this cell
  # it should also clear any adjacent cells as well. This is the action
  # when the player clicks on the cell.
  def clear(row, col)
    while cell_cleared?(row, col) == false
      cleared_locations << [row, col]
      if adjacent_mines(row, col) == 0
        (-1..1).each do |i|
          (-1..1).each do |j|
            r = row + i
            c = col + j
            if  r >= 0 || c >= 0 || r <= 19 || c <= 19 || (r != row && c != col)
              clear(r, c)
            end
          end
        end
      end
    end
  end

  # Check if any cells have been uncovered that also contained a mine. This is
  # the condition used to see if the player has lost the game.
  def any_mines_detonated?
    (0..row_count).each do |row|
      (0..column_count).each do |column|
        if cell_cleared?(row, column) && contains_mine?(row, column)
          return true
        end
      end
    end
    false
  end

  # Check if all cells that don't have mines have been uncovered. This is the
  # condition used to see if the player has won the game.
  def all_cells_cleared?
    count = 0
    (0..row_count).each do |row|
      (0..column_count).each do |column|
        if cell_cleared?(row, column) || contains_mine?(row, column)
          count += 1
        end
      end
    end
    if count == row_count*column_count
      true
    else
      false
    end
  end

  # Returns the number of mines that are surrounding this cell (maximum of 8).
  def adjacent_mines(row, col)
    count = 0
    (-1..1).each do |i|
      (-1..1).each do |j|
        unless (i == 0 && j == 0) || (row + i) < 0 || (col + j) < 0
          if contains_mine?(row + i, col + j)
            count += 1
          end
        end
      end
    end
    count
  end

  # Returns true if the given cell contains a mine, false otherwise.
  def contains_mine?(row, col)
    if mine_locations.include?([row, col])
      true
    else
      false
    end
  end
end
