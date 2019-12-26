defmodule IntCodePocTest do
  use ExUnit.Case
  doctest IntCodePoc

  test "greets the world" do
    assert IntCodePoc.hello() == :world
  end
end
