defmodule Wire.StepsTest do
  use ExUnit.Case
  alias Wire.Steps
  doctest Wire.Steps

  test "example one calculates properly" do
    wire_1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72"
    wire_2 = "U62,R66,U55,R34,D71,R55,D58,R83"

    assert Steps.minimum_steps(wire_1, wire_2) == 610
  end

  test "example two calculates properly" do
    wire_1 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"
    wire_2 = "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    assert Steps.minimum_steps(wire_1, wire_2) == 410
  end
end
