defmodule Advent do
  def read(path \\ "../data/day4.txt") do

  end

  defp score_card([w_num | winning_nums], nums, scores) do
    if w_num in nums do
      score_val = cond do
        List.first(scores) == 1 -> 2
        _ -> 1
      end
      score_card(winning_nums, nums, [2 | scores])
    else
      score_card(winning_nums, nums, scores)
    end
  end

  defp score_card([], nums, scores) do
    score_sum = 0
    for score <- scores do
      score_sum = score_
    end
  end
end
