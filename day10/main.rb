# frozen_string_literal: true

# Day 10
class SyntaxChecker
  attr_reader :errors, :lines_to_complete

  def initialize(input)
    data = File.readlines(input).map(&:chomp)
    @errors = data.map { |line| find_line_errors(line) }.compact.flatten
    @lines_to_complete = data.select { |line| find_line_errors(line).empty? }
  end

  def calculate_syntax_error_score
    errors.map { |char| illegal_char_score_map[char] }.sum
  end

  def calculate_automcomplete_score
    sort_comp_lines = line_endings.map { |line| automcomplete_line_totals(line) }.sort
    sort_comp_lines[sort_comp_lines.length / 2]
  end

  private

  def char_pair_map
    {
      ')' => '(',
      ']' => '[',
      '}' => '{',
      '>' => '<'
    }
  end

  def illegal_char_score_map
    {
      ')' => 3,
      ']' => 57,
      '}' => 1197,
      '>' => 25_137
    }
  end

  def complete_line_score_map
    {
      '(' => 1,
      '[' => 2,
      '{' => 3,
      '<' => 4
    }
  end

  def find_line_errors(line)
    open_memo = []
    line.chars.each_with_object([]) do |char, errors|
      open_memo << char if char_pair_map.values.include?(char)
      if char_pair_map.keys.include?(char)
        errors << char unless open_memo[-1] == char_pair_map[char]
        open_memo.pop
      end
    end
  end

  def line_endings
    lines_to_complete.map do |line|
      open_memo = []
      opening, closing = [char_pair_map.values, char_pair_map.keys]
      line.chars.each do |char|
        open_memo << char if opening.include?(char)
        open_memo.pop if closing.include?(char)
      end
      open_memo.reverse
    end
  end

  def automcomplete_line_totals(line)
    line.reduce(0) do |memo, current|
      char_points = complete_line_score_map[current]
      memo * 5 + char_points
    end
  end
end

# Part 1
p SyntaxChecker.new(ARGV[0]).calculate_syntax_error_score # -> 278475
# Part 2
p SyntaxChecker.new(ARGV[0]).calculate_automcomplete_score # -> 3015539998
