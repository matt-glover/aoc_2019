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
  def apply_instruction(memory, %Instruction{
        op_code: :add,
        parameters: {value_1, value_2, destination}
      }) do
    result = value_1 + value_2
    Intcode.Memory.write_memory(memory, destination, result)
  end

  def apply_instruction(memory, %Instruction{
        op_code: :multiply,
        parameters: {value_1, value_2, destination}
      }) do
    result = value_1 * value_2
    Intcode.Memory.write_memory(memory, destination, result)
  end

  def apply_instruction(memory, %Instruction{op_code: :input, parameters: {destination}}) do
    input =
      IO.gets("Input > ")
      |> String.trim()
      |> String.to_integer()

    Intcode.Memory.write_memory(memory, destination, input)
  end

  def apply_instruction(memory, %Instruction{op_code: :output, parameters: {value}}) do
    IO.puts("Output: #{value}")
    memory
  end
end
