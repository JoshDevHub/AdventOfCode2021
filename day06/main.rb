# frozen_string_literal: true

# Appeasing rubocop
class LanternFishModel
  attr_reader :school_of_fish

  def initialize(data)
    @school_of_fish = File.read(data).split(',').map(&:to_i)
  end

  def model_growth(days)
    counters = school_of_fish.tally
    days.times do
      counters.transform_keys! { |key| key - 1 }
      new_fish_count = counters.delete(-1) || 0
      counters[8] = new_fish_count
      counters[6].nil? ? counters[6] = new_fish_count : counters[6] += new_fish_count
    end
    counters.values.reduce(:+)
  end
end

LanternFishModel.new(ARGV[0]).model_growth(80) # -> 391888
LanternFishModel.new(ARGV[0]).model_growth(256) # -> 1754597645339
