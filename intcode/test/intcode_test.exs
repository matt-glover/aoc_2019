defmodule IntcodeTest do
  use ExUnit.Case

  test "load_program/1 returns an initialized program" do
    assert(%Intcode.Program{} = Intcode.load_program("1,2,3,1,99"))
  end

  test "load_program/1 initializes program memory and points to first instruction" do
    %Intcode.Program{memory: memory, instruction_pointer: pointer} =
      Intcode.load_program("1,2,3,1,99")

    assert %Intcode.Memory{} = memory
    assert pointer == 0
  end

  test "run_program/1 executes the loaded program until it halts" do
    program = Intcode.load_program("1,2,4,0,99")
    assert Intcode.run_program(program) == 103
  end
end
