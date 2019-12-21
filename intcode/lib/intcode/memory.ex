defmodule Intcode.Memory do
  @moduledoc false
  defstruct map: %{}

  def new(source_code) do
    parsed =
      String.split(source_code, ",")
      |> Enum.map(fn x -> String.to_integer(x) end)

    memory_map =
      parsed
      |> Stream.with_index()
      |> Map.new(fn {value, index} -> {index, value} end)

    %Intcode.Memory{map: memory_map}
  end

  def read_memory(memory, address) do
    memory.map[address]
  end

  def read_instruction(memory, address) do
    op_code = Intcode.Memory.read_memory(memory, address)
    param_count = Intcode.Instruction.params_for_code(op_code)

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
end
