defmodule Advent do

  def solve_part_one(path) do
    read(path)
  end

  def test_me(str \\ "5 red, 1 green, 2 blue") do
    separate_into_rounds(str)
  end

  defp separate_into_rounds(raw_round) do
    m = %{}
    # IO.puts("raw: #{raw_round}")
    arr = Regex.scan(~r/(\d+ \w+)+/, raw_round)
    m = create_map(arr, m)
    m
  end

  defp create_map([], m), do: m
  defp create_map([[_, color] | scores], m) do
    [score, color] = String.split(color, " ", trim: true)
    create_map(scores, Map.put(m, String.to_atom(color), String.to_integer(score)))
  end

  defp check([round | rounds], false) do
    check(rounds, Map.get(round, :red, 0) > 12)
      or check(rounds, Map.get(round, :green, 0) > 13)
      or check(rounds, Map.get(round, :blue, 0) > 14)
  end
  defp check([], false), do: false
  defp check([], true), do: true
  defp check([round | rounds], true), do: true

  defp parse_game_data(data) do
    [_, game_id, rounds] = Regex.run(~r/Game (\d+)\: (.+)/, data)
    rounds = String.split(rounds, "; ", trim: true)
      |> Enum.map(&separate_into_rounds/1)

    greens = get_max(rounds, :green)
    reds = get_max(rounds, :red)
    blues = get_max(rounds, :blue)
    map = %{
      id: parse_int(game_id),
      rounds: rounds,
      mins: [reds: reds, greens: greens, blues: blues],
      power: reds * greens * blues
    }

    map
  end

  defp get_max(rounds, key) do
    Enum.map(rounds, fn n -> Map.get(n, key, 1) end) |> Enum.max()
  end

  defp parse_int(""), do: 0
  defp parse_int(int) do
    String.to_integer(int)
  end

  defp part_one(games) do
    res = games
      |> Enum.filter(fn e -> not check(Map.get(e, :rounds), false) end)
      |> Enum.map(fn e -> Map.get(e, :id) end)
      |> Enum.sum()

    IO.puts("PART ONE: #{res} ")
    games
  end

  defp part_two(games) do
    power = games |> Enum.map(fn n -> Map.get(n, :power) end) |> Enum.sum()
    IO.puts("power: #{power}")
    games
  end

  defp read(path) do
    case File.read(path) do
      {:ok, data} -> data
        |> String.split("\n", trim: true)
        |> Enum.map(&parse_game_data/1)
        |> part_one()
        |> part_two()
      _ -> ""
    end
  end
end
# Advent.solve_part_one("./data/day2.txt")
