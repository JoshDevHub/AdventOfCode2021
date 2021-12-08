# frozen_string_literal: true

# Crab sub handler
class CrabSubs
  attr_reader :crab_positions, :total_positions

  def initialize(data)
    @crab_positions = File.read(data).split(',').map(&:to_i)
    @total_positions = [*0..(crab_positions.max)]
  end

  def fuel_counter
    results = []
    crab_positions.each do |position|
      results << find_difference(position)
    end
    results.transpose
           .map { |array| array.reduce(:+) }
           .min
  end

  def new_fuel_counter
    results = []
    crab_positions.each do |position|
      results << find_new_difference(position)
    end
    results.transpose
           .map { |array| array.reduce(:+) }
           .min
  end

  private

  def find_difference(curr_element)
    total_positions.map { |element| (curr_element - element).abs }
  end

  def find_new_difference(curr_element)
    total_positions.map do |element|
      part_one = (curr_element - element).abs
      [*(0..part_one)].reduce(:+)
    end
  end
end

p CrabSubs.new(ARGV[0]).fuel_counter # -> 341534
p CrabSubs.new(ARGV[0]).new_fuel_counter # -> 93397632
