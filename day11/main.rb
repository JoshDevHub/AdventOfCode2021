# frozen_string_literal: true

# Day 11
class DumboOctopus
  attr_reader :octopus_grid

  def initialize(input)
    @octopus_grid = {}
    data = File.readlines(input)
    data.each_with_index do |line, y|
      line.chomp.chars.each_with_index do |number, x|
        octopus_grid[x + y.i] = number.to_i
      end
    end
  end

  def count_flashes(steps)
    flashes = 0
    steps.times do
      model_flashes
      flashes += octopus_grid.values.count(&:zero?)
    end
    flashes
  end

  def step_when_full_flash
    steps = 0
    until octopus_grid.values.all?(&:zero?)
      model_flashes
      steps += 1
    end
    steps
  end

  private

  def find_adjacents(comp)
    [
      comp + 1, comp - 1, comp + 1i, comp - 1i,
      comp + (1 + 1i), comp + (1 - 1i), comp + (-1 + 1i), comp + (-1 - 1i)
    ].select(&octopus_grid)
  end

  def model_flashes
    octopus_grid.transform_values!(&:succ)
    octopus_grid.each { |k, v| manage_adjacent_energy(k) if v > 9 }
  end

  def manage_adjacent_energy(coord)
    octopus_grid[coord] = 0
    find_adjacents(coord).each do |i|
      octopus_grid[i] += 1 unless octopus_grid[i].zero?
      manage_adjacent_energy(i) if octopus_grid[i] > 9
    end
  end
end

# Part 1
DumboOctopus.new(ARGV[0]).count_flashes(100) # -> 1743
# Part 2
DumboOctopus.new(ARGV[0]).step_when_full_flash # -> 364
