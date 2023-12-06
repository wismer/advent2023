defmodule Advent do
  @coords [
    {-1, -1},
    {-1, 0},
    {-1, 1},
    {0, -1},
    {0, 1},
    {1, -1},
    {1, 0},
    {1, 1},
  ]

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

  def read(path \\ "./data/day3.txt") do
    case File.read(path) do
      {:ok, data} -> data |> part_one()
      _ -> raise "what?"
    end
  end

  defp part_one(data) do
    grid = create_grid(data)
  end

  defp create_grid(data) do
    data
      |> String.split("\n", trim: true)
      |> Enum.map(fn e -> String.split(e, "", trim: true) end)
      |> Enum.with_index(fn row, x ->
        Enum.with_index(row, fn e, y ->
          {e, x, y}
        end)
      end)
  end

  defp map_out_part_numbers(lines) do
    stripped_lines = String.replace(lines, "\n", "")
    numbers = stripped_lines |> scan_numbers() |> List.flatten()
    parts = stripped_lines |> scan_parts()
    lines = String.split(lines, "\n", trim: true) |> List.to_tuple()

    [numbers: numbers, parts: parts, lines: lines]
  end

  defp is_adjacent([part | parts], numbers) do
    parts
  end

  defp scan_parts(line) do
    Regex.scan(~r/([^0-9\.])/, line, return: :index)
      |> Enum.map(fn [{x, _},y] -> x end)
  end

  defp scan_numbers(line) do
    Regex.scan(~r/(\d+)/, line, return: :index)
      |> Enum.map(&into_range/1)
  end

  defp into_range([match_coord, _]) do
    elem(match_coord, 0)..(elem(match_coord, 0) + elem(match_coord, 1) - 1)
  end
end
