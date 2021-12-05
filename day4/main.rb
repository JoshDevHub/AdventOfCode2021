# frozen_string_literal: true

# That's a-bingo
class BingoSubsystem
  attr_reader :random_nums, :boards

  def initialize(input)
    data = File.readlines(input)
    @random_nums = data[0].chomp.split(',')
    @boards = data[2..-1].map { |element| element.chomp.split }
                         .reject(&:empty?)
                         .each_slice(5).to_a
  end

  def calculate_losing_score
    ndx = 0
    loop do
      number_to_mark = random_nums[ndx]
      mark_boards(number_to_mark)
      ndx += 1
      break if check_bingo?(options: 'all')

      boards.reject! { |board| row_col_check?(board) }
    end
    winning_num = random_nums[ndx - 1].to_i
    winning_num * unmarked_sum
  end

  def calculate_winning_score
    ndx = 0
    until check_bingo?(options: 'any')
      number_to_mark = random_nums[ndx]
      mark_boards(number_to_mark)
      ndx += 1
    end
    winning_number = random_nums[ndx - 1].to_i
    winning_number * unmarked_sum
  end

  def mark_boards(number)
    boards.each do |board|
      board.each do |row|
        row.map! { |element| element == number ? "#{element}*" : element }
      end
    end
  end

  def check_bingo?(options:)
    case options
    when 'all'
      boards.all? { |board| row_col_check?(board) }
    when 'any'
      boards.any? { |board| row_col_check?(board) }
    end
  end

  def row_col_check?(board)
    rows = board.any? { |row| row.all? { |item| item.include? '*' } }
    cols = board.transpose.any? { |row| row.all? { |item| item.include? '*' } }
    rows || cols
  end

  def find_winning_board
    boards.find_index { |board| row_col_check?(board) }
  end

  def unmarked_sum
    boards[find_winning_board].flatten
                              .reject { |number| number.include? '*' }
                              .map(&:to_i)
                              .reduce(:+)
  end
end

# Part 1
BingoSubsystem.new(ARGV[0]).calculate_winning_score # -> 67716

# Part 2
BingoSubsystem.new(ARGV[0]).calculate_losing_score # -> 1830
