defmodule Intcode.Instruction do
  @moduledoc false

  alias Intcode.Instruction

  defstruct [:op_code, :parameters]

  def new(:add, parameters = {_input_1, _input_2, _output_location}) do
    %Instruction{op_code: :add, parameters: parameters}
  end

  def new(:multiply, parameters = {_input_1, _input_2, _output_location}) do
    %Instruction{op_code: :multiply, parameters: parameters}
  end

  def new(:input, parameters = {_input_destination}) do
    %Instruction{op_code: :input, parameters: parameters}
  end

  def new(:output, parameters = {_output_value}) do
    %Instruction{op_code: :output, parameters: parameters}
  end

  def new(:jump_if_true, parameters = {_compare_input, _new_pointer}) do
    %Instruction{op_code: :jump_if_true, parameters: parameters}
  end

  def new(:jump_if_false, parameters = {_compare_input, _new_pointer}) do
    %Instruction{op_code: :jump_if_false, parameters: parameters}
  end

  def new(:less_than, parameters = {_input_1, _input_2, _output_location}) do
    %Instruction{op_code: :less_than, parameters: parameters}
  end

  def new(:equals, parameters = {_input_1, _input_2, _output_location}) do
    %Instruction{op_code: :equals, parameters: parameters}
  end

  def new(:halt, {}) do
    %Instruction{op_code: :halt, parameters: {}}
  end

  @doc """
  Apply an instruction to memory
  """
  def apply_instruction(program, %Instruction{
        op_code: :add,
        parameters: {value_1, value_2, destination}
      }) do
    result = value_1 + value_2
    memory = Intcode.Memory.write_memory(program.memory, destination, result)
    %Intcode.Program{memory: memory, instruction_pointer: program.instruction_pointer + 4}
  end

  def apply_instruction(program, %Instruction{
        op_code: :multiply,
        parameters: {value_1, value_2, destination}
      }) do
    result = value_1 * value_2
    memory = Intcode.Memory.write_memory(program.memory, destination, result)
    %Intcode.Program{memory: memory, instruction_pointer: program.instruction_pointer + 4}
  end

  def apply_instruction(program, %Instruction{op_code: :input, parameters: {destination}}) do
    input =
      IO.gets("Input > ")
      |> String.trim()
      |> String.to_integer()

    memory = Intcode.Memory.write_memory(program.memory, destination, input)
    %Intcode.Program{memory: memory, instruction_pointer: program.instruction_pointer + 2}
  end

  def apply_instruction(program, %Instruction{op_code: :output, parameters: {value}}) do
    IO.puts("Output: #{value}")
    %{program | instruction_pointer: program.instruction_pointer + 2}
  end

  def apply_instruction(program, %Instruction{
        op_code: :jump_if_true,
        parameters: {compare_input, new_pointer}
      }) do
    if compare_input == 0 do
      %{program | instruction_pointer: program.instruction_pointer + 2}
    else
      %{program | instruction_pointer: new_pointer}
    end
  end

  def apply_instruction(program, %Instruction{
        op_code: :jump_if_false,
        parameters: {compare_input, new_pointer}
      }) do
    if compare_input == 0 do
      %{program | instruction_pointer: new_pointer}
    else
      %{program | instruction_pointer: program.instruction_pointer + 2}
    end
  end

  def apply_instruction(program, %Instruction{
        op_code: :less_than,
        parameters: {input_1, input_2, destination}
      }) do
    memory =
      if input_1 < input_2 do
        Intcode.Memory.write_memory(program.memory, destination, 1)
      else
        Intcode.Memory.write_memory(program.memory, destination, 0)
      end

    %Intcode.Program{memory: memory, instruction_pointer: program.instruction_pointer + 4}
  end

  def apply_instruction(program, %Instruction{
        op_code: :equals,
        parameters: {input_1, input_2, destination}
      }) do
    memory =
      if input_1 == input_2 do
        Intcode.Memory.write_memory(program.memory, destination, 1)
      else
        Intcode.Memory.write_memory(program.memory, destination, 0)
      end

    %Intcode.Program{memory: memory, instruction_pointer: program.instruction_pointer + 4}
  end

  def apply_instruction(program, %Instruction{op_code: :halt}) do
    program
  end
end
