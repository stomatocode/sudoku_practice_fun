puzzle = '105802000090076405200400819019007306762083090000061050007600030430020501600308900'
class Sudoku

  def initialize puzzle_string
    @cells = puzzle_string.chars.map { |number| Cell.new(number) }
    teach_cells_their_neighbors
  end

  def solve
    until solved?
      @cells.each { |cell| cell.eliminate_possibilities! }
    end
  end

  def solution
    @cells.map {|cell| cell.value}.join('')
  end

  private
  def teach_cells_their_neighbors
    @cells.each_with_index do |main_cell, main_index|
      @cells.each_with_index do |other_cell, other_index|
        next if other_index == main_index
        if  other_index % 9 == main_index % 9 ||
            other_index / 9 == main_index / 9 ||
            ((other_index % 9) / 3 == (main_index % 9) / 3 &&
            (other_index / 9) / 3 == (main_index / 9) / 3)
          main_cell.neighbors.push(other_cell)
        end
      end
    end
  end

  def solved?
    !@cells.any? {|cell| cell.value == 0}
  end

end

class Cell
  attr_reader :value, :neighbors

  def initialize value
    @value = value.to_i
    @neighbors = []
    @possibilities = (1..9).to_a
  end

  def eliminate_possibilities!
    return unless @value == 0
    @neighbors.each do |cell|
      @possibilities.delete(cell.value)
    end
    @value = @possibilities[0] if @possibilities.length == 1
  end
end

game = Sudoku.new(puzzle)
game.solve
puts game.solution == '145892673893176425276435819519247386762583194384961752957614238438729561621358947'