defmodule CompTestTest do
  use ExUnit.Case
  doctest CompTest

  test "greets the world" do
    assert CompTest.hello() == :world
  end
end
