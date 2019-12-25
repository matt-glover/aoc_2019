defmodule Intcode.InstructionTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias Intcode.Instruction

  test "apply_instruction/2 for :add adds two locations and updates the target" do
    program = Intcode.Program.new("1,2,3,3,99")
    instruction = %Instruction{op_code: :add, parameters: {2, 3, 3}}
    %Intcode.Program{memory: updated_memory} = Instruction.apply_instruction(program, instruction)
    assert("1,2,3,5,99" == Intcode.Memory.dump(updated_memory))
  end

  test "apply_instruction/2 for :multiply multiplies two locations and updates the target" do
    program = Intcode.Program.new("2,2,3,3,99")
    instruction = %Instruction{op_code: :multiply, parameters: {2, 3, 3}}
    %Intcode.Program{memory: updated_memory} = Instruction.apply_instruction(program, instruction)
    assert("2,2,3,6,99" == Intcode.Memory.dump(updated_memory))
  end

  test "apply_instruction/2 for :input sets the location to user input" do
    program = Intcode.Program.new("3,1,99")
    instruction = %Instruction{op_code: :input, parameters: {1}}

    capture_io([input: "9876", capture_prompt: false], fn ->
      %Intcode.Program{memory: updated_memory} =
        Instruction.apply_instruction(program, instruction)

      send(self(), {:block_result, Intcode.Memory.dump(updated_memory)})
    end)

    assert_received {:block_result, "3,9876,99"}
  end

  test "apply_instruction/2 for :input trims newline from user input" do
    program = Intcode.Program.new("3,1,99")
    instruction = %Instruction{op_code: :input, parameters: {1}}

    capture_io([input: "9876\n", capture_prompt: false], fn ->
      %Intcode.Program{memory: updated_memory} =
        Instruction.apply_instruction(program, instruction)

      send(self(), {:block_result, Intcode.Memory.dump(updated_memory)})
    end)

    assert_received {:block_result, "3,9876,99"}
  end

  test "apply_instruction/2 for :output prints out the value" do
    program = Intcode.Program.new("4,0,99")
    instruction = %Instruction{op_code: :output, parameters: {4}}

    assert capture_io(fn -> Instruction.apply_instruction(program, instruction) end) ==
             "Output: 4\n"
  end

  test "apply_instruction/2 for :output returns unmodified memory" do
    program = Intcode.Program.new("4,0,99")
    instruction = %Instruction{op_code: :output, parameters: {4}}

    capture_io(fn ->
      result = Instruction.apply_instruction(program, instruction)
      assert program.memory == result.memory
    end)
  end

  test "apply_instruction/2 for :halt returns unmodified program" do
    program = Intcode.Program.new("1,2,1,1,99", 4)
    instruction = %Instruction{op_code: :halt, parameters: {}}
    assert program == Instruction.apply_instruction(program, instruction)
  end
end
