defmodule FindPassword.CLI do
  @moduledoc """
  CLI interface to the password finder
  """

  def main(_args \\ []) do
    puzzle_input = 382_345..843_167
    IO.puts("Starting with: #{inspect(puzzle_input)}")
    count = FindPassword.Matcher.count(puzzle_input)
    IO.puts("Possible password count: #{count}")
  end
end
