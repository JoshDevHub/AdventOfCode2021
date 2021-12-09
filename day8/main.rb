# frozen_string_literal: true

class SevenSegmentSearch
  attr_reader :signal_out, :full_data

  def initialize(input)
    data = File.readlines(input)
    @full_data = data.map(&:chomp)
    @signal_out = data.map { |values| values.split(' | ')[1].split }
  end

  def sum_unique_output
    signal_out.map { |values| values.count { |value| [2, 3, 4, 7].include?(value.length) } }.sum
  end

  def sum_output
    output = decode
    output.map(&:join).map(&:to_i).sum
  end

  private

  def unique_numbers(values)
    map = {}
    map['1'] = values.find { |value| value.length == 2 }
    map['7'] = values.find { |value| value.length == 3 }
    map['4'] = values.find { |value| value.length == 4 }
    map['8'] = values.find { |value| value.length == 7 }
    map
  end

  def finish_map(map, values)
    values.each do |value|
      case value.length
      when 5
        if (value.chars - map['1'].chars).length == 3
          map['3'] = value
        elsif (value.chars - map['4'].chars).length == 2
          map['5'] = value
        else
          map['2'] = value
        end
      when 6
        if (value.chars - map['4'].chars).length == 2
          map['9'] = value
        elsif (value.chars - map['7'].chars).length == 3
          map['0'] = value
        else
          map['6'] = value
        end
      end
    end
    map.invert.transform_keys { |key| key.chars.sort.join }
  end

  def decode
    full_data.map do |line|
      codes = unique_numbers(line.split(' | ')[0].split)
      new_codes = finish_map(codes, line.split(' | ')[0].split)
      output = line.split(' | ')[1].split
      output.map do |display|
        sorted_display = display.chars.sort.join
        new_codes[sorted_display]
      end
    end
  end
end

# Part 1
SevenSegmentSearch.new(ARGV[0]).sum_unique_output # -> 495
# Part 2
SevenSegmentSearch.new(ARGV[0]).sum_output # -> 1055164