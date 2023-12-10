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
        data = String.split(data, "\n\n", trim: true)
          |> Enum.map(&break_up_sections/1)
          |> Enum.reduce([], &into_map/2)
          |> Enum.reverse()
        [seeds | categories] = data
        seeds[:maps]
          |> Enum.map(fn seed -> get_seed_location(categories, seed) end)
          |> List.to_tuple()
        #   |> case Enum.find(fn [{range, _}] -> start in range end) do
          #   {_, delta} -> start - delta
          #   nil -> start
          # end
          # |> construct_ranges()
          # |> break_into_categories()
          # |> parse_integers()
      {:err, _} -> raise "oops"
    end
  end

  defp get_seed_location([category | categories], seed_location) do
    IO.inspect(category[:label])
    location = process_maps_for_category(Enum.reverse(category[:maps]), seed_location)
    get_seed_location(categories, location)
  end
  defp get_seed_location([], seed_location), do: seed_location

  defp process_maps_for_category([map | maps], location) do
    if location in map[:src] do
      process_maps_for_category(maps, location - (map[:s] - map[:d]))
    else
      process_maps_for_category(maps, location)
    end
  end
  defp process_maps_for_category([], location), do: location

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

    [[label: label, maps: default] | acc]
  end

  defp map_range([[d, s, r] | ranges], rng) do
    dest = d..(d + r)
    src = s..(s + r)
    map_range(ranges, [[
      d: d,
      s: s,
      rng: r,
      dest: dest,
      src: src
    ] | rng])
  end
  defp map_range([], rng), do: rng
end
