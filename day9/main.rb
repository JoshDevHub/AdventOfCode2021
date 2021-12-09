# frozen_string_literal: true

# Day 9
class SmokeBasin
  attr_reader :coordinate_hash

  def initialize(input)
    @coordinate_hash = {}
    data = File.readlines(input).map { |element| element.chomp.chars }
    data.each_with_index do |line, x|
      line.each_with_index do |number, y|
        coordinate_hash[x + y.i] = number.to_i unless number == '9'
      end
    end
  end

  def sum_low_values
    find_low_coordinates.map { |key| coordinate_hash[key].succ }.sum
  end

  def basin_size_product
    find_low_coordinates.map { |coord| find_basin_sizes(coord) }.max(3).reduce(&:*)
  end

  private

  def check_adjacent_coords(complex)
    [complex - 1, complex + 1, complex + 1i, complex - 1i].select(&coordinate_hash)
  end

  def find_low_coordinates
    coordinate_hash.select do |c, v|
      check_adjacent_coords(c).all? { |i| v < coordinate_hash[i] }
    end.keys
  end

  def find_basin_sizes(coordinate, basin = {})
    return if basin[coordinate]

    basin[coordinate] = true
    check_adjacent_coords(coordinate)
      .reject(&basin)
      .each { |low_point| find_basin_sizes(low_point, basin) }
    basin.length
  end
end

# Part 1
SmokeBasin.new(ARGV[0]).sum_low_values # -> 417
# Part 2
SmokeBasin.new(ARGV[0]).basin_size_product # -> 1148965
