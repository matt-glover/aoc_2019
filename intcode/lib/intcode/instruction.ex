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

  def apply_instruction(program, %Instruction{op_code: :halt}) do
    program
  end
end
