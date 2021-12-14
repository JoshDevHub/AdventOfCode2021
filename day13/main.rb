# frozen_string_literal: true

# Day 13
class Origami
  def initialize(input)
    data = File.read(input).split("\n\n")
    @coordinates = data[0].split("\n").map { |coord| coord.split(',').map(&:to_i) }
    @folds = data[1].split("\n").map { |instruction| instruction.gsub('fold along ', '').split('=') }
  end

  def draw_final_grid
    mark_grid
    width, height = determine_final_dimensions
    grid = Array.new(height) { Array.new(width) }
    coordinates.each do |coord|
      x, y = coord
      grid[y][x] = '#'
    end
    grid.each do |row|
      print row
    end
  end

  def first_fold_dot_count
    make_fold(folds[0])
    coordinates.length
  end

  private

  attr_reader :coordinates, :folds

  def make_fold(fold)
    axis, line = fold
    axis == 'y' ? y_fold(line) : x_fold(line)
    coordinates.uniq!
  end

  def determine_final_dimensions
    first = folds[-1][1].to_i
    second = folds[-2][1].to_i
    folds[-1].include?('y') ? [second, first] : [first, second]
  end

  def mark_grid
    folds.each do |fold|
      make_fold(fold)
    end
  end

  def y_fold(line)
    coordinates.each_with_index do |coord_set, i|
      x, y = coord_set
      int_line = line.to_i
      coordinates[i] = if y < int_line
                         coord_set
                       else
                         [x, (y - (int_line * 2)).abs]
                       end
    end
  end

  def x_fold(line)
    coordinates.each_with_index do |coord_set, i|
      x, y = coord_set
      int_line = line.to_i
      coordinates[i] = if x < int_line
                         coord_set
                       else
                         [(x - (int_line * 2)).abs, y]
                       end
    end
  end
end

# Part 1
Origami.new(ARGV[0]).first_fold_dot_count # -> 695
# Part 2
Origami.new(ARGV[0]).draw_final_grid # -> GJZGLUPJ