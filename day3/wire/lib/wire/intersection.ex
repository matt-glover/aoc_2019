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
    segments_1 =
      parse_wire(wire_1)
      |> generate_line_segments()

    segments_2 =
      parse_wire(wire_2)
      |> generate_line_segments()

    find_intersections(segments_1, segments_2)
    |> calculate_distances()
    |> Enum.min()
  end

  defp parse_wire(raw_wire_path) do
    String.split(raw_wire_path, ",")
  end

  defp generate_line_segments(wire_directions) do
    process_segment([], wire_directions)
  end

  defp process_segment(segments, []) do
    segments
  end

  defp process_segment([], [step | remaining]) do
    new_point = step_to_point(step, {0, 0})

    segments = [
      {{0, 0}, new_point}
    ]

    process_segment(segments, remaining)
  end

  defp process_segment([last_segment | _] = segments, [step | remaining]) do
    last_point = elem(last_segment, 1)
    new_segment = {last_point, step_to_point(step, last_point)}
    segments = [new_segment | segments]
    process_segment(segments, remaining)
  end

  defp step_to_point("R" <> step_distance, {start_x, start_y}) do
    step_distance = String.to_integer(step_distance)
    {start_x + step_distance, start_y}
  end

  defp step_to_point("L" <> step_distance, {start_x, start_y}) do
    step_distance = String.to_integer(step_distance)
    {start_x - step_distance, start_y}
  end

  defp step_to_point("U" <> step_distance, {start_x, start_y}) do
    step_distance = String.to_integer(step_distance)
    {start_x, start_y + step_distance}
  end

  defp step_to_point("D" <> step_distance, {start_x, start_y}) do
    step_distance = String.to_integer(step_distance)
    {start_x, start_y - step_distance}
  end

  defp find_intersections(segments_1, segments_2) do
    IO.puts("Segments 1: #{inspect(segments_1)}")
    IO.puts("Segments 2: #{inspect(segments_2)}")
    [{1, 2}, {3, 5}]
  end

  defp calculate_distances(intersections) do
    Enum.map(intersections, fn x -> 1 end)
  end
end
