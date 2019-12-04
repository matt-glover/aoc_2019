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
    #       However, they do remember a few key facts about the password:

    #     It is a six-digit number.
    #     The value is within the range given in your puzzle input.
    #     Two adjacent digits are the same (like 22 in 122345).
    #     Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).

    # Other than the range rule, the following are true:

    #     111111 meets these criteria (double 11, never decreases).
    #     223450 does not meet these criteria (decreasing pair of digits 50).
    #     123789 does not meet these criteria (no double).
    false
  end
end
