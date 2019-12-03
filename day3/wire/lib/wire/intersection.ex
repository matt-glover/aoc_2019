defmodule Wire.Intersection do
  @moduledoc """
  Find and perform calculations about intersections between wires on a grid
  """

  @doc """
  Calculate the distance between two wires

  ## Example

    iex> Wire.Intersection.minimum_distance("R8,U5,L5,D3", "U7,R6,D4,L4")
    6

  """
  def minimum_distance(wire_1, wire_2) do
    IO.puts("Wire 1: #{wire_1}\nWire 2: #{wire_2}")
    0
  end
end
