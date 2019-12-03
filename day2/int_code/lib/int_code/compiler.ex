defmodule IntCode.Compiler do
  @moduledoc """
  IntCode processor
  """

  @doc """
  Process the source code and return the resulting code.

  ## Examples

    iex> IntCode.Compiler.run_program("1,9,10,3,2,3,11,0,99,30,40,50")
    "3500,9,10,70,2,3,11,0,99,30,40,50"

  """
  def run_program(source_code) do
    parsed =
      String.split(source_code, ",")
      |> Enum.map(fn x -> String.to_integer(x) end)

    result = execute_code(0, parsed)

    Enum.join(result, ",")
  end

  defp execute_code(current_index, code) do
    segment = List.to_tuple(Enum.slice(code, current_index, 4))

    case process_segment(segment, code) do
      :exit -> code
      processed_code -> execute_code(current_index + 4, processed_code)
    end
  end

  defp process_segment(segment, _source) when elem(segment, 0) == 99 do
    :exit
  end

  defp process_segment({1, input_index_1, input_index_2, output_index}, full_source) do
    value = Enum.at(full_source, input_index_1) + Enum.at(full_source, input_index_2)
    List.replace_at(full_source, output_index, value)
  end

  defp process_segment({2, input_index_1, input_index_2, output_index}, full_source) do
    value = Enum.at(full_source, input_index_1) * Enum.at(full_source, input_index_2)
    List.replace_at(full_source, output_index, value)
  end
end