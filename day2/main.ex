defmodule Advent do
  def read(path \\ "./data/day3.txt") do
    case File.read(path) do
      {:ok, data} -> p1(data)
      {:err, _} -> raise "oops"
    end
  end

  def p1(input) do
    grid =
      input
      |> String.split("\n")
      |> Enum.map(&String.to_charlist/1)
      |> to_grid()

    {_, part_numbers} =
      for {coord, symb} <- grid,
          is_binary(symb),
          neighbor_coord <- neighboring_coords(coord),
          reduce: {MapSet.new(), []} do
        {seen, part_numbers} ->
          case Map.get(grid, neighbor_coord) do
            {id, n} ->
              if MapSet.member?(seen, id) do
                {seen, part_numbers}
              else
                {MapSet.put(seen, id), [n | part_numbers]}
              end

            _ ->
              {seen, part_numbers}
          end
      end

    part_numbers
    |> Enum.sum()
  end

  def p2(input) do
    grid =
      input
      |> String.split("\n")
      |> Enum.map(&String.to_charlist/1)
      |> to_grid()

    for {coord, "*"} <- grid, is_gear(grid, coord), reduce: 0 do
      sum ->
        {_, [a, b]} = neighboring_numbers(grid, coord)
        sum + a * b
    end
  end

  def to_grid(lines) do
    {grid, [], nil, _} =
      for {line, i} <- Enum.with_index(lines),
          {char, j} <- Enum.with_index(line),
          reduce: {Map.new(), [], nil, 0} do
        {acc, digits, l, id} ->
          case {char, digits, l} do
            {c, digits, curr} when c in ?0..?9 and curr in [i, nil] ->
              {acc, [{{i, j}, c} | digits], i, id}

            {c, digits, _} when c in ?0..?9 ->
              {insert_number_into_grid(acc, digits, id), [{{i, j}, c}], i, id + 1}

            {?., [], _} ->
              {acc, [], nil, id}

            {?., digits, _} ->
              {insert_number_into_grid(acc, digits, id), [], nil, id + 1}

            {c, [], _} ->
              {Map.put(acc, {i, j}, List.to_string([c])), [], nil, id}

            {c, digits, _} ->
              {
                acc
                |> Map.put({i, j}, List.to_string([c]))
                |> insert_number_into_grid(digits, id),
                [],
                nil,
                id + 1
              }
          end
      end

    grid
  end

  def insert_number_into_grid(grid, coords_and_digits, id) do
    {coords, rev_digits} = Enum.unzip(coords_and_digits)

    number =
      rev_digits
      |> Enum.reverse()
      |> List.to_string()
      |> String.to_integer()

    Stream.zip(coords, Stream.repeatedly(fn -> {id, number} end))
    |> Enum.into(%{})
    |> Map.merge(grid)
  end

  def neighboring_coords({i, j}) do
    for y <- [i - 1, i, i + 1], x <- [j - 1, j, j + 1], {y, x} != {i, j}, y >= 0, x >= 0 do
      {y, x}
    end
  end

  def neighboring_numbers(grid, coord, already_seen \\ MapSet.new()) do
    for c <- neighboring_coords(coord), reduce: {already_seen, []} do
      {seen, numbers} ->
        case Map.get(grid, c) do
          {id, n} ->
            if MapSet.member?(seen, id) do
              {seen, numbers}
            else
              {MapSet.put(seen, id), [n | numbers]}
            end

          _ ->
            {seen, numbers}
        end
    end
  end

  def is_gear(grid, coord) do
    case neighboring_numbers(grid, coord) do
      {_, [_, _]} -> true
      _ -> false
    end
  end

  # def solve_part_one(path) do
  #   read(path)
  # end

  # def test_me(str \\ "5 red, 1 green, 2 blue") do
  #   separate_into_rounds(str)
  # end

  # defp separate_into_rounds(raw_round) do
  #   m = %{}
  #   # IO.puts("raw: #{raw_round}")
  #   arr = Regex.scan(~r/(\d+ \w+)+/, raw_round)
  #   m = create_map(arr, m)
  #   m
  # end

  # defp create_map([], m), do: m
  # defp create_map([[_, color] | scores], m) do
  #   [score, color] = String.split(color, " ", trim: true)
  #   create_map(scores, Map.put(m, String.to_atom(color), String.to_integer(score)))
  # end

  # defp check([round | rounds], false) do
  #   check(rounds, Map.get(round, :red, 0) > 12)
  #     or check(rounds, Map.get(round, :green, 0) > 13)
  #     or check(rounds, Map.get(round, :blue, 0) > 14)
  # end
  # defp check([], false), do: false
  # defp check([], true), do: true
  # defp check([round | rounds], true), do: true

  # defp parse_game_data(data) do
  #   [_, game_id, rounds] = Regex.run(~r/Game (\d+)\: (.+)/, data)
  #   rounds = String.split(rounds, "; ", trim: true)
  #     |> Enum.map(&separate_into_rounds/1)

  #   greens = get_max(rounds, :green)
  #   reds = get_max(rounds, :red)
  #   blues = get_max(rounds, :blue)
  #   map = %{
  #     id: parse_int(game_id),
  #     rounds: rounds,
  #     mins: [reds: reds, greens: greens, blues: blues],
  #     power: reds * greens * blues
  #   }

  #   map
  # end

  # defp get_max(rounds, key) do
  #   Enum.map(rounds, fn n -> Map.get(n, key, 1) end) |> Enum.max()
  # end

  # defp parse_int(""), do: 0
  # defp parse_int(int) do
  #   String.to_integer(int)
  # end

  # defp part_one(games) do
  #   res = games
  #     |> Enum.filter(fn e -> not check(Map.get(e, :rounds), false) end)
  #     |> Enum.map(fn e -> Map.get(e, :id) end)
  #     |> Enum.sum()

  #   IO.puts("PART ONE: #{res} ")
  #   games
  # end

  # defp part_two(games) do
  #   power = games |> Enum.map(fn n -> Map.get(n, :power) end) |> Enum.sum()
  #   IO.puts("power: #{power}")
  #   games
  # end

  # defp read(path) do
  #   case File.read(path) do
  #     {:ok, data} -> data
  #       |> String.split("\n", trim: true)
  #       |> Enum.map(&parse_game_data/1)
  #       |> part_one()
  #       |> part_two()
  #       _ -> ""
  #   end
  # end
end
# Advent.solve_part_one("./data/day2.txt")
