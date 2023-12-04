defmodule Advent do
  # @numbers ["one" "two" "three" "four" "five" "six" "seven" "eight" "nine"]
  # @letters ["o", "t", "s", "e", "n", "f"]
  # @numbers [
  #   3:    [1, 6, 2],
  #   four: [5, 4, 9],
  #   five: [7, 8, 3]
  # ]

  @number_map %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }


  def test_fuck(target, [num | nums]) do
    if num == target do
      test_fuck(target,
    end
    test_fuck(target, nums)
  end

  def test_fuck(target, []), do: "I HATE THIS"


  def solve_part_one(input_path) do
    File.read(input_path)
      |> sanitize()
      |> Enum.map(&start_part_one/1)
      |> Enum.reduce(0, fn n, acc -> n + acc end)
  end

  def solve_part_two(input_path) do
    File.read(input_path)
      |> sanitize_part_two()
      |> Enum.map(&read_line/1)
      |> Enum.reduce(0, fn {l, r}, acc ->
        String.to_integer("#{l}#{r}")
      end)
  end

  defp find_number(str, idx, :left) do
    c = String.at(str, idx)
  end

  defp find_number(str, idx, :right, val) when is_nil(val) do
    c = String.at(str, idx)

    if parse_int(c) do
      find_number(str, idx, :right, c)
    else
      find_alpha(str, idx + 1)
    end
  end

  defp find_alpha(str, idx, :right, val \\ nil) when is_nil(val) do

  end

  defp find_alpha(str, idx, :right, val), do: val

  defp find_number(str, idx, :right, val), do: val

  def read_line(str) do
    if String.length(str) == 0 do
      raise "problem"
    end
    leftmost = find_number(str, 0, :left)
    rightmost = find_number(str, String.length(str) - 1, :right)
    keys = Map.keys(@number_map)
    {left, _} = has_alpha_match(str, 0, keys, {nil, nil})
    {right, r} = has_alpha_match(str, String.length(str) - 1, keys, {left, nil})
    if is_nil(right) and is_nil(r) and is_nil(left) do
      raise "problemmmmm #{str}"
    end
    {right, r}
  end

  def check_type(str, idx) do
    c = String.at(str, idx)
    if parse_int(c) do

    else

    end
  end

  def test_alpha(idx) do
    has_alpha_match("onefivesix3ncll3hcrpsdmtpxvnine9sdaf", idx, Map.keys(@number_map), {nil, nil})
  end

  defp get_slice(str, idx, length, :right) do
    String.slice(str, idx, length)
  end

  defp get_slice(str, idx, length, :left) do
    String.slice(str, idx - length + 1, length)
  end

  defp has_alpha_match(str, idx, [key | keys], val \\ nil) when is_nil(val) do
    len = String.length(key)
    slice = get_slice(str, idx, len, :right)
    if slice == key do
      has_alpha_match(str, idx, [], Map.get(@number_map, key))
    else
      has_alpha_match(str, idx, keys)
    end
  end

  defp has_alpha_match(str, idx, [key | keys], {n, f}) when is_nil(f) do
    len = String.length(key)
    slice = get_slice(str, idx, len, :left)
    # IO.puts("TEST slice: #{slice}, idx: #{idx}, len: #{len}")
    if slice == key do
      has_alpha_match(str, idx, [], {n, Map.get(@number_map, key)})
    else
      has_alpha_match(str, idx, keys, {n, f})
    end
  end

  defp has_alpha_match(str, idx, [], nil), do: nil
  defp has_alpha_match(str, idx, [], val), do: val

  def take_three(str, idx, left: n, right: nil) do
    c = String.at(str, idx)
  end


  def take_two(str, idx, {nil, nil}) do
    c = String.at(str, idx)
    if parse_int(c) do
      take_two(str, String.length(str) - 1, {c, nil})
      # take_two(str, String.length(str) - 1, {c, nil})
    else
      alpha = we_have_it_joe(str, idx, Map.keys(@number_map), {nil, nil})
      if alpha do
        take_two(str, String.length(str), {alpha, nil})
      else
        take_two(str, idx + 1, {nil, nil})
      end
    end
  end

  def take_two(str, idx, {f, nil}) do
    if idx < 0 do
      raise "too far: #{f}"
    end
    c = String.at(str, idx)
    if parse_int(c) do
      take_two(str, idx, {f, c})
    else
      alpha = we_have_it_joe(str, idx, Map.keys(@number_map), {f, nil})
      if alpha do
        take_two(str, String.length(str) - 1, {f, alpha})
      end
      take_two(str, idx - 1, {f, nil})
    end
  end

  def take_two(str, idx, {f, n}), do: {f, n}

  defp we_have_it_joe(str, idx, [key | keys], {nil, nil}) do
    key_len = String.length(key)
    slice = String.slice(str, idx, String.length(key))
    # IO.puts("SLICE #{slice}, KEY: #{key}, idx: #{idx}")
    if slice == key do
      Map.get(@number_map, key)
    else
      we_have_it_joe(str, idx, keys, {nil, nil})
    end
  end

  defp we_have_it_joe(str, idx, [key | keys], {f, nil}) do
    key_len = String.length(key)
    slice = String.slice(str, idx - key_len, key_len)
    if slice == key do
      we_have_it_joe(str, idx, [], {f, Map.get(@number_map, key)})
    else
      we_have_it_joe(str, idx, keys, {f, nil})
    end
  end

  defp we_have_it_joe(str, idx, [], {f, n}), do: {f, n}

  defp check(str, idx, {nil, nil}) do
    c = String.at(str, idx)
    # check for digit
    parsed = parse_int(c)
    IO.puts("INDEX: " <> Integer.to_string(idx))

    if parsed do
      check(str, String.length(str) - 1, {c, nil})
    else
      {c, str_len} = case c do
        "o" -> check_depth(str, idx, [{"one", "1"}])
        "t" -> check_depth(str, idx, [{"three", "3"}, {"two", "2"}])
        "s" -> check_depth(str, idx, [{"six", "6"}, {"seven", "7"}])
        "e" -> check_depth(str, idx, [{"eight", "8"}])
        "n" -> check_depth(str, idx, [{"nine", "9"}])
        "f" -> check_depth(str, idx, [{"four", "4"}, {"five", "5"}])
        _ -> {nil, nil}
      end
      IO.puts("length: #{str_len}, c: #{c}")
      if c do
        check(str, String.length(str) - 1, {c, nil})
      end
    end

    check(str, idx + 1, {nil, nil})
  end

  defp check(str, idx, {first, second}) when is_nil(second) do
    if idx < 0 do
      raise "out of bounds #{idx} #{first}"
    end

    IO.puts("RIGHT HAND CHECK INDEX: " <> Integer.to_string(idx))

    c = String.at(str, idx)
    parsed = parse_int(c)
    if parsed do
      check(str, idx, {first, c})
    else
      {c, str_len} = case c do
        "e" -> check_depth(str, -idx, [{"three", "3"}, {"one", "1"}, {"five", "5"}, {"nine", "9"}])
        "o" -> check_depth(str, -idx, [{"two", "2"}])
        "n" -> check_depth(str, -idx, [{"seven", "7"}])
        "t" -> check_depth(str, -idx, [{"eight", "8"}])
        "x" -> check_depth(str, -idx, [{"six", "6"}])
        "r" -> check_depth(str, -idx, [{"four", "4"}])
        _ -> {nil, nil}
      end

      IO.puts("C: #{c}, first: #{first}, idx: #{idx}")
    end
    if c do
      check(str, idx, {first, c})
    else
      check(str, idx - 1, {first, nil})
    end
  end

  defp check(str, idx, {first, second}), do: {first, second}


  defp check_depth(str, idx, [{num_str, num} | rest]) when idx < 0 do
    idx = idx * -1
    str_len = String.length(num_str)
    if str_len - idx < 0 do
      {nil, nil}
    end

    n = String.slice(str, idx - str_len + 1, str_len)
    IO.puts("n: #{n} num_str: #{num_str}, num: #{num}")
    if n == num_str do
      {num, String.length(num_str)}
    else
      {nil, nil}
    end
  end

  defp check_depth(str, idx, [{num_str, num} | rest]) do
    n = String.slice(str, idx..(idx + String.length(num_str) - 1))
    IO.puts("SLICE: #{n}, num_str: #{num_str}, idx: #{idx}")
    if n == num_str do
      {num, String.length(num_str)}
    else
      {nil, nil}
    end
  end

  defp check_depth(str, idx, []), do: {nil, nil}



  defp start_part_one(chars) do
    parse_line({nil, nil}, chars)
  end

  defp parse_line({first, second}, [c | rest]) when is_nil(first) do
    parse_line({parse_int(c), nil}, rest)
  end

  defp parse_line({first, second}, [c | rest]) do
    curr = parse_int(c)
    if curr do
      parse_line({first, curr}, rest)
    else
      parse_line({first, second}, rest)
    end
  end

  defp parse_line({first, nil}, []), do: String.to_integer(first <> first)
  defp parse_line({first, second}, []), do: String.to_integer(first <> second)

  defp sanitize({:ok, data}) do
    String.split(data, "\n") |> Enum.map(fn line -> String.split(line, "", trim: true) end)
  end

  defp sanitize_part_two({:ok, data}) do
    String.split(data, "\n")
  end

  defp sanitize_part_two({:err, _}), do: IO.puts("OOPS")

  defp parse_int(c) do
    n = try do
      String.to_integer(c)
    rescue
      ArgumentError -> nil
    end

    if n do
      c
    else
      nil
    end
  end

  defp sanitize({:err, _}) do
    IO.puts("INCORRECT PATH")
  end

  defp get_digits(line) do
    idx = 0
    n = 0
    String.get(line, idx)
      |> String.to_integer()
  end


  defp get_digits(line, idx) do
    c = String.get(line, idx)

    # try do
    #   String.to_integer(c)
    # rescue

    # end
  end

end
