class Sudoku

  def initialize(board_string)
    @sudoku_board = Board.new(board_string)
  end

  def solve!
    until @sudoku_board.solved?
    last_sudoku_board = @sudoku_board.clone.to_s
    @sudoku_board.find_a_cell_and_fix_it!
    raise "I'm too old for this s*!t" if last_sudoku_board == @sudoku_board.to_s # WE NEED TO GUESS
    end

  end

  def board
    @sudoku_board.to_s
  end

end

class Cell
  attr_reader :possible

  def initialize(known_value)
   known_value == 0 ? @possible = (1..9).to_a : @possible = [known_value]
  end


  def it_cant_be!(number)
    @possible = @possible.delete_if { |value| value == number }
  end

  def to_s
    @possible.length == 1 ? @possible[0] : 0
  end
end

class Board

  def initialize(string)
    @row_size = 9
    @box_length = 3
    @board = Array.new(@row_size) {Array.new(@row_size)}
    string.split('').each_with_index do |number, index|
      @board[index / @row_size][index % @row_size] = Cell.new(number.to_i)
    end

  end

  def get_row(row) # return array of cells in given row
    @board[row].map {|cell| cell.to_s}
  end

  def get_col(col) # return array of cells in given column
    @board.map {|row| row[col].to_s}
  end

  def get_box(box) # return array of cells in given box
    box_array = Array.new
    @board.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        box_array << cell.to_s if (((((row_index)/3) * 3) + (cell_index/3)) == box)
      end
    end
    box_array
  end

    def find_a_cell_and_fix_it!
    @board.flatten.each_with_index do |cell, index|
      unless cell.possible.length <= 1
        row = index/9 ; col = index % 9 ; box = (row/3)*3 + (col/3)
        fix_the_cell!(cell, row, col, box)
      end
    end
  end

  def fix_the_cell!(cell, row, col, box)
    get_row(row).each {|rowval| cell.it_cant_be!(rowval)}
    return if cell.possible.length == 1
    get_col(col).each {|colval| cell.it_cant_be!(colval)}
    return if cell.possible.length == 1
    get_box(box).each {|boxval| cell.it_cant_be!(boxval)}
  end

  def solved?
    @board.each {|row| row.each {|cell| return false unless cell.possible.length == 1}}
    true
  end

  def to_s
    beautiful_board = String.new
    beautiful_board << build_bar(@box_length)
    @board.each_with_index do |row, row_index|
      row.each_with_index do |item, item_index|
        beautiful_board << '| ' if bar_conditions?(item_index)
        beautiful_board << "#{item.to_s}"
        beautiful_board << ' ' if item_index < @row_size
      end
      beautiful_board << "\n"
      beautiful_board << build_bar(@box_length) if row_index % @box_length == 2
    end
    beautiful_board
  end

  def build_bar(box_length) # return string with horizontal box separator
    line = String.new
    board_length = 2*(@row_size) - 1 + 2 * (@box_length - 1)
    board_length.times {line << "-"}
    line += "\n"
  end

  def bar_conditions?(index)
    index % @box_length == 0 && index != 0
  end

end