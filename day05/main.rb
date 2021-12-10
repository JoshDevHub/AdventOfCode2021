# frozen_string_literal: true

# Full coordinate plane of a given size
class HydrothermalGrid
  attr_reader :grid, :endpoints

  def initialize(grid_size:, file_input:)
    @grid = Array.new(grid_size) { Array.new(grid_size, 0) }
    @endpoints = File.readlines(file_input).map { |line| line.chomp.split(' -> ') }
  end

  def count_overlap
    grid.reduce(0) { |total, current| total + current.count { |num| num > 1 } }
  end

  def draw_for_each_endpoint
    endpoints.each do |endpoint|
      first_pos = endpoint[0].split(',').map(&:to_i)
      second_pos = endpoint[1].split(',').map(&:to_i)
      draw_coords = draw_line(first_pos, second_pos)
      draw(draw_coords) unless draw_coords.nil?
    end
  end

  private

  def draw_line(first_pos, second_pos)
    x1, y1 = first_pos
    x2, y2 = second_pos
    if x1 == x2
      line_coords = draw_cardinal_line([y1, y2])
      line_coords.map { |number| [number, x1] }
    elsif y1 == y2
      line_coords = draw_cardinal_line([x1, x2])
      line_coords.map { |number| [y1, number] }
    end
  end

  def draw_cardinal_line(coordinates)
    min, max = coordinates.sort
    draw_coords = []
    min.upto(max) { |i| draw_coords << i }
    draw_coords
  end

  def draw(full_coords)
    full_coords.each { |coord| grid[coord[0]][coord[1]] += 1 }
  end
end

# Class with diagonal lines
class GridWithDiagonals < HydrothermalGrid
  def draw_all_lines
    endpoints.each do |endpoint|
      x1, y1 = endpoint[0].split(',').map(&:to_i)
      x2, y2 = endpoint[1].split(',').map(&:to_i)
      if x1 == x2 || y1 == y2
        draw_coords = draw_line([x1, y1], [x2, y2])
        draw(draw_coords)
      else
        full_coords = draw_diagonal_line([x1, y1], [x2, y2])
        draw(full_coords)
      end
    end
  end

  private

  def draw_diagonal_line(first_endpoint, second_endpoint)
    x1, y1 = first_endpoint
    x2, y2 = second_endpoint
    x_coords = []
    y_coords = []
    if x1 > x2
      x1.downto(x2) { |i| x_coords << i }
    elsif x1 < x2
      x1.upto(x2) { |i| x_coords << i }
    end
    if y1 > y2
      y1.downto(y2) { |i| y_coords << i }
    elsif y1 < y2
      y1.upto(y2) { |i| y_coords << i }
    end
    [y_coords, x_coords].transpose
  end
end

part_one = HydrothermalGrid.new(grid_size: 1000, file_input: ARGV[0])
part_one.draw_for_each_endpoint
part_one.count_overlap # -> 7142

part_two = GridWithDiagonals.new(grid_size: 1000, file_input: ARGV[0])
part_two.draw_all_lines
part_two.count_overlap # -> 20012
