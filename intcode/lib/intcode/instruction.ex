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

  def new(99) do
    %Instruction{op_code: :halt, parameters: {}}
  end

  # TODO: Using this function, .new, Memory.read_instruction is a bit awkward. Consider refactoring.
  def params_for_code(1), do: 3
  def params_for_code(2), do: 3
  def params_for_code(99), do: 0

  @doc """
  Apply an instruction to memory
  """
  def apply_instruction(memory, %Intcode.Instruction{
        op_code: :add,
        parameters: {value_1, value_2, destination}
      }) do
    result = value_1 + value_2
    Intcode.Memory.write_memory(memory, destination, result)
  end

  def apply_instruction(memory, %Intcode.Instruction{
        op_code: :multiply,
        parameters: {value_1, value_2, destination}
      }) do
    result = value_1 * value_2
    Intcode.Memory.write_memory(memory, destination, result)
  end
end
