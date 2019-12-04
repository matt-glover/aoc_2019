defmodule FindPassword.Matcher do
  @moduledoc """
  Match possible passwords
  """

  @doc """
  Count the possible passwords found within the range of numbers

  ## Examples

    iex> FindPassword.Matcher.count(122345..122345)
    1

  """
  def count(possible_passwords) do
    Enum.filter(possible_passwords, &is_match?/1)
    |> Enum.count()
  end

  def is_match?(candidate) do
    cond do
      candidate < 100_000 -> false
      candidate > 999_999 -> false
      digits_decrease?(candidate) -> false
      no_digit_pairs?(candidate) -> false
      true -> true
    end
  end

  defp digits_decrease?(value) do
    original = Integer.digits(value)

    comparison =
      original
      |> Enum.sort()

    original != comparison
  end

  defp no_digit_pairs?(value) do
    comparison =
      value
      |> Integer.digits()
      |> Enum.dedup()
      |> Integer.undigits()

    value == comparison
  end
end
