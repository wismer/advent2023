defmodule Advent do
  def parse(file \\ "./data/day5.txt") do
    case File.read(file) do
      {:ok, data} ->
        String.split(data, "\n\n", trim: true)
          |> Enum.map(&break_up_sections/1)
          |> Enum.reduce(%{}, &into_map/2)
          # |> break_into_categories()
          # |> parse_integers()
      {:err, _} -> raise "oops"
    end
  end

  defp break_up_sections(unparsed_section) do
    [[p] | r] = Regex.scan(~r/(^[a-z\-]+|\d+)/, unparsed_section, capture: :all_but_first)
    [p, List.flatten(r)]
  end

  defp into_map([label, numbers], acc) do
    acc = Map.update(acc, label, Enum.map(numbers, &String.to_integer/1), fn x -> x end)
    acc
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
