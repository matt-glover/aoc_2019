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
    steps =
      segments_1
      |> Enum.reverse()
      |> Enum.reduce_while(0, fn current_segment, acc ->
        {term, steps} = calc_steps_and_halt(current_segment, intersection)
        {term, acc + steps}
      end)

    segments_2
    |> Enum.reverse()
    |> Enum.reduce_while(steps, fn current_segment, acc ->
      {term, steps} = calc_steps_and_halt(current_segment, intersection)
      {term, acc + steps}
    end)
  end

  defp calc_steps_and_halt({{x1, y1}, {x2, y2}} = segment, {t1, t2} = target) do
    if Wire.Intersection.point_on_segment(segment, target) do
      # Steps to the target
      {:halt, abs(x1 - t1) + abs(y1 - t2)}
    else
      # Steps across the segment
      {:cont, abs(x1 - x2) + abs(y1 - y2)}
    end
  end
end
