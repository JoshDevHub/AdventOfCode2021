# frozen_string_literal: true

# Got tired of typing slice
class String
  def take(n)
    slice!(0..(n - 1))
  end
end

# Day 16
class PacketDecoder
  attr_reader :data, :part2

  def initialize(input, part2)
    hex_string = File.read(input).chomp
    @data = hex_string.hex.to_s(2).rjust(hex_string.size * 4, '0')
    @part2 = part2
  end

  def decode_data
    decode_string(data)
  end

  def calculate_transmission
    decode_string(data)
  end

  def decode_string(packet)
    version = packet.take(3).to_i(2)
    type = packet.take(3).to_i(2)
    if type == 4
      accumulator = ''
      while (temp = packet.take(5)).take(1) == '1'
        accumulator.concat(temp)
      end
      return version unless part2

      return (accumulator + temp).to_i(2)

    end
    collection = []
    if packet.take(1) == '0'
      packet = packet.take(packet.take(15).to_i(2))
      collection.push(decode_string(packet)) until packet.empty?
    else
      packet.take(11).to_i(2).times do
        collection.push(decode_string(packet))
      end
    end
    return version + collection.sum unless part2

    case type
    when 0 then collection.sum
    when 1 then collection.reduce(&:*)
    when 2 then collection.min
    when 3 then collection.max
    when 5 then collection[0] > collection[1] ? 1 : 0
    when 6 then collection[0] < collection[1] ? 1 : 0
    when 7 then collection[0] == collection[1] ? 1 : 0
    end
  end
end

# Part1
PacketDecoder.new(ARGV[0], false).decode_data # -> 1002
# Part2
PacketDecoder.new(ARGV[0], true).calculate_transmission # -> 1673210814091
