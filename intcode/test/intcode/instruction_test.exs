defmodule Intcode.InstructionTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
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

  test "new/2 with an op_code of 3 creates an :input instruction" do
    assert(%Instruction{op_code: :input, parameters: {4}} = Instruction.new(3, {4}))
  end

  test "new/2 with an op_code of 4 creates an :output instruction" do
    assert(%Instruction{op_code: :output, parameters: {6}} = Instruction.new(4, {6}))
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

  test "apply_instruction/2 for :add adds two locations and updates the target" do
    memory = Intcode.Memory.new("1,2,3,3,99")
    instruction = %Instruction{op_code: :add, parameters: {2, 3, 3}}
    updated_memory = Instruction.apply_instruction(memory, instruction)
    assert("1,2,3,5,99" == Intcode.Memory.dump(updated_memory))
  end

  test "apply_instruction/2 for :multiply multiplies two locations and updates the target" do
    memory = Intcode.Memory.new("2,2,3,3,99")
    instruction = %Instruction{op_code: :multiply, parameters: {2, 3, 3}}
    updated_memory = Instruction.apply_instruction(memory, instruction)
    assert("2,2,3,6,99" == Intcode.Memory.dump(updated_memory))
  end

  test "apply_instruction/2 for :input sets the location to user input" do
    memory = Intcode.Memory.new("3,1,99")
    instruction = %Instruction{op_code: :input, parameters: {1}}

    capture_io([input: "9876", capture_prompt: false], fn ->
      updated_memory = Instruction.apply_instruction(memory, instruction)
      send(self(), {:block_result, Intcode.Memory.dump(updated_memory)})
    end)

    assert_received {:block_result, "3,9876,99"}
  end

  test "apply_instruction/2 for :output prints out the value" do
    memory = Intcode.Memory.new("4,0,99")
    instruction = %Instruction{op_code: :output, parameters: {4}}

    assert capture_io(fn -> Instruction.apply_instruction(memory, instruction) end) ==
             "Output: 4\n"
  end

  test "apply_instruction/2 for :output returns unmodified memory" do
    memory = Intcode.Memory.new("4,0,99")
    instruction = %Instruction{op_code: :output, parameters: {4}}

    capture_io(fn ->
      assert memory == Instruction.apply_instruction(memory, instruction)
    end)
  end
end
