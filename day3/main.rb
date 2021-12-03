# frozen_string_literal: true

# Analyzer
class AnalyzeDiagnostics
  attr_reader :diagnostic_report

  def initialize(input)
    @diagnostic_report = File.readlines(input).map { |num| num.chomp.split('') }
  end

  def calculate_power_consumption
    gamma_rate = diagnostic_report.transpose.map { |bits| find_most_frequent_bit(bits) }.join
    epsilon_rate = gamma_rate.gsub(/[10]/, '1' => '0', '0' => '1')
    gamma_rate.to_i(2) * epsilon_rate.to_i(2)
  end

  def calculate_life_support
    find_oxygen_rating * find_carbon_rating
  end

  private

  def find_most_frequent_bit(binary_string)
    binary_string.count('1') >= binary_string.count('0') ? '1' : '0'
  end

  def find_least_frequent_bit(binary_string)
    binary_string.count('0') <= binary_string.count('1') ? '0' : '1'
  end

  def calculate_ratings(&sort_callback)
    diagnostic_copy = diagnostic_report.clone
    ndx = 0
    loop do
      current_column = diagnostic_copy.transpose[ndx]
      bit_to_keep = sort_callback.call(current_column)
      diagnostic_copy.keep_if { |bit| bit[ndx] == bit_to_keep }
      ndx += 1
      break if diagnostic_copy.length == 1
    end
    diagnostic_copy.join.to_i(2)
  end

  def find_carbon_rating
    sort_method = method(:find_least_frequent_bit)
    calculate_ratings(&sort_method)
  end

  def find_oxygen_rating
    sort_method = method(:find_most_frequent_bit)
    calculate_ratings(&sort_method)
  end
end

# Part 1
analyzer = AnalyzeDiagnostics.new(ARGV[0])
analyzer.calculate_power_consumption # -> 342954

# Part 2
analyzer.calculate_life_support # -> 5410338
