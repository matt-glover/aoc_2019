defmodule Wire.CLI do
  @moduledoc """
  CLI interface to the wire analyzer
  """

  def main(_args \\ []) do
    IO.puts("Starting wire analysis")

    [wire_1 | [wire_2 | []]] =
      File.read!("./input")
      |> String.split()

    distance = Wire.Intersection.minimum_distance(wire_1, wire_2)
    IO.puts("Result: #{distance}")
  end
end
