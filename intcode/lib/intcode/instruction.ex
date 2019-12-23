defmodule Intcode.Instruction do
  @moduledoc false

  alias Intcode.Instruction

  defstruct [:op_code, :parameters]

  def new(1, parameters = {_input_1, _input_2, _output_location}) do
    %Instruction{op_code: :add, parameters: parameters}
  end

  def new(2, parameters = {_input_1, _input_2, _output_location}) do
    %Instruction{op_code: :multiply, parameters: parameters}
  end

  def new(3, parameters = {_input_destination}) do
    %Instruction{op_code: :input, parameters: parameters}
  end

  def new(4, parameters = {_output_value}) do
    %Instruction{op_code: :output, parameters: parameters}
  end

  def new(99) do
    %Instruction{op_code: :halt, parameters: {}}
  end

  # TODO: Using this function, .new, Memory.read_instruction is a bit awkward. Consider refactoring.
  def params_for_code(1), do: 3
  def params_for_code(2), do: 3
  def params_for_code(3), do: 1
  def params_for_code(4), do: 1
  def params_for_code(99), do: 0

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
      |> String.to_integer()

    Intcode.Memory.write_memory(memory, destination, input)
  end

  def apply_instruction(memory, %Instruction{op_code: :output, parameters: {value}}) do
    IO.puts("Output: #{value}")
    memory
  end
end
