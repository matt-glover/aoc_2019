defmodule FuelCount.CLI do
  @moduledoc """
  CLI interface to the fuel counter
  """

  def main(_args \\ []) do
    IO.puts("Starting")
    result = FuelCount.Requirement.aggregate("./input")
    IO.puts("Result: #{result}")
  end
end
