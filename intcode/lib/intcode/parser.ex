defmodule Intcode.Parser do
  @moduledoc """
  Parser for instructions
  """

  def parse_instruction(memory, address) do
    op_code = Intcode.Memory.read_memory(memory, address)
    param_count = params_for_code(op_code)

    build_instruction(memory, address, op_code, param_count)
  end

  defp build_instruction(_memory, _address, op_code, 0) do
    Intcode.Instruction.new(op_code)
  end

  defp build_instruction(memory, address, op_code, param_count) do
    parameters =
      Enum.map(1..param_count, fn offset ->
        case offset do
          ^param_count ->
            Intcode.Memory.read_memory(memory, address + offset)

          _ ->
            param_address = Intcode.Memory.read_memory(memory, address + offset)
            Intcode.Memory.read_memory(memory, param_address)
        end
      end)

    Intcode.Instruction.new(op_code, List.to_tuple(parameters))
  end

  defp params_for_code(1), do: 3
  defp params_for_code(2), do: 3
  defp params_for_code(3), do: 1
  defp params_for_code(4), do: 1
  defp params_for_code(99), do: 0
end
