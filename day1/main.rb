# frozen_string_literal: true

# Find the keys!
class SonarSweep
  attr_reader :depths

  def initialize
    @depths = File.readlines('input.txt').map(&:to_i)
  end

  def depth_increases
    depths[1..-1].each_with_index.reduce(0) do |memo, (depth, index)|
      depth > depths[index] ? memo + 1 : memo
    end
  end

  def depth_window_increases
    depths[0..-4].each_with_index.reduce(0) do |memo, (_depth, index)|
      current_window = three_measure_slice(depths, index).reduce(:+)
      next_window = three_measure_slice(depths, (index + 1)).reduce(:+)
      next_window > current_window ? memo + 1 : memo
    end
  end

  private

  def three_measure_slice(array, index)
    array[index..(index + 2)]
  end
end

my_sweep = SonarSweep.new
my_sweep.depth_increases # -> 1583
my_sweep.depth_window_increases # -> 1627
