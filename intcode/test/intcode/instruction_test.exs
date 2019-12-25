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

  test "apply_instruction/2 for :add moves the pointer by 4" do
    program = Intcode.Program.new("1,2,3,3,99")
    instruction = %Instruction{op_code: :add, parameters: {2, 3, 3}}

    %Intcode.Program{instruction_pointer: pointer} =
      Instruction.apply_instruction(program, instruction)

    assert(4 == pointer)
  end

  test "apply_instruction/2 for :multiply multiplies two locations and updates the target" do
    program = Intcode.Program.new("2,2,3,3,99")
    instruction = %Instruction{op_code: :multiply, parameters: {2, 3, 3}}
    %Intcode.Program{memory: updated_memory} = Instruction.apply_instruction(program, instruction)
    assert("2,2,3,6,99" == Intcode.Memory.dump(updated_memory))
  end

  test "apply_instruction/2 for :multiply moves the pointer by 4" do
    program = Intcode.Program.new("2,2,3,3,99")
    instruction = %Instruction{op_code: :multiply, parameters: {2, 3, 3}}

    %Intcode.Program{instruction_pointer: pointer} =
      Instruction.apply_instruction(program, instruction)

    assert(4 == pointer)
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

  test "apply_instruction/2 for :input moves the pointer 2" do
    program = Intcode.Program.new("3,1,99")
    instruction = %Instruction{op_code: :input, parameters: {1}}

    capture_io([input: "9876\n", capture_prompt: false], fn ->
      %Intcode.Program{instruction_pointer: updated_pointer} =
        Instruction.apply_instruction(program, instruction)

      send(self(), {:block_result, updated_pointer})
    end)

    assert_received {:block_result, 2}
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

  test "apply_instruction/2 for :output moves the pointer by 2" do
    program = Intcode.Program.new("4,0,99")
    instruction = %Instruction{op_code: :output, parameters: {4}}

    capture_io(fn ->
      result = Instruction.apply_instruction(program, instruction)
      assert 2 == result.instruction_pointer
    end)
  end

  test "apply_instruction/2 for :halt returns unmodified program" do
    program = Intcode.Program.new("1,2,1,1,99", 4)
    instruction = %Instruction{op_code: :halt, parameters: {}}
    assert program == Instruction.apply_instruction(program, instruction)
  end

  test "apply_instruction/2 for :jump_if_true sets the instruction pointer for a non-zero parameter" do
    program = Intcode.Program.new("4,-1,4,1,7,3,4,99")
    instruction = %Instruction{op_code: :jump_if_true, parameters: {-1, 7}}

    %Intcode.Program{instruction_pointer: pointer} =
      Instruction.apply_instruction(program, instruction)

    assert(7 == pointer)
  end

  test "apply_instruction/2 for :jump_if_true moves past the instruction for a zero parameter" do
    program = Intcode.Program.new("4,0,4,1,7,3,4,99")
    instruction = %Instruction{op_code: :jump_if_true, parameters: {0, 7}}

    %Intcode.Program{instruction_pointer: pointer} =
      Instruction.apply_instruction(program, instruction)

    assert(2 == pointer)
  end

  test "apply_instruction/2 for :jump_if_false sets the instruction pointer for a zero parameter" do
    program = Intcode.Program.new("5,0,4,1,7,3,4,99")
    instruction = %Instruction{op_code: :jump_if_false, parameters: {0, 7}}

    %Intcode.Program{instruction_pointer: pointer} =
      Instruction.apply_instruction(program, instruction)

    assert(7 == pointer)
  end

  test "apply_instruction/2 for :jump_if_false moves past the instruction for a non-zero parameter" do
    program = Intcode.Program.new("5,-1,4,1,7,3,4,99")
    instruction = %Instruction{op_code: :jump_if_false, parameters: {-1, 7}}

    %Intcode.Program{instruction_pointer: pointer} =
      Instruction.apply_instruction(program, instruction)

    assert(2 == pointer)
  end

  test "apply_instruction/2 for :less_than stores 1 if first param is less than second" do
    program = Intcode.Program.new("7,2,3,3,99")
    instruction = %Instruction{op_code: :less_than, parameters: {2, 3, 3}}
    %Intcode.Program{memory: updated_memory} = Instruction.apply_instruction(program, instruction)
    assert("7,2,3,1,99" == Intcode.Memory.dump(updated_memory))
  end

  test "apply_instruction/2 for :less_than stores 0 if first param is greater than second" do
    program = Intcode.Program.new("7,4,3,3,99")
    instruction = %Instruction{op_code: :less_than, parameters: {4, 3, 3}}
    %Intcode.Program{memory: updated_memory} = Instruction.apply_instruction(program, instruction)
    assert("7,4,3,0,99" == Intcode.Memory.dump(updated_memory))
  end

  test "apply_instruction/2 for :less_than stores 0 if first param is equal to second" do
    program = Intcode.Program.new("7,2,2,3,99")
    instruction = %Instruction{op_code: :less_than, parameters: {2, 2, 3}}
    %Intcode.Program{memory: updated_memory} = Instruction.apply_instruction(program, instruction)
    assert("7,2,2,0,99" == Intcode.Memory.dump(updated_memory))
  end

  test "apply_instruction/2 for :less_than increments the pointer by 4" do
    program = Intcode.Program.new("7,2,2,3,99")
    instruction = %Instruction{op_code: :less_than, parameters: {2, 2, 3}}

    %Intcode.Program{instruction_pointer: updated_pointer} =
      Instruction.apply_instruction(program, instruction)

    assert(updated_pointer == 4)
  end

  test "apply_instruction/2 for :equals stores 0 if first param is less than second" do
    program = Intcode.Program.new("8,2,3,3,99")
    instruction = %Instruction{op_code: :equals, parameters: {2, 3, 3}}
    %Intcode.Program{memory: updated_memory} = Instruction.apply_instruction(program, instruction)
    assert("8,2,3,0,99" == Intcode.Memory.dump(updated_memory))
  end

  test "apply_instruction/2 for :equals stores 0 if first param is greater than second" do
    program = Intcode.Program.new("8,3,2,3,99")
    instruction = %Instruction{op_code: :equals, parameters: {3, 2, 3}}
    %Intcode.Program{memory: updated_memory} = Instruction.apply_instruction(program, instruction)
    assert("8,3,2,0,99" == Intcode.Memory.dump(updated_memory))
  end

  test "apply_instruction/2 for :equals stores 1 if first param is equal to second" do
    program = Intcode.Program.new("8,2,2,3,99")
    instruction = %Instruction{op_code: :equals, parameters: {2, 2, 3}}
    %Intcode.Program{memory: updated_memory} = Instruction.apply_instruction(program, instruction)
    assert("8,2,2,1,99" == Intcode.Memory.dump(updated_memory))
  end

  test "apply_instruction/2 for :equals increments the pointer by 4" do
    program = Intcode.Program.new("8,2,2,3,99")
    instruction = %Instruction{op_code: :equals, parameters: {2, 2, 3}}

    %Intcode.Program{instruction_pointer: updated_pointer} =
      Instruction.apply_instruction(program, instruction)

    assert(updated_pointer == 4)
  end
end
