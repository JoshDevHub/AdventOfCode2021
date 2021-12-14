# frozen_string_literal: true

# Day 14
class ExtendedPolymerization
  def initialize(input)
    data = File.read(input).split("\n\n")
    @template = data[0]
    @insertions = {}
    data[1].split("\n").each do |insertion|
      k, v = insertion.split(' -> ')
      insertions[k] = v
    end
  end

  def polymerize(steps)
    pairs = tally_pairs
    chars = char_tally
    steps.times do
      new_chars = chars.dup
      new_pairs = pairs.dup
      pair_insertion(pairs, new_pairs, new_chars)
      pairs.merge!(new_pairs)
      chars.merge!(new_chars)
    end
    chars.max_by { |_k, v| v }[1] - chars.min_by { |_k, v| v }[1]
  end

  private

  attr_reader :template, :insertions

  def tally_pairs
    template_pairs = []
    template.chars[0..-2].each_with_index do |char, i|
      template_pairs << char + template[i + 1]
    end
    (insertions.keys + template_pairs).tally.transform_values { |v| v - 1 }
  end

  def char_tally
    (template.chars + insertions.values.uniq).tally.transform_values { |v| v - 1 }
  end

  def pair_insertion(curr_pairs, new_pair, new_chars)
    curr_pairs.each do |k, v|
      next if v.zero?

      new_char = insertions[k]
      new_chars[new_char] += v
      new_pair[k[0] + new_char] += v
      new_pair[new_char + k[1]] += v
      new_pair[k] -= v
    end
  end
end

# Part 1
ExtendedPolymerization.new(ARGV[0]).polymerize(10) # -> 2988
# Part 2
ExtendedPolymerization.new(ARGV[0]).polymerize(40) # -> 3572761917024
