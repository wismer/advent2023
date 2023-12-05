defmodule Advent do
  def sample_data do
"467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."
  end

  def parts(str) do
    Regex.scan(~r/([^0-9\.\n])/, str, return: :index)
  end

  def part_numbers(str) do
    Regex.scan(~r/(\d+)/, str, return: :index)
  end
end