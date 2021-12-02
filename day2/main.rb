# frozen_string_literal: true

# Submarine class
class Submarine
  attr_reader :move_list
  attr_accessor :horizontal_position, :depth

  def initialize(input)
    @horizontal_position = 0
    @depth = 0
    @move_list = File.readlines(input).map(&:chomp)
    execute_moves
  end

  def coordinate_product
    horizontal_position * depth
  end

  private

  def move_forward(units)
    self.horizontal_position += units
  end

  def move_up(units)
    self.depth -= units
  end

  def move_down(units)
    self.depth += units
  end

  def move_submarine(direction, units)
    case direction
    when 'up'
      move_up(units)
    when 'down'
      move_down(units)
    when 'forward'
      move_forward(units)
    else
      'Invalid Direction'
    end
  end

  def execute_moves
    move_list.each do |move|
      direction, units = move.split(' ')
      move_submarine(direction, units.to_i)
    end
  end
end

# Sub class for the part2 aim mechanic
class SubmarineWithAim < Submarine
  attr_accessor :aim

  def initialize(input)
    @aim = 0
    super
  end

  private

  def move_up(units)
    self.aim -= units
  end

  def move_down(units)
    self.aim += units
  end

  def move_forward(units)
    super
    self.depth += aim * units
  end
end

# Part 1 Solution
Submarine.new('input.txt').coordinate_product # -> 1855814

# Part 2 Solution
SubmarineWithAim.new('input.txt').coordinate_product # -> 1845455714
