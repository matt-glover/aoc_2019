defmodule IntCode.CompilerTest do
  use ExUnit.Case
  alias IntCode.Compiler
  doctest IntCode.Compiler

  test "1 + 1 = 2" do
    assert Compiler.run_program("1,0,0,0,99") == [2, 0, 0, 0, 99]
  end

  test "3 * 2 = 6" do
    assert Compiler.run_program("2,3,0,3,99") == [2, 3, 0, 6, 99]
  end

  test "99 * 99 = 9801" do
    assert Compiler.run_program("2,4,4,5,99,0") == [2, 4, 4, 5, 99, 9801]
  end

  test "long example processes properly" do
    assert Compiler.run_program("1,1,1,4,99,5,6,0,99") == [30, 1, 1, 4, 2, 5, 6, 0, 99]
  end
end
