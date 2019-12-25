defmodule Intcode.Parser do
  @moduledoc """
  Parser for instructions
  """

  def parse_instruction(memory, address) do
    raw_op_code = Intcode.Memory.read_memory(memory, address)
    {op_code, param_mapping} = Intcode.Parser.translate_op_code(Integer.to_string(raw_op_code))
    parameters = param_lookup(memory, address, param_mapping)
    Intcode.Instruction.new(op_code, parameters)
  end

  @doc """
  Translate raw op codes into parsed codes and position vs immediate mode argument flags

  ## Examples

    iex> Intcode.Parser.translate_op_code("101")
    {:add, [:position, :position, :immediate]}

  """
  def translate_op_code(raw_op_code) do
    prefixed_code = prefix_short_codes(raw_op_code)
    {mode_string, op_number} = String.split_at(prefixed_code, -2)
    op_code = number_to_op_code(op_number)
    param_count = params_for_code(op_code)
    mode_string = String.pad_leading(mode_string, param_count, "0")

    {op_code, param_flags(mode_string, op_code)}
  end

  defp prefix_short_codes(op_code) when byte_size(op_code) == 1 do
    "0#{op_code}"
  end

  defp prefix_short_codes(op_code), do: op_code

  defp number_to_op_code(op_code) do
    case op_code do
      "01" -> :add
      "02" -> :multiply
      "03" -> :input
      "04" -> :output
      "05" -> :jump_if_true
      "06" -> :jump_if_false
      "07" -> :less_than
      "08" -> :equals
      "99" -> :halt
    end
  end

  defp param_lookup(memory, start_address, mapping) do
    parameters =
      mapping
      |> Stream.with_index()
      |> Enum.map(fn
        {param_type, offset} ->
          address = start_address + offset + 1

          case param_type do
            :position ->
              param_address = Intcode.Memory.read_memory(memory, address)
              Intcode.Memory.read_memory(memory, param_address)

            :position_write ->
              Intcode.Memory.read_memory(memory, address)

            :immediate ->
              Intcode.Memory.read_memory(memory, address)
          end
      end)

    List.to_tuple(parameters)
  end

  defp params_for_code(op_code) do
    case op_code do
      :add -> 3
      :multiply -> 3
      :input -> 1
      :output -> 1
      :jump_if_true -> 2
      :jump_if_false -> 2
      :less_than -> 3
      :equals -> 3
      :halt -> 0
    end
  end

  defp param_flags(mode_string, op_code) do
    flags =
      mode_string
      |> String.reverse()
      |> String.codepoints()
      |> Enum.map(fn char ->
        case char do
          "1" -> :immediate
          "0" -> :position
        end
      end)

    case op_code do
      :add ->
        List.replace_at(flags, -1, :position_write)

      :multiply ->
        List.replace_at(flags, -1, :position_write)

      :input ->
        List.replace_at(flags, -1, :position_write)

      :less_than ->
        List.replace_at(flags, -1, :position_write)

      :equals ->
        List.replace_at(flags, -1, :position_write)

      _ ->
        flags
    end
  end
end
