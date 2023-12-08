defmodule Advent do
  # Established:
  #   1. If the source is WITHIN the _SHARED_ Range of the destination number
  #   2. ... then it means it needs to be shifted x, where x is the range val
  #       ex: seed 79 -> does not fit in the first range, but lies within 50..98
  #       then, the *SHARED* range of the destination number is 52..98
  #       SINCE 79 falls within that range, then it becomes 81. Use that number on the next CATEGORY
  #       OTHERWISE use the number itself if the Source doesn't fall within the range


  def parse(file \\ "./data/day5.txt") do
    case File.read(file) do
      {:ok, data} ->
        String.split(data, "\n\n", trim: true)
          |> Enum.map(&break_up_sections/1)
          |> Enum.reduce(%{}, &into_map/2)
          |>
          # |> construct_ranges()
          # |> break_into_categories()
          # |> parse_integers()
      {:err, _} -> raise "oops"
    end
  end

  defp solve_part_one(p) do
    seeds = Map.get(p, "seeds")

  end

  defp map_seed([seed | seeds], p, )

  defp break_up_sections(unparsed_section) do
    [[p] | r] = Regex.scan(~r/(^[a-z\-]+|\d+)/, unparsed_section, capture: :all_but_first)
    [p, List.flatten(r)]
  end

  defp into_map([label, numbers], acc) do
    default = if label == "seeds" do
      numbers |> Enum.map(&String.to_integer/1)
    else
      numbers
        |> Enum.map(&String.to_integer/1)
        |> Enum.chunk_every(3)
        |> map_range([])
    end
    acc = Map.update(acc, label, default, fn x -> x end)
    acc
  end

  # defp construct_ranges(p) do
  #   for {k, v} <- p, k != "seeds", do: map_range(v, k)
  # end

  defp map_range([[d, s, r] | ranges], rng) do
    dest = d..(d + r - 1)
    src = s..(s + r - 1)
    map_range(ranges, [[
      dest: dest,
      src: src,
      overlap: calc_overlap(d, s, r),
      rng: r
    ] | rng])
  end
  defp map_range([], rng), do: rng

  defp calc_overlap(destination, source, rng) do
    if destination + rng - 1 < source or source + rng - 1 < destination do
      -2..-1
    else
      max(destination, source)..(min(destination + rng, source + rng))
    end
  end

  # defp break_into_categories([category | categories], label) do

  # end

  # defp to_int(str) do
  #   String.split(str, ~r/\n|\s/, trim: true) |> Enum.map(&String.to_integer/1)
  # end

  # defp strip_label(parts, categories \\ [])
  # defp set_label([label | parts], []) do
  #   Regex.scan(~r/(seeds\:) ([\d\s]+)/, part)
  #   String.split(parts, ~r/(\:\n)|\n/, trim: true)
  # end

  # defp parse_numbers(chunk) do
  #   String.split(chunk, ~r/\s/, trim: true) |> Enum.map(&String.to_integer/1)
  # end
end
