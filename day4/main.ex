defmodule Advent do
  def read(path \\ "./data/day4.txt") do
    case File.read(path) do
      {:err, _} -> raise "?"
      {:ok, data} ->
        data = data
          |> String.split("\n", trim: true)
          |> Enum.map(&strip_card/1)
          |> Enum.map(&parse_line/1)


        [part_one: Enum.sum(part_one(data)), part_two: Enum.sum(part_two(data))]
    end
  end

  defp part_one(parsed_lines) do
    parsed_lines
      |> Enum.map(fn nums ->
        solve_part_one(nums, [])
      end)
  end

  defp part_two(parsed_lines) do
    lines = Enum.with_index(parsed_lines, 1)
    size = Enum.count(lines)
    m = %{}
    m = set_winning_nums(lines, m)

    for i <- 1..size, do: count_cards(Map.get(m, i, []), m)
  end

  defp count_cards([n | cards], m, count \\ 1) do
    # if count > 30, do: raise "oops"
    v = Map.get(m, n)
    if v do
      count_cards(v ++ cards, m, count + 1)
    else
      count_cards(cards, m, count)
    end
  end
  defp count_cards([], m, count), do: count

  defp set_winning_nums([{{winning, player}, i} | parsed_lines], m) do
    w = Enum.count(winning, fn w -> w in player end)

    r = if w != 0 do
      Range.to_list((i + 1)..(w + i))
    else
      []
    end
    m = Map.update(m, i, r, fn _ -> r end)
    set_winning_nums(parsed_lines, m)
  end

  defp set_winning_nums([], m), do: m

  # I probably need to keep track of the card numbers...
  defp strip_card(line) do
    String.replace(line, ~r/Card\s+\d+\: /, "")
  end

  defp parse_line(line) do
    [winning, player] = String.split(line, " | ", trim: true)
    winning = String.split(winning, ~r/\s+/, trim: true)
      |> Enum.map(&String.to_integer/1)

    player = String.split(player, ~r/\s+/, trim: true)
      |> Enum.map(&String.to_integer/1)

    {winning, player}
  end

  defp solve_part_one({winning_nums, player_nums}, nums) do
    winning_nums
      |> Enum.with_index(1)
      |> Enum.filter(fn {e, _i} -> e in player_nums end)
      |> tally_points(0)
  end

  defp tally_points([_score | scores], 0) do
    tally_points(scores, 1)
  end

  defp tally_points([_score | scores], n) do
    tally_points(scores, n * 2)
  end

  defp tally_points([], n), do: n
end
