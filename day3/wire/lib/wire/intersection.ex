defmodule Wire.Intersection do
  @moduledoc """
  Find and perform calculations about intersections between wires on a grid
  """

  @doc """
  Calculate the distance between two wires

  ## Example

    iex> Wire.Intersection("U2,R2", "R2,U2")
    4

  """
  def minimum_distance(wire_1, wire_2) do
    IO.puts("Wire 1: #{wire_1}\nWire 2: #{wire_2}")
    0
  end
end
