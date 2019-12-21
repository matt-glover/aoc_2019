defmodule Intcode.InstructionTest do
  use ExUnit.Case
  alias Intcode.Instruction

  test "new/1 with an op_code of 99 creates a :halt instruction" do
    assert(%Instruction{op_code: :halt} = Instruction.new(99))
  end

  test "new/2 with an op_code of 1 creates an :add instruction" do
    assert(%Instruction{op_code: :add, parameters: {1, 2, 3}} = Instruction.new(1, {1, 2, 3}))
  end

  test "new/2 with an op_code of 2 creates an :multiply instruction" do
    assert(
      %Instruction{op_code: :multiply, parameters: {4, 5, 6}} = Instruction.new(2, {4, 5, 6})
    )
  end

  test "params_for_code/1 returns 3 parameters for add instruction" do
    assert(3 == Instruction.params_for_code(1))
  end

  test "params_for_code/1 returns 3 parameters for multiply instruction" do
    assert(3 == Instruction.params_for_code(2))
  end

  test "params_for_code/1 returns 0 parameters for halt instruction" do
    assert(0 == Instruction.params_for_code(99))
  end
end
