defmodule Wire.Steps do
  @moduledoc """
  Calculate the number of steps to reach intersections
  """

  @doc """
  Calculate the minimum number of steps to reach an intersection between two wires

  ## Example

    iex> Wire.Steps.minimum_steps("R8,U5,L5,D3", "U7,R6,D4,L4")
    30

  """
  def minimum_steps(wire_1, wire_2) do
    segments_1 = Wire.Intersection.wire_to_segments(wire_1)
    segments_2 = Wire.Intersection.wire_to_segments(wire_2)

    Wire.Intersection.find_intersections(segments_1, segments_2)
    |> Enum.map(fn x -> count_steps(x, segments_1, segments_2) end)
    |> Enum.min()
  end

  defp count_steps(intersection, segments_1, segments_2) do
    1
  end
end
